import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_drop_down.dart';
import '../../../core/widgets/autocomplete_textfield.dart';
import '../../../core/widgets/icon_text_field.dart';
import '../../../utils/colors.dart';
import '../models/product_item.dart';
import 'add_sales_item_controller.dart';

class AddSalesItemScreen extends StatelessWidget {
  AddSalesItemScreen({super.key});

  final _controller = Get.find<AddSalesItemController>();
  final textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [appColorGradient1, appColorGradient2],
            begin: Alignment.topLeft,
            stops: [0.5, 1],
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => _controller.onBackClicked(),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Obx(
                            () => Text(
                              _controller.isEdit.value
                                  ? 'Edit item'
                                  : 'Add item',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap:
                                      () =>
                                          _controller.onBarcodeClicked(context),
                                  child: IconTextField(
                                    controller: _controller.barcodeController,
                                    hint: 'Enter barcode',
                                    textInputType: TextInputType.text,
                                    whiteBackground: false,
                                    label: 'Barcode',
                                    isEnabled: false,
                                    suffixIcon: 'assets/icons/ic_barcode.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: _controller.isEdit.value,
                            child: InkWell(
                              onTap: () {},
                              child: SizedBox(width: Get.width, height: 80),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          Obx(
                            () => AutocompleteTextField<ProductItem>(
                              controller: _controller.nameController,
                              getSuggestions: _controller.getProductSuggestions,
                              onSelected: _controller.onProductItemSelected,
                              suggestions: _controller.productItems,
                              selectedValue:
                                  _controller.selectedProductItem.value,
                              label: 'Name',
                              focusNode: _controller.nameFocusNode,
                            ),
                          ),
                          Visibility(
                            visible: _controller.isEdit.value,
                            child: InkWell(
                              onTap: () {},
                              child: SizedBox(width: Get.width, height: 80),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: IconTextField(
                                  controller: _controller.packagingController,
                                  hint: 'Enter packing',
                                  textInputType: TextInputType.text,
                                  whiteBackground: false,
                                  label: 'Packing',
                                ),
                              ),
                              const SizedBox(width: 10),
                              (_controller.selectedProductItem.value
                                          ?.hasMutipleMrps() ??
                                      false)
                                  ? Expanded(
                                    child: Obx(
                                      () => AutocompleteTextField<double>(
                                        controller: _controller.mrpController,
                                        getSuggestions:
                                            _controller.getProductMrps,
                                        onSelected: _controller.onMrpSelected,
                                        suggestions: _controller.productMrps,
                                        selectedValue:
                                            _controller.selectedMrp.value,
                                        label: 'MRP',
                                        formatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'(^\d*\.?\d*)'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : Expanded(
                                    child: IconTextField(
                                      controller: _controller.mrpController,
                                      hint: 'Enter mrp',
                                      textInputType:
                                          TextInputType.numberWithOptions(
                                            signed: false,
                                            decimal: true,
                                          ),
                                      whiteBackground: false,
                                      label: 'MRP',
                                      formatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d*\.?\d*)'),
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: IconTextField(
                                  controller: _controller.rowController,
                                  hint: 'Enter row number',
                                  textInputType:
                                      TextInputType.numberWithOptions(
                                        signed: false,
                                        decimal: false,
                                      ),
                                  whiteBackground: false,
                                  label: 'Row Number',
                                  formatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\d*)'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: IconTextField(
                                  focusNode: _controller.quantityFocusNode,
                                  controller: _controller.quantityController,
                                  hint: 'Enter quantity',
                                  textInputType:
                                      TextInputType.numberWithOptions(
                                        signed: false,
                                        decimal: true,
                                      ),
                                  whiteBackground: false,
                                  label: 'Quantity',
                                  formatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\.?\d*)'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Obx(
                        () => AppButton(
                          label: _controller.isEdit.value ? 'Update' : 'Add',
                          onSubmit: _controller.onSaved,
                          startColor: appColorGradient1,
                          endColor: appColorGradient2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
