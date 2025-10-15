class Batches {
  num? mrp;

  Batches({this.mrp});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["mrp"] = mrp;
    return map;
  }

  Batches.fromJson(dynamic json){
    mrp = json["mrp"];
  }
}

class Data {
  num? productId;
  String? productName;
  String? packing;
  num? mrp;
  String? barCode;
  List<Batches>? batchesList;

  Data(
      {this.productId, this.productName, this.packing, this.mrp, this.barCode, this.batchesList});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["productId"] = productId;
    map["productName"] = productName;
    map["packing"] = packing;
    map["mrp"] = mrp;
    map["barCode"] = barCode;
    if (batchesList != null) {
      map["batches"] = batchesList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  Data.fromJson(dynamic json){
    productId = json["productId"];
    productName = json["productName"];
    packing = json["packing"];
    mrp = json["mrp"];
    barCode = json["barCode"];
    if (json["batches"] != null) {
      batchesList = [];
      json["batches"].forEach((v) {
        batchesList?.add(Batches.fromJson(v));
      });
    }
  }
}

class GetAllProductsByBarcodeResponse {
  String? status;
  String? message;
  List<Data>? dataList;

  GetAllProductsByBarcodeResponse({this.status, this.message, this.dataList});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (dataList != null) {
      map["data"] = dataList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  GetAllProductsByBarcodeResponse.fromJson(dynamic json){
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