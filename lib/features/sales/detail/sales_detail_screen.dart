import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/features/sales/detail/sales_detail_controller.dart';
import 'package:packing_slip_app/utils/extensions.dart';
import 'package:packing_slip_app/utils/messages.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/icon_text_field.dart';
import '../../../utils/colors.dart';

class SalesDetailScreen extends StatelessWidget {
  SalesDetailScreen({super.key});

  final _controller = Get.find<SalesDetailController>();
  final textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _controller.onBackClicked(context);
        }
      },
      child: Scaffold(
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
            child: Stack(
              fit: StackFit.loose,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () => _controller.onBackClicked(context),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Sales Detail',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          if(!(_controller.sales.value?.isImported??false))InkWell(
                            onTap: () => _controller.onSaveClicked(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bill-id',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Obx(
                                          () => Text(
                                            _controller.sales.value?.billId
                                                    ?.toString() ??
                                                '---',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bill-number',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Obx(
                                          () => Text(
                                            _controller.sales.value?.billNumber
                                                    ?.toString() ??
                                                '---',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Customer name',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Obx(
                                          () => Text(
                                            _controller
                                                    .sales
                                                    .value
                                                    ?.customerName ??
                                                '---',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Series',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Obx(
                                          () => Text(
                                            _controller.sales.value?.series ??
                                                '---',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bill amount',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Obx(
                                          () => Text(
                                            '$rupeeIcon ${_controller.sales.value?.billAmount?.toString() ?? '---'}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bill date',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Obx(
                                          () => Text(
                                            _controller.sales.value?.billDate
                                                    ?.toDDMMYYYY() ??
                                                '---',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: IconTextField(
                                      controller: _controller.casesController,
                                      height: 40,
                                      bottomPadding: 10,
                                      width: 120,
                                      hint: '',
                                      isEnabled:
                                          !(_controller
                                                  .sales
                                                  .value
                                                  ?.isImported ??
                                              false),
                                      textInputType:
                                          TextInputType.numberWithOptions(
                                            signed: false,
                                            decimal: false,
                                          ),
                                      whiteBackground: false,
                                      label: 'Cases',
                                      formatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d*)'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Items',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      '${_controller.items.length} count',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Obx(
                                      () => Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Completed: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${_controller.items.where((p0) => p0.isCompleted).length}/${_controller.items.length}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  if(!(_controller.sales.value?.isImported??false))Expanded(
                                    child: AppButton(
                                      label: 'Add item',
                                      onSubmit: _controller.onAddClicked,
                                      startColor: appColorGradient1,
                                      endColor: appColorGradient2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ConstrainedBox(
                                constraints: BoxConstraints(minHeight: 100),
                                child: Obx(
                                  () =>
                                      _controller.items.isEmpty
                                          ? Center(
                                            child: Text(
                                              'No items',
                                              style: TextStyle(
                                                color: textColor,
                                              ),
                                            ),
                                          )
                                          : Column(
                                            children: [
                                              ..._controller.items.map(
                                                (element) => Stack(
                                                  children: [
                                                    InkWell(
                                                      onTap:
                                                          () => _controller
                                                              .onItemClicked(
                                                                element,
                                                              ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          color: Colors.white10,
                                                        ),
                                                        padding: EdgeInsets.all(
                                                          15,
                                                        ),
                                                        margin: EdgeInsets.only(
                                                          bottom: 10,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    element.productName ??
                                                                        '',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    maxLines: 2,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    '$rupeeIcon ${element.mrp}',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        'Order Qty: ',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        '${element.orderQty}',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        'Packed Qty: ',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                        child: IconTextField(
                                                                          hint:
                                                                              '',
                                                                          height:
                                                                              30,
                                                                          onChanged:
                                                                              (p0) => _controller.onPackedQtyUpdated(
                                                                                element,
                                                                                p0,
                                                                              ),
                                                                          isEnabled:
                                                                              !(_controller.sales.value?.isImported ??
                                                                                  false),
                                                                          bottomPadding:
                                                                              12,
                                                                          controller:
                                                                              element.packedController ??
                                                                              TextEditingController(),
                                                                          whiteBackground:
                                                                              false,
                                                                          formatters: [
                                                                            FilteringTextInputFormatter.allow(
                                                                              RegExp(
                                                                                r'(^\d*)',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          textInputType: TextInputType.numberWithOptions(
                                                                            signed:
                                                                                false,
                                                                            decimal:
                                                                                false,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: CheckboxListTile(
                                                                    side: WidgetStateBorderSide.resolveWith((
                                                                      Set<
                                                                        WidgetState
                                                                      >
                                                                      states,
                                                                    ) {
                                                                      if (states.contains(
                                                                        WidgetState
                                                                            .selected,
                                                                      )) {
                                                                        return const BorderSide(
                                                                          color:
                                                                          Colors.white,
                                                                        );
                                                                      }
                                                                      return const BorderSide(
                                                                        color:
                                                                        Colors.white,
                                                                      );
                                                                    }),
                                                                    title: Transform.translate(
                                                                      offset:
                                                                          const Offset(
                                                                            -20,
                                                                            0,
                                                                          ),
                                                                      child: Text(
                                                                        'Loosely Packed?',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    controlAffinity:
                                                                    ListTileControlAffinity
                                                                        .leading,
                                                                    checkColor:
                                                                    Colors.white,
                                                                    activeColor:
                                                                    appColorGradient1,
                                                                    value:
                                                                        element
                                                                            .isLooselyPacked,
                                                                    enabled:
                                                                        !(_controller.sales.value?.isImported ??
                                                                            false),
                                                                    onChanged:
                                                                        (
                                                                          value,
                                                                        ) => _controller.onLooselyPackedChanged(
                                                                          element,
                                                                          value,
                                                                        ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: CheckboxListTile(
                                                                    side: WidgetStateBorderSide.resolveWith((
                                                                      Set<
                                                                        WidgetState
                                                                      >
                                                                      states,
                                                                    ) {
                                                                      if (states.contains(
                                                                        WidgetState
                                                                            .selected,
                                                                      )) {
                                                                        return const BorderSide(
                                                                          color:
                                                                              Colors.white,
                                                                        );
                                                                      }
                                                                      return const BorderSide(
                                                                        color:
                                                                            Colors.white,
                                                                      );
                                                                    }),
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    title: Transform.translate(
                                                                      offset:
                                                                          const Offset(
                                                                            -20,
                                                                            0,
                                                                          ),
                                                                      child: Text(
                                                                        'Completed?',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    controlAffinity:
                                                                        ListTileControlAffinity
                                                                            .leading,
                                                                    checkColor:
                                                                    Colors.white,
                                                                    activeColor:
                                                                    appColorGradient1,
                                                                    value:
                                                                        element
                                                                            .isCompleted,
                                                                    enabled:
                                                                        !(_controller.sales.value?.isImported ??
                                                                            false),
                                                                    onChanged:
                                                                        (
                                                                          value,
                                                                        ) => _controller.onIsCompleteChanged(
                                                                          element,
                                                                          value,
                                                                        ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: InkWell(
                                                                    onTap:
                                                                        () => _controller.onBarcodeClicked(
                                                                          context,
                                                                          element,
                                                                        ),
                                                                    child: Image.asset(
                                                                      'assets/icons/ic_barcode.png',
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                          color: Colors.yellow,
                                                        ),
                                                        width: 25,
                                                        height: 20,
                                                        child: Center(
                                                          child: Text(
                                                            '${element.rowNumber}',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors
                                                                      .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible:
                                                          element
                                                              .billDetailId ==
                                                          0,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: InkWell(
                                                          onTap:
                                                              () => _controller
                                                                  .onItemDeleteClicked(
                                                                    element,
                                                                  ),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        5,
                                                                      ),
                                                                  color:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                            width: 75,
                                                            height: 25,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons.delete,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  size: 15,
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: _controller.isLoading.value,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
