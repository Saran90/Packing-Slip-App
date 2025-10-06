class LoginRequest {
  String? username;
  String? password;

  LoginRequest({this.username, this.password});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["username"] = username;
    map["password"] = password;
    return map;
  }

  LoginRequest.fromJson(dynamic json){
    username = json["username"];
    password = json["password"];
  }
}