import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/filter_buttons.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/readings_card.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/search_input.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/routes/route_args_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as P show Provider;

import '../../../../../dependency_injector.dart';

final activitiesCounterProvider =
    ChangeNotifierProvider((_) => ActivitiesCounter());

class ActivitiesCounter extends ChangeNotifier {
  int _activitiesCount = 0;

  int get activitiesCount => _activitiesCount;

  set activitiesCount(int value) {
    _activitiesCount = value;
    notifyListeners();
  }
}

class ActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = P.Provider.of<ActivitiesBloc>(context);
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
                              child: Column(
                                children: [
                                  if (i == 0) _Counter(),
                                  ReadingsCard(item: snapshot.data![i]),
                                ],
                              ),
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

class _Counter extends StatefulWidget {
  const _Counter({Key? key}) : super(key: key);

  @override
  __CounterState createState() => __CounterState();
}

class __CounterState extends State<_Counter> {
  bool isLoading = true;
  int doneReadings = 0;
  int allReadingsCount = 0;
  List<ReadingDetailItem>? allReadings;
  late String activitiesType;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterLayout());
    super.initState();
  }

  void afterLayout() async {
    try {
      allReadings = await sl<ReadingsDao>().getFutureReadings();
      allReadingsCount = allReadings!.length;
    } on Exception catch (_) {} finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = P.Provider.of<ActivitiesBloc>(context);

    doneReadings = 0;

    _setDoneReadings(bloc);

    return Align(
        alignment: AlignmentDirectional.bottomStart,
        child: isLoading
            ? CircularProgressIndicator()
            : Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                    '$doneReadings/$allReadingsCount actividades $activitiesType'),
              ));
  }

  void _setDoneReadings(ActivitiesBloc bloc) {
    allReadings?.forEach((element) {
      switch (bloc.filterType) {
        case FilterType.PENDING:
          if (element.idRequest == null) doneReadings++;
          activitiesType = 'por hacer';
          break;
        case FilterType.EXCECUTED:
          if (element.idRequest != null) doneReadings++;
          activitiesType = 'ejecutadas';
          break;
        case FilterType.FAILED:
          if (element.idRequest != null &&
              element.readingRequest.anomaliaSec == 26) doneReadings++;
          activitiesType = 'fallidas';
          break;
      }
    });
  }
}
