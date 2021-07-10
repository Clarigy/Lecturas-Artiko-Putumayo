import 'package:artiko/features/create_measurer/presentation/pages/create_measure_page.dart';
import 'package:artiko/features/home/presentation/pages/init/access_gps_page.dart';
import 'package:artiko/features/home/presentation/pages/init/loading_page.dart';
import 'package:artiko/features/home/presentation/pages/main_screen.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_page.dart';
import 'package:artiko/features/login/presentation/pages/login_page.dart';
import 'package:artiko/features/profile/presentation/pages/profile_page.dart';
import 'package:artiko/features/splash_screen/splash_screen.dart';
import 'package:artiko/shared/routes/route_args_keys.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map? args = settings.arguments as Map?;

    late Widget page;
    switch (settings.name) {
      case AppRoutes.LoginScreen:
        page = LoginPage();
        break;
      case AppRoutes.MainScreen:
        page = MainScreen();
        break;
      case AppRoutes.ReadingDetailScreen:
        page = ReadingDetailPage.init(args![READING_DETAIL], args[READINGS]);
        break;
      case AppRoutes.LoadingScreen:
        page = LoadingPage();
        break;
      case AppRoutes.AccessGPSScreen:
        page = AccessGpsPage();
        break;
      case AppRoutes.CreateMeasure:
        page = CreateMeasurePage.init(args![IS_FROM_MAP]);
        break;
      case AppRoutes.ProfileScreen:
        page = ProfilePage.init();
        break;
      default:
        page = SplashScreen.init();
        break;
    }

    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
