import 'package:get/get.dart';
import 'package:packing_slip_app/features/sales/sales_controller.dart';

class SalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SalesController());
  }
}
