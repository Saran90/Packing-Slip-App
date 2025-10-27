import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/api/sales/models/update_sales_request.dart';
import 'package:packing_slip_app/features/sales/models/product_item.dart';
import 'package:packing_slip_app/features/sales/models/sales.dart';
import 'package:packing_slip_app/main.dart';
import 'package:packing_slip_app/utils/extensions.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
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
            isImported: r.isImported,
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
          if (sales.value?.cases == 0 && sales.value?.status == 0) {
            casesController.text = '';
          } else {
            casesController.text = sales.value?.cases?.toString() ?? '';
          }
          items.value = sales.value?.items ?? [];
          for (int i = 0; i < items.length; i++) {
            items[i].packedController?.text =
                items[i].packedQty.toString() == '0'
                    ? ''
                    : items[i].packedQty.toString();
          }
        } else {
          showToast(message: networkFailureMessage);
        }
        isLoading.value = false;
      },
    );
  }

  void onBackClicked(BuildContext context) {
    if (sales.value?.isImported ?? false) {
      Get.back();
    } else {
      showUnsavedDataDialog(
        context,
        () {
          Get.back();
          Get.back();
        },
        () {
          Get.back();
          onSaveClicked();
        },
      );
    }
  }

  Future<void> onAddClicked() async {
    if (sales.value?.isImported ?? false) {
      return;
    } else {
      if (!isLoading.value) {
        var item =
            await Get.toNamed(
                  addSalesItemRoute,
                  arguments: [null, items.length],
                )
                as SalesItem?;
        onItemAdded(item);
        Get.focusScope?.unfocus();
      }
    }
  }

  void onIsCompleteChanged(SalesItem item, bool? value) {
    if (item.packedController?.text.isEmpty ?? false) {
      int index = items
          .map((element) => element.productId)
          .toList()
          .indexOf(item.productId);
      items[index].packedQty = items[index].orderQty;
      items[index].packedController?.text = items[index].packedQty.toString();
      items[index].isCompleted = value ?? false;
      items.refresh();
    } else {
      int index = items
          .map((element) => element.productId)
          .toList()
          .indexOf(item.productId);
      items[index].showError = false;
      items[index].isCompleted = value ?? false;
      if (!(value ?? false)) {
        items[index].packedController?.text = '';
      }
      items.refresh();
    }
  }

  void onLooselyPackedChanged(SalesItem item, bool? value) {
    int index = items
        .map((element) => element.productId)
        .toList()
        .indexOf(item.productId);
    items[index].isLooselyPacked = value ?? false;
    items.refresh();
  }

  Future<void> callSalesApi() async {
    isLoading.value = true;
    var result = await salesApi.updateSales(
      request: UpdateSalesRequest(
        userId: appStorage.getId(),
        billId: sales.value?.billId,
        billAmount: sales.value?.billAmount,
        billNumber: sales.value?.billNumber,
        series: sales.value?.series,
        status: _getStatus(),
        customerName: sales.value?.customerName,
        billDate: sales.value?.billDate?.toIso8601String(),
        cases: casesController.text.toInt() ?? 0,
        itemsList:
            items
                .map(
                  (e) => Items(
                    billId: sales.value?.billId,
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
          showToast(
            message:
                'Sales bill ${sales.value?.series}-${sales.value?.billNumber} updated',
            type: ToastificationType.success,
          );
          Get.back();
        } else {
          showToast(message: networkFailureMessage);
        }
        isLoading.value = false;
      },
    );
  }

  Future<void> onSaveClicked() async {
    if (sales.value?.isImported ?? false) {
      return;
    } else {
      if (sales.value?.items?.any((element) => element.isCompleted == false) ??
          false) {
        if(sales.value?.items?.every((element) => element.isLooselyPacked == true) ??
            false) {
          casesController.text = '0';
        }
        showIncompleteSalesDialog(() {
          Get.back();
          callSalesApi();
        });
      } else {
        if(sales.value?.items?.every((element) => element.isLooselyPacked == true) ??
            false) {
          casesController.text = '0';
          callSalesApi();
        } else {
          if (casesController.text.isEmpty) {
            showCasesIncompleteDialog(() {
              Get.back();
            });
          } else {
            callSalesApi();
          }
        }
      }
    }
  }

  void onItemAdded(SalesItem? item) {
    if (item != null) {
      if (_isAlreadyAdded(item)) {
        if (_hasDifferentMrp(item)) {
          item.packedController = TextEditingController();
          item.packedController?.text =
              item.packedQty.toString() == '0' ? '' : item.packedQty.toString();
          items.add(item);
          update();
        } else {
          showDuplicateProductDialog(item, () {
            Get.back();
          });
        }
      } else {
        item.packedController = TextEditingController();
        item.packedController?.text =
            item.packedQty.toString() == '0' ? '' : item.packedQty.toString();
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

  void showUnsavedDataDialog(
    BuildContext context,
    Function() onNoClicked,
    Function() onYesClicked,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Save Bill"),
          content: Text("Save Changes?"),
          actions: [
            TextButton(onPressed: onNoClicked, child: Text("No")),
            TextButton(onPressed: onYesClicked, child: Text("Yes")),
          ],
        );
      },
    );
  }

  void showIncompleteSalesDialog(Function() onOkClicked) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sales Bill"),
          content: Text("Incomplete items found"),
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

  void showCasesIncompleteDialog(Function() onOkClicked) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sales Bill"),
          content: Text("Cases not complete"),
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

  Future<void> getAllProductsByBarcode(
    BuildContext context,
    String res,
    SalesItem item,
  ) async {
    isLoading.value = false;
    var result = await salesApi.getAllProductsByBarcode(res);
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
        } else if (l is NoDataFailure) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Product Check"),
                content: Text(
                  "Item not matching",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                actions: [
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showToast(message: unknownFailureMessage);
        }
        isLoading.value = false;
      },
      (r) {
        if (r != null) {
          List<ProductItem> items =
              r.dataList
                  ?.map(
                    (e) => ProductItem(
                      id: e.productId?.toInt() ?? 0,
                      name: e.productName ?? '',
                      mrp: e.mrp?.toDouble() ?? 0,
                      packing: e.packing ?? '',
                      barCode: e.barCode ?? '',
                      availableMrps:
                          e.batchesList
                              ?.map((e) => e.mrp?.toDouble() ?? 0)
                              .toList() ??
                          [],
                    ),
                  )
                  .toList() ??
              [];
          var selectedItem = items.firstWhereOrNull(
            (element) =>
                ((element.id == item.productId) && (element.mrp == item.mrp)),
          );
          if (selectedItem != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Product Check"),
                  content: Text(
                    "Item matching",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  actions: [
                    TextButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Product Check"),
                  content: Text(
                    "Item not matching",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  actions: [
                    TextButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {}
        isLoading.value = false;
      },
    );
  }

  Future<void> onBarcodeClicked(BuildContext context, SalesItem element) async {
    if (!(sales.value?.isImported ?? false)) {
      String? res = await SimpleBarcodeScanner.scanBarcode(
        Get.context!,
        barcodeAppBar: const BarcodeAppBar(
          appBarTitle: 'Barcode',
          centerTitle: false,
          enableBackButton: true,
          backButtonIcon: Icon(Icons.arrow_back_ios),
        ),
        isShowFlashIcon: true,
        delayMillis: 2000,
        cameraFace: CameraFace.back,
      );
      if (res != null) {
        if (res == '-1') {
          res = '';
        }
        if (res.isNotEmpty) {
          getAllProductsByBarcode(context, res, element);
        }
      }
    }
  }

  void onItemDeleteClicked(SalesItem element) {
    showDeleteConfirmation(
      () {
        Get.back();
        items.removeWhere((e) => e.rowNumber == element.rowNumber);
        for (int i = 0; i < items.length; i++) {
          if (items[i].isNew ?? false) {
            items[i].rowNumber = i + 1;
          }
        }
      },
      () {
        Get.back();
      },
    );
  }

  void showDeleteConfirmation(
    Function() onOkClicked,
    Function() onCancelClicked,
  ) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete item"),
          content: Text("Do you want to delete this item?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                onCancelClicked();
              },
            ),
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

  void onPackedQtyUpdated(SalesItem element, String p0) {
    if ((p0.toInt() ?? 0) > 0) {
      if (!element.isCompleted) {
        int index = items
            .map((e) => e.productId)
            .toList()
            .indexOf(element.productId);
        items[index].isCompleted = true;
        items[index].showError = false;
      }
    } else {
      if (element.isCompleted) {
        int index = items
            .map((e) => e.productId)
            .toList()
            .indexOf(element.productId);
        items[index].isCompleted = false;
      }
    }
    items.refresh();
  }
}
