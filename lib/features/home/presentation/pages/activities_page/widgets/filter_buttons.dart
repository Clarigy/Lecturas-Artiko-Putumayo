import 'package:artiko/features/home/presentation/pages/activities_page/exports/activities_page_labels.dart';
import 'package:flutter/material.dart';

class FilterButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(child: Text(BTN_TO_DO), onPressed: () {}),
          ElevatedButton(
            child: Text(
              BTN_EXECUTED,
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {},
            style: ElevatedButton.styleFrom(primary: Colors.white),
          ),
          ElevatedButton(
            child: Text(
              BTN_FAILED,
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {},
            style: ElevatedButton.styleFrom(primary: Colors.white),
          ),
        ],
      ),
    );
  }
}
