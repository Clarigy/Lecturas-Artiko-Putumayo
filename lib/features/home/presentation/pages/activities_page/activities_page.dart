import 'dart:developer';

import 'package:artiko/core/readings/data/data_sources/anomalies_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/domain/entities/anomalies_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/filter_buttons.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/readings_card.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/search_input.dart';
import 'package:artiko/features/home/presentation/pages/providers/home_provider.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/routes/route_args_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

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

final activitiesFilterProvider =
    ChangeNotifierProvider((_) => ActivitiesFilter());

class ActivitiesFilter extends ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

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
          Consumer(
            builder: (BuildContext context,
                T Function<T>(ProviderBase<Object?, T>) watch, Widget? child) {
              final bloc = watch(activitiesBlocProvider);
              final activitiesFilter = context.read(activitiesFilterProvider);

              return StreamBuilder<List<ReadingDetailItem>?>(
                  stream: bloc.getReadings(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      log(snapshot.error.toString());
                      activitiesFilter.isLoading = false;
                      return Center(child: Text(snapshot.error.toString()));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting ||
                        bloc.isLoading) {
                      if (!activitiesFilter.isLoading) {
                        activitiesFilter.isLoading = true;
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasData) {
                      context.read(activitiesFilterProvider).isLoading = false;
                      if (snapshot.data!.isEmpty) {
                        return Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(child: Offstage()),
                              Center(
                                child: SvgPicture.asset(
                                  'assets/images/svg/check_circle.svg',
                                  height: 97,
                                  width: 97,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .05,
                              ),
                              Text(
                                'Wow, todas tus actividades están completas, no tienes actividades por hacer.',
                                textAlign: TextAlign.center,
                              ),
                              Expanded(child: Offstage()),
                            ],
                          ),
                        );
                      }

                      if (bloc.readings == null ||
                          bloc.readings!.isEmpty ||
                          bloc.needRefreshList) {
                        bloc.readings = [...snapshot.data!];
                      }

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
                  });
            },
          ),
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
  int doneReadings = 0;
  late String activitiesType;
  late List<AnomalyItem?> anomalias;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Consumer(
          builder: (BuildContext context,
              T Function<T>(ProviderBase<Object?, T>) watch, Widget? child) {
            final bloc = watch(activitiesBlocProvider);

            return FutureBuilder(
                future: sl<AnomaliesDao>().getAnomalies(),
                builder:
                    (BuildContext context, AsyncSnapshot anomaliesSnapshot) {
                  if (anomaliesSnapshot.hasData) {
                    anomalias = anomaliesSnapshot.data;
                    return StreamBuilder<List<ReadingDetailItem>?>(
                        stream: sl<ReadingsDao>().getReadings(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.hasError)
                            return Offstage();

                          if (snapshot.hasData) {
                            doneReadings = 0;

                            _setDoneReadings(bloc, snapshot.data);

                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                  '$doneReadings/${snapshot.data?.length ?? '0'} actividades $activitiesType'),
                            );
                          }
                          return Offstage();
                        });
                  } else if (anomaliesSnapshot.hasError) {
                    return Icon(Icons.error_outline);
                  } else {
                    return CircularProgressIndicator();
                  }
                });
          },
        ));
  }

  void _setDoneReadings(
      ActivitiesBloc bloc, List<ReadingDetailItem>? allReadings) {
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
              anomalias
                  .any((e) => element.anomSec == e!.anomaliaSec && e.fallida))
            doneReadings++;
          activitiesType = 'fallidas';
          break;
      }
    });
  }
}
