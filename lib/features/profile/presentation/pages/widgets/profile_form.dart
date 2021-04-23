import 'package:artiko/features/login/presentation/pages/exports/images_path.dart';
import 'package:artiko/features/profile/presentation/manager/profile_bloc.dart';
import 'package:artiko/shared/widgets/input_with_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);

    final bloc = Provider.of<ProfileBloc>(context, listen: false);

    return Container(
      width: screenWidth,
      height: screenHeight * .55,
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(screenWidth * .05),
        crossAxisSpacing: 12,
        mainAxisSpacing: 5,
        childAspectRatio: 2,
        children: [
          ...bloc.getProfileInputModels().map((profileInputModel) {
            return InputWithLabel(
              label: profileInputModel.label.toUpperCase(),
              readOnly: true,
              initialValue: profileInputModel.text,
              suffix: !profileInputModel.allowCall
                  ? null
                  : Icon(
                      Icons.call,
                      color: theme.primaryColor,
                    ),
            );
          }).toList(),
          Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 25),
              child: Image.asset(IMAGE_COMPANY)),
        ],
      ),
    );
  }
}
