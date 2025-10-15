import 'package:get/get.dart';
import 'package:packing_slip_app/features/sales/detail/sales_detail_controller.dart';

class SalesDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SalesDetailController());
  }
}
