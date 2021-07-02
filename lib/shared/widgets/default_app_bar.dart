import 'dart:convert';

import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/cache/keys/cache_keys.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/domain/use_case/close_terminal_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/profile/presentation/manager/profile_bloc.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

enum PopUpMenuItemOption { PROFILE, CLOSE_TERMINAL, LOGOUT }

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? leading;
  final double? leadingWidth;

  DefaultAppBar({this.leading, this.leadingWidth})
      : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  _DefaultAppBarState createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  late String photo;
  LoginResponse? _currentUser;
  bool isLoading = true;

  @override
  void initState() {
    loadCurrentUserData();
    super.initState();
  }

  Future<void> loadCurrentUserData() async {
    final profileBloc = sl<ProfileBloc>();

    if (profileBloc.currentUser == null) {
      await profileBloc.getCurrentUserFromDb();
    }

    photo = await sl<CacheStorageInterface>().fetch(CacheKeys.USER_PHOTO);

    isLoading = false;
    setState(() => _currentUser = profileBloc.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<PopupMenuItem<PopUpMenuItemOption>> popUpButtonItems = [
      PopupMenuItem(
        child: Text('Perfil'),
        value: PopUpMenuItemOption.PROFILE,
      ),
      PopupMenuItem(
        child: Text('Cerrar terminal'),
        value: PopUpMenuItemOption.CLOSE_TERMINAL,
      ),
      PopupMenuItem(
        child: Text('Cerrar sesión'),
        value: PopUpMenuItemOption.LOGOUT,
      ),
    ];

    return AppBar(
      elevation: 0,
      backwardsCompatibility: true,
      backgroundColor: theme.primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      leadingWidth: widget.leadingWidth,
      leading: widget.leading,
      actions: [
        Container(
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.only(right: 20),
          child: PopupMenuButton(
            onSelected: (PopUpMenuItemOption itemSelected) async {
              switch (itemSelected) {
                case PopUpMenuItemOption.PROFILE:
                  _goToProfilePage();
                  break;
                case PopUpMenuItemOption.CLOSE_TERMINAL:
                  await _closeTerminal();
                  break;
                case PopUpMenuItemOption.LOGOUT:
                  _logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => popUpButtonItems,
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * .5,
                    margin: EdgeInsets.only(right: 12),
                    child: Text(
                      _currentUser?.nombre ?? '',
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.transparent,
                        backgroundImage: MemoryImage(
                          Base64Decoder().convert(photo),
                        ),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _goToProfilePage() {
    Navigator.pushNamed(context, AppRoutes.ProfileScreen);
  }

  void _clearData() {
    sl<FloorDatabase>().database.delete('anomalies');
    sl<FloorDatabase>().database.delete('routes');
    sl<FloorDatabase>().database.delete('readings');
    sl<FloorDatabase>().database.delete('reading_images');

    sl<CacheStorageInterface>().clear();
  }

  void _logout() async {
    sl<ActivitiesBloc>().needRefreshList = true;
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.LoginScreen, (route) => false);
  }

  Future<void> _closeTerminal() async {
    try {
      final readings = await sl<ReadingsDao>().getFutureReadings();
      if (readings!.any((element) => element.anomSec == null)) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('Tienes lecturas por hacer, ¿deseas continuar?'),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'No cierres la aplicación hasta que el proceso finalice')));
                        await sl<CloseTerminalUseCase>()(readings);
                        _clearData();
                        _logout();
                      },
                      child: Text('Sí, continuar')),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('No'))
                ],
              );
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'No cierres la aplicación hasta que el proceso finalice')));
        await sl<CloseTerminalUseCase>()(readings);
        _clearData();
        _logout();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No pudimos cerrar la terminal, inténtalo más tarde')));
    }
  }
}
