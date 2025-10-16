import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/utils/extensions.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../api/error_response.dart';
import '../../../api/sales/sales_api.dart';
import '../../../data/error/failures.dart';
import '../../../utils/messages.dart';
import '../../../utils/utility_functions.dart';
import '../models/product_item.dart';
import '../models/sales.dart';
import '../widgets/product_selection_widget.dart';

class AddSalesItemController extends GetxController {
  final rowController = TextEditingController();
  final barcodeController = TextEditingController();
  final hsnCodeController = TextEditingController();
  final taxPercentageController = TextEditingController();
  final nameController = TextEditingController();
  final packagingController = TextEditingController();
  final mrpController = TextEditingController();
  final totalItemsController = TextEditingController();
  final quantityController = TextEditingController();
  final SalesApi salesApi = Get.find();

  Rx<ProductItem?> selectedProductItem = Rx<ProductItem?>(null);
  RxList<ProductItem?> selectedProductItems = RxList<ProductItem?>();
  RxList<ProductItem> productItems = RxList([]);
  RxBool isLoading = false.obs;
  RxnInt tempId = RxnInt();
  RxInt rowNumber = 1.obs;
  RxInt itemCount = 0.obs;
  late FocusNode quantityFocusNode;
  late FocusNode nameFocusNode;
  RxList<double> taxSlabs = RxList<double>();
  Rx<double?> selectedTaxSlab = Rx<double?>(null);
  RxBool isEdit = RxBool(false);
  Rx<SalesItem?> salesItem = Rx<SalesItem?>(null);
  RxnDouble selectedMrp = RxnDouble();
  RxList<double> productMrps = RxList([]);
  RxnInt productId = RxnInt();

  @override
  void onInit() {
    isEdit.value = false;
    quantityFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    var value = Get.arguments as List<dynamic>;
    if (value[1] != null) {
      itemCount.value = value[1] as int;
      rowNumber.value = itemCount.value + 1;
      rowController.text = rowNumber.string;
    }
    SalesItem? item = value[0] as SalesItem?;
    if (item != null) {
      tempId.value = item.tempId;
      salesItem.value = item;
      isEdit.value = true;
      nameController.text = item.productName ?? '';
      packagingController.text = item.packaging ?? '';
      mrpController.text = item.price.toString();
      barcodeController.text = item.barcode ?? '';
      quantityController.text = item.quantity.toString();
      rowNumber.value = item.rowNumber ?? 0;
      rowController.text = rowNumber.string;
      productId.value = item.productId;

      Future.delayed(
        Duration(milliseconds: 200),
        () => Get.focusScope?.unfocus(),
      );
    } else {
      rowController.text = rowNumber.string;
      Future.delayed(Duration(milliseconds: 500), () {
        onBarcodeClicked(Get.context!);
      });
    }
    super.onInit();
  }

  Future<List<ProductItem>> getProductSuggestions(String pattern) async {
    if (pattern.isEmpty || pattern.length < 3) {
      return [];
    }
    var result = await salesApi.getProducts(name: pattern);
    result.fold(
      (l) {
        productItems.value = [];
        return [];
      },
      (r) {
        if (r != null) {
          productItems.value =
              r.dataList
                  ?.map(
                    (e) => ProductItem(
                      id: e.productId?.toInt() ?? 0,
                      name: e.productName ?? '',
                      mrp: e.mrp?.toDouble() ?? 0,
                      barCode: e.barCode ?? '',
                      packing: e.packing ?? '',
                      availableMrps: [],
                    ),
                  )
                  .toList() ??
              [];
          return productItems;
        } else {
          productItems.value = [];
          return [];
        }
      },
    );
    return productItems;
  }

  Future<List<double>> getProductMrps(String pattern) async {
    return selectedProductItem.value?.availableMrps ?? [];
  }

  void onMrpSelected(double value) {
    selectedMrp.value = value;
    mrpController.text = '$value';
  }

  void onProductItemSelected(ProductItem item) {
    _getProductById(item.id);
  }

  void populateProductDetails() {
    if (selectedProductItem.value != null) {
      nameController.text = selectedProductItem.value!.name;
      packagingController.text = selectedProductItem.value!.packing;
      if (selectedProductItem.value!.availableMrps.length == 1) {
        mrpController.text = selectedProductItem.value!.mrp.toString();
      }
      barcodeController.text = selectedProductItem.value!.barCode;
      quantityFocusNode.requestFocus();
    }
  }

