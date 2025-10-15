class GetUserResponse {
  num? userId;
  String? userName;
  String? password;
  String? billDate;
  String? series;

  GetUserResponse({this.userId, this.userName, this.billDate, this.series, this.password});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["userId"] = userId;
    map["userName"] = userName;
    map["password"] = password;
    map["billDate"] = billDate;
    map["series"] = series;
    return map;
  }

  GetUserResponse.fromJson(dynamic json){
    userId = json["userId"];
    userName = json["userName"];
    password = json["password"];
    billDate = json["billDate"];
    series = json["series"];
  }
}