class LoginResponse {
  String? token;
  String? firmName;
  int? userId;
  bool? isAdmin;

  LoginResponse({this.token, this.isAdmin, this.firmName, this.userId});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["token"] = token;
    map["firmName"] = firmName;
    map["isAdmin"] = isAdmin;
    map["userId"] = userId;
    return map;
  }

  LoginResponse.fromJson(dynamic json){
    token = json["token"];
    firmName = json["firmName"];
    isAdmin = json["isAdmin"];
    userId = json["userId"];
  }
}