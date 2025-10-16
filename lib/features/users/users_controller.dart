import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/features/users/allot_series/allot_series_widget.dart';
import 'package:packing_slip_app/utils/extensions.dart';

import '../../../api/error_response.dart';
import '../../../data/error/failures.dart';
import '../../../utils/messages.dart';
import '../../../utils/utility_functions.dart';
import '../../api/users/users_api.dart';
import 'add/add_user_widget.dart';
import 'models/user.dart';

class UsersController extends GetxController {
  final UsersApi usersApi = Get.find();
  RxBool isLoading = false.obs;
  RxBool noData = false.obs;
  RxList<User> users = RxList([]);

  @override
  void onInit() {
    loadUsers();
    super.onInit();
  }

  Future<void> loadUsers() async {
    isLoading.value = true;
    var result = await usersApi.getUsers();
    result.fold(
      (l) {
        if (l is APIFailure) {
          ErrorResponse? errorResponse = l.error;
          showToast(message: errorResponse?.message ?? apiFailureMessage);
        } else if (l is ServerFailure) {
          showToast(message: l.message ?? serverFailureMessage);
        } else if (l is AuthFailure) {
        } else if (l is NoDataFailure) {
          users.value = [];
          noData.value = true;
        } else if (l is NetworkFailure) {
          showToast(message: networkFailureMessage);
        } else {
          showToast(message: unknownFailureMessage);
        }
        isLoading.value = false;
      },
      (r) {
        if (r != null) {
          users.value =
              r.dataList
                  ?.map(
                    (e) => User(
                      userId: e.userId?.toInt(),
                      userName: e.userName,
                      billDate: e.billDate?.toDate(),
                      series: e.series,
                    ),
                  )
                  .toList() ??
              [];
          noData.value = false;
        } else {
          showToast(message: networkFailureMessage);
        }
        isLoading.value = false;
      },
    );
  }

  Future<void> onUserClicked(User user) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => AddUserWidget(user: user),
    );
    loadUsers();
  }

  Future<void> onAllotSeriesClicked(User user) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => AllotSeriesWidget(user: user),
    );
    loadUsers();
  }

  void onItemDeleteClicked(User user) {}

  void onBackClicked() {
    Get.back();
  }

  void onAddClicked() {
    showAddUserWidget();
  }

  Future<void> showAddUserWidget() async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => AddUserWidget(),
    );
    loadUsers();
  }
}
