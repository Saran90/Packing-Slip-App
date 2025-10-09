class LoginResponse {
  String? token;
  String? firmName;
  bool? isAdmin;

  LoginResponse({this.token, this.isAdmin, this.firmName});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["token"] = token;
    map["firmName"] = firmName;
    map["isAdmin"] = isAdmin;
    return map;
  }

  LoginResponse.fromJson(dynamic json){
    token = json["token"];
    firmName = json["firmName"];
    isAdmin = json["isAdmin"];
  }
}