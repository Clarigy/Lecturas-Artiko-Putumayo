import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_page.dart';
import 'package:artiko/shared/theme/app_colors.dart';
import 'package:artiko/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'activities_page/activities_bloc.dart';
import 'exports/main_screen_labels.dart';
import 'map/map_page.dart';

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

  void _onItemTapped(int index) {
    if (index == 0) {
      print('SINCRONIZANDO -----');
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (context) => sl<ActivitiesBloc>(),
      builder: (_, __) => Scaffold(
        appBar: DefaultAppBar(),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.sync,
                color: AppColors.redColor,
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
          onTap: _onItemTapped,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
