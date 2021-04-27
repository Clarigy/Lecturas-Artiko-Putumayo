import 'package:artiko/features/home/presentation/pages/activities_page/exports/activities_page_labels.dart';
import 'package:artiko/shared/widgets/input_with_label.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: InputWithLabel(
        label: '',
        width: screenWidth * .85,
        hintText: LABEL_SEARCH_MEASURE,
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {},
        ),
      ),
    );
  }
}