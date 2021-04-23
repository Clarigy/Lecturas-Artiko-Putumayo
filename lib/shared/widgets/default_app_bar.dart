import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final double? leadingWidth;

  DefaultAppBar({this.leading, this.leadingWidth})
      : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor: theme.primaryColor,
      leadingWidth: leadingWidth,
      leading: leading ??
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.scaffoldBackgroundColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
      actions: [
        Container(
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Text('Juan David Lembó')),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    'https://image.shutterstock.com/z/stock-vector-default-avatar-profile-icon-grey-photo-placeholder-518740741.jpg'),
              )
            ],
          ),
        ),
      ],
    );
  }
}
