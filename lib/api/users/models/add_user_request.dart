class AddUserRequest {
  num? userId;
  String? userName;
  String? password;

  AddUserRequest({this.userId, this.userName, this.password});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["userId"] = userId;
    map["userName"] = userName;
    map["Password"] = password;
    return map;
  }

  AddUserRequest.fromJson(dynamic json){
    userId = json["userId"];
    userName = json["userName"];
    password = json["Password"];
  }
}