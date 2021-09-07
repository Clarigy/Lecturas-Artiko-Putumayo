import 'dart:convert';

import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/cache/keys/cache_keys.dart';
import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/use_case/close_terminal_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/presentation/pages/providers/home_provider.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/profile/presentation/manager/profile_bloc.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'close_terminal_status.dart';

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
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) async => await loadCurrentUserData());
    super.initState();
  }

  Future<void> loadCurrentUserData() async {
    final profileBloc = sl<ProfileBloc>();

    if (profileBloc.currentUser == null) {
      await profileBloc.getCurrentUserFromDb();
    }

    photo = await sl<CacheStorageInterface>().fetch(CacheKeys.USER_PHOTO);

    isLoading = false;
    _currentUser = profileBloc.currentUser;
    setState(() {});
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

  Future<void> _clearData() async {
    final db = sl<FloorDatabase>();
    await db.database.delete('anomalies');
    await db.database.delete('routes');
    await db.database.delete('readings');
    await db.database.delete('reading_images');

    await sl<CacheStorageInterface>().delete(CacheKeys.ID_USER);
  }

  void showWaitDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: Text(
                  'No cierres la aplicación hasta que el proceso finalice'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        });
  }

  void _logout() async {
    context.read(activitiesBlocProvider).needRefreshList = true;
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.LoginScreen, (route) => false);
  }

  Future<void> _closeTerminal() async {
    final closedTerminalStatus = context.read(closedTerminalStatusProvider);
    if (closedTerminalStatus) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La terminal ya ha sido cerrada')));
      return;
    }

    try {
      final readings = await sl<ReadingsDao>().getFutureReadings();
      if (readings!.any((element) => element.anomSec == null)) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('¿Estás seguro que deseas cerrar la terminal?'),
                content: Text('Las lecturas faltantes quedarán como fallidas'),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await doCloseTerminal(readings);
                      },
                      child: Text('Sí, continuar')),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('No'))
                ],
              );
            });
      } else {
        await doCloseTerminal(readings);
      }
    } catch (e) {
      //Close dialog
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No pudimos cerrar la terminal, inténtalo más tarde')));
    }
  }

  Future<void> doCloseTerminal(List<ReadingDetailItem> readings) async {
    try {
      showWaitDialog();
      await sl<CloseTerminalUseCase>()(readings);
      await _clearData();
      context.read(activitiesBlocProvider)
        ..needRefreshList = true
        ..doFilter();

      context.read(closedTerminalStatusProvider.notifier)..changeIsClosed(true);
      Navigator.pop(context);
    } on Failure catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No pudimos cerrar la terminal, inténtalo más tarde')));
    }
  }
}
