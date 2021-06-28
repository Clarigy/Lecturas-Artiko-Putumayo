import 'package:artiko/features/login/presentation/pages/exports/images_path.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 28.0),
        child: Center(
          child: Image.asset(
            IMAGE_COMPANY,
            width: 135,
            height: 119,
          ),
        ),
      ),
    );
  }
}
