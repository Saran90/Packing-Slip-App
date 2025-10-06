import 'dart:ui';

import 'package:get_storage/get_storage.dart';

import 'app_storage_keys.dart';

final box = GetStorage();

class AppStorage {

  Future<void> setToken({required String accessToken, required String refreshToken}) async {
    await box.write(accessTokenKey, accessToken);
    await box.write(refreshTokenKey, refreshToken);
  }

  String? getAccessToken() {
    String? accessToken = box.read(accessTokenKey);
    return accessToken;
  }

  Future<void> setFirmName({required String firmName}) async {
    await box.write(firmNameKey, firmName);
  }


  Future<void> setLoginStatus({required bool status}) async {
    await box.write(isLoggedInKey, status);
  }

  bool? isLoggedIn() {
    return box.read(isLoggedInKey);
  }

  String? getRefreshToken() {
    String? refreshToken = box.read(refreshTokenKey);
    return refreshToken;
  }

  String? getFirmName() {
    String? firmName = box.read(firmNameKey);
    return firmName;
  }

  Future<void> clear() async {
    await box.erase();
    await setLoginStatus(status: false);
  }
}
