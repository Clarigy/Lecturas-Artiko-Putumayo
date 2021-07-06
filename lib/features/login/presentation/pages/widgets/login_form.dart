import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/login/presentation/manager/login_bloc.dart';
import 'package:artiko/features/login/presentation/pages/exports/labels_screen.dart';
import 'package:artiko/features/login/presentation/pages/validators/field_validators.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/widgets/input_with_label.dart';
import 'package:artiko/shared/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LoginBloc>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return bloc.loginState == LoginState.loading
        ? Center(
            child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ))
        : Form(
            key: bloc.formKey,
            child: Column(
              children: [
                InputWithLabel(
                  label: LABEL_EMAIL,
                  labelColor: Colors.white,
                  hintText: 'usuario@gmail.com',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: bloc.userIdentificationTextController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: validateEmail,
                ),
                SizedBox(height: 10),
                InputWithLabel(
                  label: LABEL_PASSWORD,
                  labelColor: Colors.white,
                  hintText: 'al menos  8 caracteres',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: validatePassword,
                  textEditingController: bloc.userPasswordTextController,
                  obscureText: !bloc.isPasswordVisible,
                  textInputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: screenHeight * .03),
                MainButton(
                    text: BTN_LOG_IN,
                    onTap: () {
                      if (bloc.formKey.currentState!.validate()) {
                        _actionButton();
                      }
                    }),
              ],
            ),
          );
  }

  void _actionButton() {
    final _bloc = context.read<LoginBloc>();
    final user = _bloc.userIdentificationTextController.text.trim();
    final password = _bloc.userPasswordTextController.text.trim();

    _bloc.doLogin(user, password).then((LoginResponse response) async {
      _bloc.currentUser = response;
      goToLoadingScreen();
    }).catchError((onError) async {
      print(onError);
      _showAlertBadCredentials(onError);
    });
  }

  void goToLoadingScreen() async {
    await Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.LoadingScreen, (Route<dynamic> route) => false);
  }

  void _showAlertBadCredentials(onError) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error al iniciar sesión'),
            content: Text(onError
                    .toString()
                    .startsWith('No puedes iniciar sesión con otro')
                ? onError.toString()
                : 'Tuvimos un problema al iniciar sesión, inténtalo de nuevo'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              )
            ],
          );
        });
  }
}
