import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/dependency_injector.dart';
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
  LoginResponse? _currentUser;

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
            onSelected: (itemSelected) {
              if (itemSelected == PopUpMenuItemOption.PROFILE)
                _goToProfilePage();
              else if (itemSelected == PopUpMenuItemOption.LOGOUT)
                _goToLoginPage();
            },
            itemBuilder: (BuildContext context) => popUpButtonItems,
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Text(_currentUser?.nombre ?? '')),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  // backgroundImage: NetworkImage('${_currentUser?.href}/foto'),
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

  void _goToLoginPage() async {
    sl<FloorDatabase>().database.delete('current_user');
    sl<FloorDatabase>().database.delete('anomalies');
    sl<FloorDatabase>().database.delete('routes');
    sl<FloorDatabase>().database.delete('readings');
    sl<FloorDatabase>().database.delete('reading_images');

    sl<CacheStorageInterface>().clear();

    Navigator.pushNamed(context, AppRoutes.LoginScreen);
  }
}
