class Data {
  num? taxPer;

  Data({this.taxPer});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["taxPer"] = taxPer;
    return map;
  }

  Data.fromJson(dynamic json){
    taxPer = json["taxPer"];
  }
}

class TaxResponse {
  String? status;
  String? message;
  List<Data>? dataList;

  TaxResponse({this.status, this.message, this.dataList});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (dataList != null) {
      map["data"] = dataList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  TaxResponse.fromJson(dynamic json){
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