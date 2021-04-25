import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeterReading extends StatelessWidget {
  final readingIntegers = TextEditingController();
  final readingDecimals = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(top: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * .55,
            child: TextFormField(
              autocorrect: false,
              controller: readingIntegers,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              ',',
              style: TextStyle(color: theme.primaryColor, fontSize: 60),
            ),
          ),
          Container(
            width: screenWidth * .2,
            child: TextFormField(
              autocorrect: false,
              controller: readingDecimals,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
          Center(
            child: IconButton(
                icon: Icon(
                  Icons.check_circle,
                  color: theme.primaryColor,
                  size: 36,
                ),
                onPressed: () {}),
          )
        ],
      ),
    );
  }
}
