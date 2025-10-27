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
        builder: (_, child) => TextScaleFactorClamper(
          minTextScaleFactor: 1,
          maxTextScaleFactor: 1,
          child: child!,
        ),
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
class TextScaleFactorClamper extends StatelessWidget {
  /// {@macro text_scale_factor_clamper}
  const TextScaleFactorClamper({
    super.key,
    required this.child,
    this.minTextScaleFactor,
    this.maxTextScaleFactor,
  })  : assert(
  minTextScaleFactor == null ||
      maxTextScaleFactor == null ||
      minTextScaleFactor <= maxTextScaleFactor,
  'minTextScaleFactor must be less than maxTextScaleFactor',
  ),
        assert(
        maxTextScaleFactor == null ||
            minTextScaleFactor == null ||
            maxTextScaleFactor >= minTextScaleFactor,
        'maxTextScaleFactor must be greater than minTextScaleFactor',
        );

  /// Child widget.
  final Widget child;

  /// Min text scale factor.
  final double? minTextScaleFactor;

  /// Max text scale factor.
  final double? maxTextScaleFactor;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    final constrainedTextScaleFactor = mediaQueryData.textScaler.clamp(
      minScaleFactor: minTextScaleFactor ?? 1,
      maxScaleFactor: maxTextScaleFactor ?? 1.3,
    );

    return MediaQuery(
      data: mediaQueryData.copyWith(
        textScaler: constrainedTextScaleFactor,
      ),
      child: child,
    );
  }
}