import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/api/users/models/add_user_request.dart';
import 'package:packing_slip_app/api/users/users_api.dart';
import 'package:packing_slip_app/features/users/models/user.dart';
import 'package:packing_slip_app/utils/extensions.dart';
import 'package:packing_slip_app/utils/utility_functions.dart';
import 'package:toastification/toastification.dart';

import '../../../api/error_response.dart';
import '../../../data/error/failures.dart';
import '../../../utils/messages.dart';

class AddUserController extends GetxController {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isLoading = RxBool(false);
  Rxn<User> user = Rxn<User>();
  final UsersApi usersApi = Get.find();

  Future<void> onSaveClicked() async {
    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      isLoading.value = true;
      var result = await usersApi.addUser(
        request: AddUserRequest(
          userName: userNameController.text,
          password: passwordController.text,
          userId: user.value?.userId ?? 0,
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
          showToast(
            message:
                r?.message ??
                (user.value == null ? 'User added' : 'User updated'),
            type: ToastificationType.success
          );
          isLoading.value = false;
          Get.back();
        },
      );
    } else {
      showToast(message: 'Please provide all data');
    }
  }

  Future<void> getUserById() async {
    isLoading.value = true;
    var result = await usersApi.getUserById(id: user.value?.userId ?? 0);
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
          userNameController.text = r.userName ?? '';
          passwordController.text = r.password ?? '';
        }
        isLoading.value = false;
      },
    );
  }

  void setUser(User? value) {
    if(value != null) {
      user.value = value;
      getUserById();
    }
  }
}
