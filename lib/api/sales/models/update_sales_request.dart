class Items {
  num? billDetailId;
  num? billId;
  num? rowNumber;
  num? productId;
  String? productName;
  num? mrp;
  num? orderQty;
  num? packedQty;
  bool? isCompleted;
  bool? isLooselyPacked;

  Items(
      {this.billDetailId, this.productName, this.billId, this.rowNumber, this.productId, this.mrp, this.orderQty, this.packedQty, this.isCompleted, this.isLooselyPacked});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["billDetailId"] = billDetailId;
    map["billId"] = billId;
    map["rowNumber"] = rowNumber;
    map["productId"] = productId;
    map["productName"] = productName;
    map["mrp"] = mrp;
    map["orderQty"] = orderQty;
    map["packedQty"] = packedQty;
    map["isCompleted"] = isCompleted;
    map["isLooselyPacked"] = isLooselyPacked;
    return map;
  }

  Items.fromJson(dynamic json){
    billDetailId = json["billDetailId"];
    billId = json["billId"];
    rowNumber = json["rowNumber"];
    productId = json["productId"];
    mrp = json["mrp"];
    orderQty = json["orderQty"];
    productName = json["productName"];
    packedQty = json["packedQty"];
    isCompleted = json["isCompleted"];
    isLooselyPacked = json["isLooselyPacked"];
  }
}

class UpdateSalesRequest {
  num? billId;
  String? series;
  num? billNumber;
  String? billDate;
  String? customerName;
  num? billAmount;
  num? cases;
  num? status;
  num? userId;
  List<Items>? itemsList;

  UpdateSalesRequest(
      {this.billId, this.series, this.billNumber, this.billDate, this.customerName, this.billAmount, this.cases, this.status, this.userId, this.itemsList});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["billId"] = billId;
    map["series"] = series;
    map["billNumber"] = billNumber;
    map["billDate"] = billDate;
    map["customerName"] = customerName;
    map["billAmount"] = billAmount;
    map["cases"] = cases;
    map["status"] = status;
    map["userId"] = userId;
    if (itemsList != null) {
      map["items"] = itemsList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  UpdateSalesRequest.fromJson(dynamic json){
    billId = json["billId"];
    series = json["series"];
    billNumber = json["billNumber"];
    billDate = json["billDate"];
    customerName = json["customerName"];
    billAmount = json["billAmount"];
    cases = json["cases"];
    status = json["status"];
    userId = json["userId"];
    if (json["items"] != null) {
      itemsList = [];
      json["items"].forEach((v) {
        itemsList?.add(Items.fromJson(v));
      });
    }
  }
}