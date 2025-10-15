class UpdateSalesResponse {
  num? salesId;
  String? message;

  UpdateSalesResponse({this.salesId, this.message});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["salesId"] = salesId;
    map["message"] = message;
    return map;
  }

  UpdateSalesResponse.fromJson(dynamic json){
    salesId = json["salesId"];
    message = json["message"];
  }
}