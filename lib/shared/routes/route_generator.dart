import 'package:artiko/features/home/presentation/pages/main_screen.dart';
import 'package:artiko/features/login/presentation/pages/login_page.dart';
import 'package:artiko/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Para usar argumentos: final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.LoginScreen:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRoutes.MainScreen:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case AppRoutes.ProfileScreen:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      default:
        return MaterialPageRoute(builder: (_) => ProfilePage());
    }
  }
}
