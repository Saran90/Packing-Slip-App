import 'package:get/get.dart';
import 'package:packing_slip_app/features/users/users_controller.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsersController());
  }
}
