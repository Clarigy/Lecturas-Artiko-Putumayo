import 'package:artiko/features/login/presentation/pages/exports/images_path.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Center(
        child: Image.asset(
          IMAGE_COMPANY,
          width: size.width * .4,
          height: size.height * .2,
        ),
      ),
    );
  }
}
