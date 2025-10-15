class Items {
  num? billDetailId;
  num? billId;
  num? rowNumber;
  num? productId;
  num? mrp;
  num? orderQty;
  num? packedQty;
  num? status;
  bool? isCompleted;
  bool? isLooselyPacked;
  String? productName;

  Items(
      {this.billDetailId, this.productName, this.status, this.billId, this.rowNumber, this.productId, this.mrp, this.orderQty, this.packedQty, this.isCompleted, this.isLooselyPacked});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["billDetailId"] = billDetailId;
    map["billId"] = billId;
    map["status"] = status;
    map["rowNumber"] = rowNumber;
    map["productId"] = productId;
    map["mrp"] = mrp;
    map["orderQty"] = orderQty;
    map["packedQty"] = packedQty;
    map["isCompleted"] = isCompleted;
    map["isLooselyPacked"] = isLooselyPacked;
    map["productName"] = productName;
    return map;
  }

  Items.fromJson(dynamic json){
    billDetailId = json["billDetailId"];
    billId = json["billId"];
    rowNumber = json["rowNumber"];
    productId = json["productId"];
    mrp = json["mrp"];
    orderQty = json["orderQty"];
    status = json["status"];
    packedQty = json["packedQty"];
    isCompleted = json["isCompleted"];
    isLooselyPacked = json["isLooselyPacked"];
    productName = json["productName"];
  }
}

class GetSalesByIdResponse {
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

  GetSalesByIdResponse(
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

  GetSalesByIdResponse.fromJson(dynamic json){
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