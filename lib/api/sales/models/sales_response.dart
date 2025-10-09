class Data {
  num? billId;
  String? series;
  num? billNumber;
  String? billDate;
  String? customerName;
  num? billAmount;
  num? cases;
  num? status;
  num? userId;

  Data(
      {this.billId, this.series, this.billNumber, this.billDate, this.customerName, this.billAmount, this.cases, this.status, this.userId});

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
    return map;
  }

  Data.fromJson(dynamic json){
    billId = json["billId"];
    series = json["series"];
    billNumber = json["billNumber"];
    billDate = json["billDate"];
    customerName = json["customerName"];
    billAmount = json["billAmount"];
    cases = json["cases"];
    status = json["status"];
    userId = json["userId"];
  }
}

class SalesResponse {
  String? status;
  String? message;
  List<Data>? dataList;

  SalesResponse({this.status, this.message, this.dataList});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (dataList != null) {
      map["data"] = dataList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  SalesResponse.fromJson(dynamic json){
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