import 'package:artiko/features/splash_screen/splash_bloc.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dependency_injector.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen._();

  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => sl<SplashBloc>(),
      builder: (_, __) => SplashScreen._(),
    );
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void afterLayout() async {
    try {
      final bloc = context.read<SplashBloc>();
      final existSession = await bloc.existSession();

      await Navigator.of(context).pushNamedAndRemoveUntil(
          existSession ? AppRoutes.MainScreen : AppRoutes.LoginScreen,
          (Route<dynamic> route) => false);
    } catch (onError) {
      Navigator.pushReplacementNamed(context, AppRoutes.LoginScreen);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => afterLayout());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
