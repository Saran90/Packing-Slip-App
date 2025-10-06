class LoginResponse {
  String? token;
  String? firmName;

  LoginResponse({this.token});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["token"] = token;
    map["firmName"] = firmName;
    return map;
  }

  LoginResponse.fromJson(dynamic json){
    token = json["token"];
    firmName = json["firmName"];
  }
}