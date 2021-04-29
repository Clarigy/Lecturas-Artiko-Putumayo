import 'package:artiko/features/home/presentation/pages/activities_page/widgets/filter_buttons.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/readings_card.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/search_input.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:flutter/material.dart';

class ActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * .9,
      child: Column(
        children: [
          SearchInput(),
          SizedBox(
            height: 10,
          ),
          FilterButtons(),
          SizedBox(
            height: 10,
          ),
          InkWell(
            child: ReadingsCard(),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.ReadingDetailScreen),
          ),
        ],
      ),
    );
  }
}
