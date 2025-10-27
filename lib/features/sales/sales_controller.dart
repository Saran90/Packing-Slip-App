import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/utils/extensions.dart';
import 'package:toastification/toastification.dart';

import '../../../api/error_response.dart';
import '../../../data/error/failures.dart';
import '../../../utils/messages.dart';
import '../../../utils/routes.dart';
import '../../../utils/utility_functions.dart';
import '../../api/sales/sales_api.dart';
import '../../main.dart';
import 'models/sales.dart';

class SalesController extends GetxController {
  final SalesApi salesApi = Get.find();
  RxBool isLoading = false.obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxInt supplierId = 150.obs;
  RxString firmName = ''.obs;
  RxString username = ''.obs;
  RxList<Sales> sales = RxList([]);
  RxBool isAdmin = RxBool(false);
  RxBool noData = RxBool(false);
  RxInt completedBills = RxInt(0);

  @override
  void onInit() {
    firmName.value = appStorage.getFirmName() ?? '';
    username.value = appStorage.getUsername() ?? '';
    isAdmin.value = appStorage.isAdmin() ?? false;
    loadSales();
    super.onInit();
  }

  Future<void> loadSales() async {
    isLoading.value = true;
    var result = await salesApi.getSales();
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
          sales.value = [];
          noData.value = true;
        } else {
          showToast(message: unknownFailureMessage);
        }
        isLoading.value = false;
      },
      (r) {
        if (r != null) {
          sales.value =
              r.dataList
                  ?.map(
                    (e) => Sales(
                      status: e.status?.toInt(),
                      billId: e.billId?.toInt(),
                      billDate: e.billDate?.toDate(),
                      billAmount: e.billAmount?.toDouble(),
                      billNumber: e.billNumber?.toInt(),
                      customerName: e.customerName,
                      series: e.series,
                      cases: e.cases?.toInt(),
                      isImported: e.isImported
                    ),
                  )
                  .toList() ??
              [];
          completedBills.value = sales.where((element) => element.status == 2).length;
          noData.value = false;
        } else {
          showToast(message: networkFailureMessage);
        }
        isLoading.value = false;
      },
    );
  }

  Future<void> onMenuClicked(BuildContext context, int value) async {
    if (value == 0) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Logout"),
            content: Text("Do you really want to logout?"),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Get.back();
                },
              ),
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  Get.back();
                  appStorage.clear();
                  appStorage.setLoginStatus(status: false);
                  Get.offAllNamed(loginRoute);
                },
              ),
            ],
          );
        },
      );
    } else if (value == 1) {
      await Get.toNamed(usersRoute);
      loadSales();
    }
  }

  Future<void> onSalesClicked(Sales sales) async {
    await Get.toNamed(salesDetailRoute, arguments: sales.billId);
    loadSales();
  }

  Future<void> onItemResetClicked(int? billId) async {
    isLoading.value = true;
    var result = await salesApi.resetSales(billId: billId);
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
          showToast(message: r.message ?? '', type: ToastificationType.success);
          loadSales();
        } else {
          showToast(message: networkFailureMessage);
        }
        isLoading.value = false;
      },
    );
  }
}
