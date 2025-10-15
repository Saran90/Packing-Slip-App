class Data {
  num? productId;
  String? productName;
  String? packing;
  num? mrp;
  String? barCode;

  Data(
      {this.productId, this.productName, this.packing, this.mrp, this.barCode});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["productId"] = productId;
    map["productName"] = productName;
    map["packing"] = packing;
    map["mrp"] = mrp;
    map["barCode"] = barCode;
    return map;
  }

  Data.fromJson(dynamic json){
    productId = json["productId"];
    productName = json["productName"];
    packing = json["packing"];
    mrp = json["mrp"];
    barCode = json["barCode"];
  }
}

class GetProductsResponse {
  String? status;
  String? message;
  List<Data>? dataList;

  GetProductsResponse({this.status, this.message, this.dataList});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (dataList != null) {
      map["data"] = dataList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  GetProductsResponse.fromJson(dynamic json){
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      dataList = [];
      json["data"].forEach((v) {
        dataList?.add(Data.fromJson(v));
      });
    }
  }
}