import 'package:artiko/features/login/presentation/pages/exports/images_path.dart';
import 'package:artiko/shared/widgets/input_with_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight * .5,
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(screenWidth * .05),
        crossAxisSpacing: 12,
        mainAxisSpacing: 5,
        childAspectRatio: 2,
        children: [
          InputWithLabel(
            label: 'Cargo',
            readOnly: true,
            initialValue: 'Liniero',
          ),
          InputWithLabel(
            label: 'Cargo',
            readOnly: true,
            initialValue: 'Liniero',
          ),
          InputWithLabel(
            label: 'Cargo',
            readOnly: true,
            initialValue: 'Liniero',
          ),
          Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 25),
              child: Image.asset(IMAGE_COMPANY)),
        ],
      ),
    );
  }
}
