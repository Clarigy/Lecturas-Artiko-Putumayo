import 'dart:async';

import 'package:artiko/dependency_injector.dart';
import 'package:artiko/shared/routes/route_generator.dart';
import 'package:artiko/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as P;

import 'dependency_injector.dart';
import 'features/home/presentation/pages/activities_page/activities_bloc.dart';

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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ProviderScope(
        child: P.ChangeNotifierProvider(
      create: (context) => sl<ActivitiesBloc>(),
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: lightTheme,
        title: 'Artiko',
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    ));
  }
}
