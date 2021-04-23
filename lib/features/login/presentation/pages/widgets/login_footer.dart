import 'package:artiko/features/login/presentation/pages/exports/images_path.dart';
import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * .18,
      width: size.width,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: size.width * .15),
              child: Center(child: Image.asset(IMAGE_ARTIKO))),
          Positioned(
            right: -45,
            top: 60,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: theme.scaffoldBackgroundColor),
              child: Container(
                margin: EdgeInsets.only(right: 26, bottom: 26),
                child: Icon(
                  Icons.call,
                  color: theme.secondaryHeaderColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