  Future<void> onBarcodeClicked(BuildContext context) async {
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
      barcodeController.text = res;
      if (res.isNotEmpty) {
        getAllProductsByBarcode(res);
      }
    }
  }

  void onSaved() {
    if (nameController.text.isNotEmpty) {
      if (mrpController.text.isNotEmpty) {
        if ((quantityController.text.isEmpty ||
            quantityController.text == '0')) {
          showToast(message: 'Quantity cannot be empty or 0');
        } else {
          int? row = int.tryParse(rowController.text);
          Get.back(
            result: SalesItem(
              tempId: tempId.value ?? DateTime.now().millisecondsSinceEpoch,
              productName: nameController.text,
              packaging: packagingController.text,
              barcode: barcodeController.text,
              price: mrpController.text.toDouble() ?? 0,
              quantity: quantityController.text.toInt() ?? 0,
              rowNumber: row ?? 0,
              billId: salesItem.value?.billId,
              mrp: mrpController.text.toDouble() ?? 0,
              isLooselyPacked: salesItem.value?.isLooselyPacked ?? false,
              isCompleted: salesItem.value?.isCompleted ?? false,
              orderQty: salesItem.value?.orderQty ?? 0,
              packedQty: quantityController.text.toInt() ?? 0,
              billDetailId: salesItem.value?.billDetailId ?? 0,
              isNew: true,
              productId:
                  isEdit.value
                      ? productId.value
                      : selectedProductItem.value?.id,
              packedController:
                  salesItem.value?.packedController ?? TextEditingController(),
            ),
          );
        }
      } else {
        showToast(message: 'MRP should not be empty');
      }
    } else {
      showToast(message: 'Name should not be empty');
    }
  }

  void onBackClicked() {
    Get.back();
  }

  Future<void> getProductByBarcode(String res) async {
    isLoading.value = false;
    var result = await salesApi.getProductByBarcode(res);
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
        } else {
          showToast(message: unknownFailureMessage);
        }
        isLoading.value = false;
      },
      (r) {
        if (r != null) {
          selectedProductItem.value = ProductItem(
            id: r.productId?.toInt() ?? 0,
            name: r.productName ?? '',
            mrp: r.mrp?.toDouble() ?? 0,
            packing: r.packing ?? '',
            barCode: r.barCode ?? '',
            availableMrps:
                r.batchesList?.map((e) => e.mrp?.toDouble() ?? 0).toList() ??
                [],
          );
          nameController.text = selectedProductItem.value?.name ?? '';
          packagingController.text = selectedProductItem.value?.packing ?? '';
          mrpController.text = selectedProductItem.value?.mrp.toString() ?? '';
          quantityFocusNode.requestFocus();
        } else {}
        isLoading.value = false;
      },
    );
  }

  Future<void> getAllProductsByBarcode(String res) async {
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
        } else {
          showToast(message: unknownFailureMessage);
        }
        isLoading.value = false;
      },
      (r) {
        if (r != null) {
          selectedProductItems.value =
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
          if (selectedProductItems.length == 1) {
            var item = selectedProductItems.first;
            selectedProductItem.value = item;
            nameController.text = selectedProductItem.value?.name ?? '';
            packagingController.text = selectedProductItem.value?.packing ?? '';
            mrpController.text =
                selectedProductItem.value?.mrp.toString() ?? '';
            quantityFocusNode.requestFocus();
          } else {
            showProductSelectionWidget();
          }
        } else {}
        isLoading.value = false;
      },
    );
  }

  @override
  void dispose() {
    quantityFocusNode.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  onTaxSlabSelected(double? value) {
    selectedTaxSlab.value = value;
  }

  void showProductSelectionWidget() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      isScrollControlled: true,
      builder:
          (context) => ProductSelectionWidget(
            products: selectedProductItems,
            onProductSelected: onProductVariantSelected,
          ),
    );
  }

  Future<void> _getProductById(int id) async {
    isLoading.value = false;
    var result = await salesApi.getProductsById(id);
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
        } else {
          showToast(message: unknownFailureMessage);
        }
        isLoading.value = false;
      },
      (r) {
        if (r != null) {
          selectedProductItem.value = ProductItem(
            id: r.productId?.toInt() ?? 0,
            name: r.productName ?? '',
            mrp: r.mrp?.toDouble() ?? 0,
            packing: r.packing ?? '',
            barCode: r.barCode ?? '',
            availableMrps:
                r.batchesList?.map((e) => e.mrp?.toDouble() ?? 0).toList() ??
                [],
          );
          productMrps.value = selectedProductItem.value?.availableMrps ?? [];
          populateProductDetails();
        } else {}
        isLoading.value = false;
      },
    );
  }

  void onProductVariantSelected(ProductItem item) {
    Get.back();
    selectedProductItem.value = item;
    populateProductDetails();
  }
}
