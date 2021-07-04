import 'package:artiko/core/readings/domain/use_case/sincronizar_readings_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_page.dart';
import 'package:artiko/shared/theme/app_colors.dart';
import 'package:artiko/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show StateNotifier, StateNotifierProvider, Consumer, BuildContextX;

import 'activities_page/activities_bloc.dart';
import 'exports/main_screen_labels.dart';
import 'map/map_page.dart';

final _mainScreenProvider =
    StateNotifierProvider.autoDispose<_MainStateNotifier, bool>(
        (ref) => _MainStateNotifier());

class _MainStateNotifier extends StateNotifier<bool> {
  _MainStateNotifier() : super(false);

  void changeIsLoading(bool value) => state = value;
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  static List<Widget> _widgetOptions = <Widget>[
    Offstage(),
    ActivitiesPage(),
    MapPage(),
  ];

  Future<void> _onItemTapped(int index) async {
    if (index == 0) {
      await _sincronizarReadings();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _sincronizarReadings() async {
    final mainScreenProvider = context.read(_mainScreenProvider.notifier);

    try {
      mainScreenProvider.changeIsLoading(true);

      final readings = sl<ActivitiesBloc>().readings!;
      await sl<SincronizarReadingsUseCase>().call(readings);
    } catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No pudimos sincronizar')));
    } finally {
      mainScreenProvider.changeIsLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: DefaultAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Consumer(
              builder: (BuildContext context, watch, Widget? child) {
                final isLoading = watch(_mainScreenProvider);
                return isLoading
                    ? CircularProgressIndicator(strokeWidth: 2)
                    : Icon(
                        Icons.sync,
                        color: AppColors.redColor,
                      );
              },
            ),
            label: LABEL_SYNCHRONIZE,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment,
              color: theme.primaryColor,
            ),
            label: LABEL_ACTIVITIES,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on,
              color: theme.primaryColor,
            ),
            label: LABEL_MAP,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.primaryColor,
        onTap: (index) async => await _onItemTapped(index),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
