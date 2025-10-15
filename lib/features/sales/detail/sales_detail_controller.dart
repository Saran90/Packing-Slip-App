import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/api/sales/models/update_sales_request.dart';
import 'package:packing_slip_app/features/sales/models/sales.dart';
import 'package:packing_slip_app/utils/extensions.dart';
import 'package:toastification/toastification.dart';

import '../../../api/error_response.dart';
import '../../../api/sales/sales_api.dart';
import '../../../data/error/failures.dart';
import '../../../utils/messages.dart';
import '../../../utils/routes.dart';
import '../../../utils/utility_functions.dart';

class SalesDetailController extends GetxController {
  final SalesApi salesApi = Get.find();
  RxBool isLoading = false.obs;
  Rxn<Sales> sales = Rxn<Sales>();
  final casesController = TextEditingController();
  RxList<SalesItem> items = RxList();

  @override
  void onInit() {
    var id = Get.arguments as int?;
    if (id != null) {
      getSalesById(id: id);
    }
    super.onInit();
  }

  Future<void> getSalesById({required int id}) async {
    isLoading.value = true;
    var result = await salesApi.getSalesById(id: id);
    result.fold(
      (l) {
        if (l is APIFailure) {
          ErrorResponse? errorResponse = l.error;
          showToast(message: errorResponse?.message ?? apiFailureMessage);
        } else if (l is ServerFailure) {
          showToast(message: l.message ?? serverFailureMessage);
        } else if (l is AuthFailure) {
        } else if (l is NetworkFailure) {
          showToast(message: networkFailureMessage);
        } else {
          showToast(message: unknownFailureMessage);
        }
        isLoading.value = false;
      },
      (r) {
        if (r != null) {
          sales.value = Sales(
            status: r.status?.toInt(),
            billAmount: r.billAmount?.toDouble(),
            billNumber: r.billNumber?.toInt(),
            billId: r.billId?.toInt(),
            series: r.series,
            customerName: r.customerName,
            billDate: r.billDate?.toDate(),
            cases: r.cases?.toInt() ?? 0,
            userId: r.userId?.toInt(),
            items:
                r.itemsList
                    ?.map(
                      (e) => SalesItem(
                        billId: e.billId?.toInt(),
                        billDetailId: e.billDetailId?.toInt() ?? 0,
                        isCompleted: e.isCompleted ?? false,
                        isLooselyPacked: e.isLooselyPacked ?? false,
                        mrp: e.mrp?.toDouble(),
                        orderQty: e.orderQty?.toInt() ?? 0,
                        packedQty: e.packedQty?.toInt() ?? 0,
                        productId: e.productId?.toInt(),
                        rowNumber: e.rowNumber?.toInt(),
                        productName: e.productName,
                        packedController: TextEditingController(),
                      ),
                    )
                    .toList() ??
                [],
          );
          casesController.text = sales.value?.cases?.toString() ?? '';
          items.value = sales.value?.items ?? [];
        } else {
          showToast(message: networkFailureMessage);
        }
        isLoading.value = false;
      },
    );
  }

  void onBackClicked() {
    Get.back();
  }

  Future<void> onAddClicked() async {
    var item =
        await Get.toNamed(addSalesItemRoute, arguments: [null, items.length])
            as SalesItem?;
    onItemAdded(item);
    Get.focusScope?.unfocus();
  }

  void onIsCompleteChanged(SalesItem item, bool? value) {
    int index = items
        .map((element) => element.productId)
        .toList()
        .indexOf(item.productId);
    items[index].isCompleted = value ?? false;
    items.refresh();
  }

  void onLooselyPackedChanged(SalesItem item, bool? value) {
    int index = items
        .map((element) => element.productId)
        .toList()
        .indexOf(item.productId);
    items[index].isLooselyPacked = value ?? false;
    items.refresh();
  }

  Future<void> onSaveClicked() async {
    isLoading.value = true;
    var result = await salesApi.updateSales(
      request: UpdateSalesRequest(
        userId: sales.value?.userId,
        billId: sales.value?.billId,
        billAmount: sales.value?.billAmount,
        billNumber: sales.value?.billNumber,
        series: sales.value?.series,
        status: _getStatus(),
        customerName: sales.value?.customerName,
        billDate: sales.value?.billDate?.toIso8601String(),
        cases: casesController.text.toInt(),
        itemsList:
            items
                .map(
                  (e) => Items(
                    billId: e.billId,
                    billDetailId: e.billDetailId,
                    isCompleted: e.isCompleted,
                    isLooselyPacked: e.isLooselyPacked,
                    mrp: e.mrp,
                    orderQty: e.orderQty,
                    packedQty: e.packedController?.text.toInt() ?? 0,
                    productId: e.productId,
                    rowNumber: e.rowNumber,
                    productName: e.productName,
                  ),
                )
                .toList(),
      ),
    );
    result.fold(
      (l) {
        if (l is APIFailure) {
          ErrorResponse? errorResponse = l.error;
          showToast(message: errorResponse?.message ?? apiFailureMessage);
        } else if (l is ServerFailure) {
          showToast(message: l.message ?? serverFailureMessage);
        } else if (l is AuthFailure) {
        } else if (l is NetworkFailure) {
          showToast(message: networkFailureMessage);
        } else {
          showToast(message: unknownFailureMessage);
        }
        isLoading.value = false;
      },
      (r) {
        if (r != null) {
          showToast(message: 'Sales updated', type: ToastificationType.success);
          Get.back();
        } else {
          showToast(message: networkFailureMessage);
        }
        isLoading.value = false;
      },
    );
  }

  void onItemAdded(SalesItem? item) {
    if (item != null) {
      if (_isAlreadyAdded(item)) {
        if (_hasDifferentMrp(item)) {
          item.packedController = TextEditingController();
          item.packedController?.text = item.packedQty.toString();
          items.add(item);
          update();
        } else {
          showDuplicateProductDialog(item, () {
            Get.back();
          });
        }
      } else {
        item.packedController = TextEditingController();
        item.packedController?.text = item.packedQty.toString();
        items.add(item);
      }
    }
    reOrderListBasedOnRowNumber();
  }

  bool _isAlreadyAdded(SalesItem item) {
    return items.any(
      (element) =>
          (element.productId == item.productId) &&
          (element.productName?.toLowerCase() ==
              item.productName?.toLowerCase()),
    );
  }

  void reOrderListBasedOnRowNumber() {
    items.value =
        items.toList()
          ..sort((a, b) => (a.rowNumber ?? 0).compareTo(b.rowNumber ?? 0));
  }

  bool _hasDifferentMrp(SalesItem item) {
    bool hasSameMrp = false;
    for (int i = 0; i < items.length; i++) {
      if (items[i].productId == item.productId &&
          items[i].productName == item.productName &&
          items[i].mrp == item.mrp) {
        hasSameMrp = true;
      }
    }
    return !hasSameMrp;
  }

  void showDuplicateProductDialog(SalesItem item, Function() onOkClicked) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Duplicate Product"),
          content: Text("Item with same mrp already in the list"),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                onOkClicked();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> onItemClicked(SalesItem element) async {
    if (element.quantity != null) {
      var item =
          await Get.toNamed(
                addSalesItemRoute,
                arguments: [element, items.length],
              )
              as SalesItem?;
      onItemAdded(item);
      Get.focusScope?.unfocus();
    }
  }

  int? _getStatus() {
    int completedItems =
        items
            .map((p0) => p0.isCompleted)
            .where((element) => element == true)
            .toList()
            .length;
    return completedItems == 0
        ? 0
        : completedItems < items.length
        ? 1
        : 2;
  }
}
