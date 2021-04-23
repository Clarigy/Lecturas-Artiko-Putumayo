import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: Center(
          child: TextButton(
        child: Text('Profile'),
        onPressed: () =>
            Navigator.of(context).pushNamed(AppRoutes.ProfileScreen),
      )),
    );
  }
}
