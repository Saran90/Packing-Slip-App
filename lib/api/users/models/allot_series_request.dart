class AllotSeriesRequest {
  num? userId;
  String? userName;
  String? billDate;
  String? series;

  AllotSeriesRequest({this.userId, this.userName, this.billDate, this.series});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["userId"] = userId;
    map["userName"] = userName;
    map["billDate"] = billDate;
    map["series"] = series;
    return map;
  }

  AllotSeriesRequest.fromJson(dynamic json){
    userId = json["userId"];
    userName = json["userName"];
    billDate = json["billDate"];
    series = json["series"];
  }
}