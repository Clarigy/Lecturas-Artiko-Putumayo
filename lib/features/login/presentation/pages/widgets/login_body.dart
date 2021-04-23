import 'package:artiko/features/login/presentation/manager/login_bloc.dart';
import 'package:artiko/features/login/presentation/pages/exports/module.exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_form.dart';

class LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * .15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .25),
                    _title(context),
                    SizedBox(height: height * .03),
                    LoginForm(),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _title(BuildContext context) {
    final bloc = Provider.of<LoginBloc>(context, listen: true);
    final theme = Theme.of(context);

    return bloc.loginState == LoginState.loading ? Offstage() : Row(
      children: [
        Text(
          LABEL_LOG_IN,
          style: theme.textTheme.headline6?.copyWith(color: Colors.white),
        ),
        Expanded(child: Container())
      ],
    );
  }
}
