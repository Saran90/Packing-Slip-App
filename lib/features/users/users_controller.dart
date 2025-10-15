import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/utils/extensions.dart';

import '../../../api/error_response.dart';
import '../../../data/error/failures.dart';
import '../../../utils/messages.dart';
import '../../../utils/utility_functions.dart';
import '../../api/users/users_api.dart';
import 'models/user.dart';

class UsersController extends GetxController {
  final UsersApi usersApi = Get.find();
  RxBool isLoading = false.obs;
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
        } else {
          showToast(message: networkFailureMessage);
        }
        isLoading.value = false;
      },
    );
  }

  Future<void> onUsersClicked(User user) async {

  }

  void onItemDeleteClicked(User user) {}

  void onBackClicked() {
    Get.back();
  }
}
