import 'package:artiko/shared/routes/route_generator.dart';
import 'package:artiko/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dependency_injector.dart';

void main() async {
  await setupInjector();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: lightTheme,
      title: 'Artiko',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
