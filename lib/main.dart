import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:packing_slip_app/api/sales/sales_api.dart';
import 'package:packing_slip_app/api/users/users_api.dart';
import 'package:packing_slip_app/utils/pages.dart';
import 'package:toastification/toastification.dart';

import 'api/auth/auth_api.dart';
import 'api/endpoints.dart';
import 'data/app_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  await initializeDependencies();
  runApp(const MyApp());
}

Future<void> initializeDependencies() async {
  Get.lazyPut<AuthApi>(() => AuthApi(baseUrl: apiBaseUrl));
  Get.lazyPut<SalesApi>(() => SalesApi(baseUrl: apiBaseUrl));
  Get.lazyPut<UsersApi>(() => UsersApi(baseUrl: apiBaseUrl));
}

AppStorage appStorage = AppStorage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: 'Packing Slip',
        getPages: routes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(3, 108, 173, 1),
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
