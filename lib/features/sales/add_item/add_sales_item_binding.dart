import 'package:get/get.dart';

import 'add_sales_item_controller.dart';

class AddSalesItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddSalesItemController());
  }
}
