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
      height: screenHeight * .8,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        crossAxisCount: 2,
        padding: EdgeInsets.all(screenWidth * .05),
        crossAxisSpacing: 12,
        mainAxisSpacing: 5,
        childAspectRatio: 1.7,
        children: [
          ...bloc.getProfileInputModels().map((profileInputModel) {
            return InputWithLabel(
              label: profileInputModel.label.toUpperCase(),
              readOnly: true,
              initialValue: profileInputModel.text,
              suffixIcon: !profileInputModel.allowCall
                  ? null
                  : GestureDetector(
                      onTap: () async => await bloc.launchURL(),
                      child: Icon(
                  Icons.call,
                  color: theme.primaryColor,
                ),
              ),
            );
          }).toList(),
          Image.asset(
            IMAGE_COMPANY,
            height: screenHeight * .07,
            width: screenWidth * .15,
          ),
        ],
      ),
    );
  }
}
