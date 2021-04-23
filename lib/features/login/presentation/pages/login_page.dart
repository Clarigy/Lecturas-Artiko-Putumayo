import 'package:artiko/features/login/presentation/pages/exports/images_path.dart';
import 'package:artiko/features/login/presentation/pages/widgets/login_footer.dart';
import 'package:artiko/features/login/presentation/pages/widgets/login_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../manager/login_bloc.dart';
import 'widgets/login_body.dart';

class LoginPage extends StatelessWidget {
  final sl = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => sl<LoginBloc>()),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: Container()),
                    SvgPicture.asset(
                      IMAGE_LOGIN_BACKGROUND,
                      width: width,
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                ),
                Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: LoginFooter()),
                Column(
                  children: [
                    LoginHeader(),
                    LoginBody(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
