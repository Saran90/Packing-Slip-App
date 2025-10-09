import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:packing_slip_app/features/sales/sales_binding.dart';
import 'package:packing_slip_app/features/sales/sales_screen.dart';
import 'package:packing_slip_app/utils/routes.dart';

import '../features/login/login_binding.dart';
import '../features/login/login_screen.dart';
import '../features/splash/splash_screen.dart';

final routes = [
  GetPage(
    name: '/',
    page:
        () => const Directionality(
          textDirection: TextDirection.ltr,
          child: SplashScreen(),
        ),
  ),
  GetPage(
    name: loginRoute,
    binding: LoginBinding(),
    page:
        () => Directionality(
          textDirection: TextDirection.ltr,
          child: LoginScreen(),
        ),
  ),
  GetPage(
    name: salesRoute,
    binding: SalesBinding(),
    page:
        () => Directionality(
      textDirection: TextDirection.ltr,
      child: SalesScreen(),
    ),
  ),
];
