class ResetSalesResponse {
  String? message;

  ResetSalesResponse({this.message});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["message"] = message;
    return map;
  }

  ResetSalesResponse.fromJson(dynamic json){
    message = json["message"];
  }
}