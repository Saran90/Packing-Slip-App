import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/api/users/models/allot_series_request.dart';
import 'package:packing_slip_app/api/users/users_api.dart';
import 'package:packing_slip_app/features/users/models/user.dart';
import 'package:packing_slip_app/main.dart';
import 'package:packing_slip_app/utils/extensions.dart';
import 'package:packing_slip_app/utils/utility_functions.dart';
import 'package:toastification/toastification.dart';

import '../../../api/error_response.dart';
import '../../../data/error/failures.dart';
import '../../../utils/messages.dart';

class AllotSeriesController extends GetxController {
  final nameController = TextEditingController();
  final seriesController = TextEditingController();
  final billDateController = TextEditingController();
  Rx<DateTime> selectedBillDate = Rx<DateTime>(DateTime.now());
  RxBool isLoading = RxBool(false);
  Rxn<User> user = Rxn<User>();
  final UsersApi usersApi = Get.find();

  Future<void> onBillDateClicked(BuildContext context) async {
    final date = await showDatePickerDialog(
      context: context,
      selectedDate: selectedBillDate.value,
      minDate: DateTime(1950, 1, 1),
      maxDate: DateTime(2500, 12, 31),
    );
    if (date != null) {
      selectedBillDate.value = date;
      billDateController.text = date.toDDMMYYYY() ?? '';
    }
  }

  Future<void> onSaveClicked() async {
    if (seriesController.text.isNotEmpty &&
        billDateController.text.isNotEmpty) {
      isLoading.value = true;
      var result = await usersApi.allotSeries(
        request: AllotSeriesRequest(
          userName: nameController.text,
          series: seriesController.text,
          billDate: selectedBillDate.value.toIso8601String(),
          userId: user.value?.userId,
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
            message: r?.message ?? 'User allotted series',
            type: ToastificationType.success,
          );
          isLoading.value = false;
          Get.back();
        },
      );
    } else {
      showToast(message: 'Please provide all data');
    }
  }

  void setUser(User? value) {
    user.value = value;
    nameController.text = user.value?.userName ?? '';
    DateTime? date = user.value?.billDate;
    if (date != null) {
      selectedBillDate.value = date;
      billDateController.text = date.toDDMMYYYY() ?? '';
    }
    seriesController.text = user.value?.series ?? '';
  }
}
