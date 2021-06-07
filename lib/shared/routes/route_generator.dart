import 'package:artiko/features/create_measurer/presentation/pages/create_measure_page.dart';
import 'package:artiko/features/home/presentation/pages/init/access_gps_page.dart';
import 'package:artiko/features/home/presentation/pages/init/loading_page.dart';
import 'package:artiko/features/home/presentation/pages/main_screen.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_page.dart';
import 'package:artiko/features/login/presentation/pages/login_page.dart';
import 'package:artiko/features/profile/presentation/pages/profile_page.dart';
import 'package:artiko/shared/routes/route_args_keys.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map? args = settings.arguments as Map?;

    switch (settings.name) {
      case AppRoutes.LoginScreen:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRoutes.MainScreen:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case AppRoutes.ReadingDetailScreen:
        return MaterialPageRoute(
            builder: (_) => ReadingDetailPage.init(args![READING_DETAIL]));
      case AppRoutes.LoadingScreen:
        return MaterialPageRoute(builder: (_) => LoadingPage());
      case AppRoutes.AccessGPSScreen:
        return MaterialPageRoute(builder: (_) => AccessGpsPage());
      case AppRoutes.CreateMeasure:
        return MaterialPageRoute(builder: (_) => CreateMeasurePage.init());
      case AppRoutes.ProfileScreen:
        return MaterialPageRoute(builder: (_) => ProfilePage.init());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
