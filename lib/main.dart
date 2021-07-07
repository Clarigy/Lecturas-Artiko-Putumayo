import 'dart:async';

import 'package:artiko/dependency_injector.dart';
import 'package:artiko/shared/routes/route_generator.dart';
import 'package:artiko/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dependency_injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupInjector();
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(
        details.exception, details.stack ?? StackTrace.empty);
  };

  runZonedGuarded(
    () => runApp(MyApp()),
    (Object error, stackTrace) {
      print(stackTrace.toString());
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ProviderScope(
        child: MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: lightTheme,
      title: 'Artiko',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    ));
  }
}
