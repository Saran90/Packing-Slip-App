class Data {
  num? userId;
  String? userName;
  String? billDate;
  String? series;

  Data({this.userId, this.userName, this.billDate, this.series});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["userId"] = userId;
    map["userName"] = userName;
    map["billDate"] = billDate;
    map["series"] = series;
    return map;
  }

  Data.fromJson(dynamic json){
    userId = json["userId"];
    userName = json["userName"];
    billDate = json["billDate"];
    series = json["series"];
  }
}

class UsersResponse {
  String? status;
  String? message;
  List<Data>? dataList;

  UsersResponse({this.status, this.message, this.dataList});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (dataList != null) {
      map["data"] = dataList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  UsersResponse.fromJson(dynamic json){
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