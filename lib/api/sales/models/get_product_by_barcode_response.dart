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

class GetProductByBarcodeResponse {
  num? productId;
  String? productName;
  String? packing;
  num? mrp;
  String? barCode;
  List<Batches>? batchesList;

  GetProductByBarcodeResponse(
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

  GetProductByBarcodeResponse.fromJson(dynamic json){
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