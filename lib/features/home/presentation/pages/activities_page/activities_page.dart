import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/filter_buttons.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/readings_card.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/search_input.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/routes/route_args_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ActivitiesBloc>();
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
          StreamBuilder<List<ReadingDetailItem>?>(
              stream: bloc.getReadings(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                if (snapshot.hasData) {
                   bloc.readings = snapshot.data;

                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, i) => InkWell(
                              child: ReadingsCard(item: snapshot.data![i]),
                              onTap: () => Navigator.pushNamed(
                                  context, AppRoutes.ReadingDetailScreen,
                                  arguments: {
                                    READING_DETAIL: snapshot.data![i],
                                    READINGS: snapshot.data
                                  }),
                            )),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }
}
