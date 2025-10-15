class User {
  num? userId;
  String? userName;
  String? password;

  User({this.userId, this.userName, this.password});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["userId"] = userId;
    map["userName"] = userName;
    map["password"] = password;
    return map;
  }

  User.fromJson(dynamic json){
    userId = json["userId"];
    userName = json["userName"];
    password = json["password"];
  }
}

class AddUserResponse {
  String? message;
  User? user;

  AddUserResponse({this.message, this.user});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["message"] = message;
    if (user != null) {
      map["user"] = user?.toJson();
    }
    return map;
  }

  AddUserResponse.fromJson(dynamic json){
    message = json["message"];
    user = json["user"] != null ? User.fromJson(json["user"]) : null;
  }
}