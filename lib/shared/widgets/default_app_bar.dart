import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/profile/presentation/manager/profile_bloc.dart';
import 'package:artiko/shared/routes/app_routes.dart';
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
            },
            itemBuilder: (BuildContext context) => popUpButtonItems,
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Text(_currentUser?.nombre ?? '')),
                // CircleAvatar(
                //   radius: 30,
                //   backgroundColor: Colors.transparent,
                //   backgroundImage: NetworkImage(_currentUser?.foto ??
                //       'https://image.shutterstock.com/z/stock-vector-default-avatar-profile-icon-grey-photo-placeholder-518740741.jpg'),
                // )
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
}
