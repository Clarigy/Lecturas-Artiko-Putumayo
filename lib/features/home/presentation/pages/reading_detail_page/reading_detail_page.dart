import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/core/readings/domain/use_case/get_anomalies_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/domain/use_cases/delete_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id.dart';
import 'package:artiko/features/home/domain/use_cases/insert_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/update_reading_images.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/readings_card.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_bloc.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/drop_down_anomalias.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/drop_down_clase_anomalia.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/meter_reading.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/take_pictures.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/routes/route_args_keys.dart';
import 'package:artiko/shared/widgets/default_app_bar.dart';
import 'package:artiko/shared/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final readingDetailBlocProvider = ChangeNotifierProvider.autoDispose((ref) {
  ref.onDispose(() {
    print('Dispose');
  });
  return ReadingDetailBloc(
    sl<GetReadingImagesByReadingIdUseCase>(),
    sl<InsertReadingImages>(),
    sl<UpdateReadingImages>(),
    sl<DeleteReadingImages>(),
    sl<GetAnomaliesUseCase>(),
  );
});

class ReadingDetailPage extends StatefulWidget {
  final ReadingDetailItem readingDetailItem;
  final List<ReadingDetailItem> readings;

  ReadingDetailPage._(this.readingDetailItem, this.readings);

  static Widget init(
      ReadingDetailItem readingDetailItem, List<ReadingDetailItem> readings) {
    return ReadingDetailPage._(readingDetailItem, readings);
  }

  @override
  _ReadingDetailPageState createState() => _ReadingDetailPageState();
}

class _ReadingDetailPageState extends State<ReadingDetailPage> {
  late ReadingDetailItem detailItem;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => afterLayout());

    print('falsaMaxima  ${widget.readingDetailItem.falsaMaxima}');
    print('falsaMinima  ${widget.readingDetailItem.falsaMinima}');
    print('lecturaMaxima  ${widget.readingDetailItem.lecturaMaxima}');
    print('lecturaMinima  ${widget.readingDetailItem.lecturaMinima}');
    print('lecturaAnterior  ${widget.readingDetailItem.lecturaAnterior}');
    context.read<ReadingDetailBloc>(readingDetailBlocProvider)
      ..readingDetailItem = widget.readingDetailItem
      ..readings = widget.readings;

    detailItem = context
        .read(readingDetailBlocProvider)
        .readingDetailItem
        .copyWith(readingRequest: ReadingRequest());

    super.initState();
  }

  void afterLayout() async {
    try {
      await context
          .read<ReadingDetailBloc>(readingDetailBlocProvider)
          .loadInitInfo();
    } catch (_) {
      final snackBar =
          SnackBar(content: Text('No pudimos cargar la información'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);

    return Consumer(
      builder: (BuildContext context, watch, Widget? child) {
        final bloc = watch(readingDetailBlocProvider);
        return bloc.readingDetailState == ReadingDetailState.loading
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: DefaultAppBar(),
                bottomNavigationBar: _NavigationButtons(detailItem),
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * .03),
                          child: Column(
                            children: [
                              ReadingsCard(
                                item: widget.readingDetailItem,
                              ),
                              MeterReading(
                                readingDetailItem: detailItem,
                              ),
                              Align(
                                  alignment: AlignmentDirectional.bottomStart,
                                  child: Text(
                                      'Anomalia${bloc.requiredAnomaliaByMeterReading ?? false ? '*' : ''}',
                                      style: theme.textTheme.bodyText2!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.primaryColor))),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: DropDownAnomalias(),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: DropDownClaseAnomalia(),
                                  ),
                                ],
                              ),
                              ...buildDependsWidgetMeter(context, bloc),
                              // DropDownInput(
                              //   label: 'Observaciones',
                              // ),
                              SizedBox(
                                height: screenHeight * .03,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  List<Widget> buildDependsWidgetMeter(
      BuildContext context, ReadingDetailBloc bloc) {
    return !bloc.verifiedReading
        ? []
        : [
            TakePictures(
              detailItem: detailItem,
              margin: EdgeInsets.only(top: 24),
              readingId: widget.readingDetailItem.numeroMedidor,
            ),
          ];
  }
}

class _NavigationButtons extends ConsumerWidget {
  final ReadingDetailItem detailItem;

  _NavigationButtons(this.detailItem);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bloc = watch(readingDetailBlocProvider);
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                final index = bloc.readings.indexOf(bloc.readingDetailItem);
                if (index == -1 || index == 0) return;
                Navigator.pushReplacementNamed(
                    context, AppRoutes.ReadingDetailScreen, arguments: {
                  READING_DETAIL: bloc.readings[index - 1],
                  READINGS: bloc.readings
                });
              }),
          SizedBox(width: 8),
          Flexible(
            flex: 1,
            child: MainButton(
                text: 'Nuevo medidor',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.CreateMeasure);
                }),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            flex: 1,
            child: MainButton(
                text: 'Guardar',
                onTap: () {
                  detailItem.readingRequest.anomaliaSec = bloc.anomaliaSec;

                  print('fotos ${detailItem.readingRequest.fotos}');
                  print('lectura ${detailItem.readingRequest.lectura}');
                  print('anomaliaSec ${detailItem.readingRequest.anomaliaSec}');
                }),
          ),
          SizedBox(width: 12),
          InkWell(
            child: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _navigateToNext(bloc, context);
            },
          )
        ],
      ),
    );
  }

  void _navigateToNext(ReadingDetailBloc bloc, BuildContext context) {
    final index = bloc.readings.indexOf(bloc.readingDetailItem);
    if (index == -1 || index == bloc.readings.length + 1) return;
    Navigator.pushReplacementNamed(context, AppRoutes.ReadingDetailScreen,
        arguments: {
          READING_DETAIL: bloc.readings[index + 1],
          READINGS: bloc.readings
        });
  }
}
