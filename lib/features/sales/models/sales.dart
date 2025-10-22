import 'package:flutter/cupertino.dart';

class Sales {
  int? billId;
  String? series;
  int? billNumber;
  DateTime? billDate;
  String? customerName;
  double? billAmount;
  int? cases;
  int? status;
  int? userId;
  bool? isImported;
  List<SalesItem>? items;

  Sales({
    this.status,
    this.billId,
    this.isImported,
    this.series,
    this.cases,
    this.billNumber,
    this.billDate,
    this.customerName,
    this.billAmount,
    this.userId,
    this.items,
  });
}

class SalesItem {
  int billDetailId;
  int? billId;
  int? tempId;
  int? rowNumber;
  int? productId;
  double? mrp;
  int orderQty;
  int packedQty;
  bool isCompleted;
  bool isLooselyPacked;
  String? productName;
  TextEditingController? packedController;
  String? packaging;
  String? barcode;
  double? price;
  int? quantity;
  bool? isNew;

  SalesItem({
    this.billId,
    this.tempId,
    required this.billDetailId,
    this.rowNumber,
    this.productId,
    required this.mrp,
    required this.orderQty,
    required this.packedQty,
    required this.isCompleted,
    required this.isLooselyPacked,
    this.productName,
    this.packedController,
    this.packaging,
    this.barcode,
    this.price,
    this.quantity,
    this.isNew = false
  });
}
