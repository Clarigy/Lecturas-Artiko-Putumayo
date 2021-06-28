import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/core/readings/domain/use_case/get_anomalies_use_case.dart';
import 'package:artiko/core/readings/domain/use_case/update_reading_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/domain/use_cases/delete_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id.dart';
import 'package:artiko/features/home/domain/use_cases/insert_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/update_reading_images.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/readings_card.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_bloc.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/drop_down_anomalias.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/drop_down_clase_anomalia.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/drop_down_input.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/meter_reading.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/take_pictures.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/routes/route_args_keys.dart';
import 'package:artiko/shared/widgets/default_app_bar.dart';
import 'package:artiko/shared/widgets/input_with_label.dart';
import 'package:artiko/shared/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

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
    sl<UpdateReadingUseCase>(),
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
    final bloc = context.read<ReadingDetailBloc>(readingDetailBlocProvider);
    print('falsaMaxima  ${widget.readingDetailItem.falsaMaxima}');
    print('falsaMinima  ${widget.readingDetailItem.falsaMinima}');
    print('lecturaMaxima  ${widget.readingDetailItem.lecturaMaxima}');
    print('lecturaMinima  ${widget.readingDetailItem.lecturaMinima}');
    print('lecturaAnterior  ${widget.readingDetailItem.lecturaAnterior}');
    bloc
      ..readingDetailItem = widget.readingDetailItem
      ..readings = widget.readings;

    final _item = bloc.readingDetailItem;

    detailItem = _item.copyWith(
        id: _item.id,
        readingRequest: _item.idRequest == null
            ? ReadingRequest.empty(
                detalleLecturaRutaSec: _item.detalleLecturaRutaSec,
                id: _item.id,
                alreadySync: false)
            : null);

    bloc.initializeInputValues(detailItem);
    super.initState();
  }

  void afterLayout() async {
    try {
      final bloc = context.read<ReadingDetailBloc>(readingDetailBlocProvider);
      await bloc.loadInitInfo(detailItem);

      if (detailItem.readingRequest.lectura != null)
        bloc.verifiedReading = true;
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
        return Scaffold(
          appBar: DefaultAppBar(),
          bottomNavigationBar: _NavigationButtons(detailItem),
          body: bloc.readingDetailState == ReadingDetailState.loading
              ? Center(child: CircularProgressIndicator())
              : Column(
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
                                readingDetailItem: widget.readingDetailItem,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Align(
                                    alignment: AlignmentDirectional.bottomStart,
                                    child: Text(
                                        'Anomalia${bloc.requiredAnomaliaByMeterReading ?? false ? '*' : ''}',
                                        style: theme.textTheme.bodyText2!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: theme.primaryColor))),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 2,
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
    final theme = Theme.of(context);
    return !bloc.verifiedReading && bloc.claseAnomalia.lectura
        ? []
        : [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text('Observaciones',
                      style: theme.textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor))),
            ),
            DropDownInput(
              onChanged: (value) {
                bloc.observacion = value;
              },
              value: bloc.observacion,
              items: _buildObservacionesItems(bloc).toSet(),
            ),
            if (bloc.observacion == 'Otro')
              Container(
                margin: EdgeInsets.only(top: 10),
                child: InputWithLabel(
                  width: double.infinity,
                  label: '',
                  textEditingController: bloc.observacionTextController,
                ),
              ),
            TakePictures(
              detailItem: detailItem,
              margin: EdgeInsets.only(top: 24),
              readingId: widget.readingDetailItem.id.toString(),
            ),
          ];
  }

  List<DropdownMenuItem<String>> _buildObservacionesItems(
      ReadingDetailBloc bloc) {
    List<DropdownMenuItem<String>> items = [];

    bloc.claseAnomalia.observaciones.forEach((observacion) => items.add(
        new DropdownMenuItem(
            value: observacion, child: new Text(observacion))));

    items.add(new DropdownMenuItem(value: 'Otro', child: new Text('Otro')));

    return items;
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
                final index = bloc.readings.indexWhere(
                    (element) => bloc.readingDetailItem.id == element.id);
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
                onTap: detailItem.readingRequest.alreadySync
                    ? null
                    : () async {
                        if (!bloc.formKey.currentState!.validate()) return;
                        if (bloc.claseAnomalia.lectura) {
                          if (!bloc.verifiedReading) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('La lectura no está verificada')));
                            return;
                          }
                        }
                        if (bloc.requiredPhotoByMeterReading != null &&
                                bloc.requiredPhotoByMeterReading! &&
                                detailItem.readingRequest.fotos.isEmpty ||
                      bloc.claseAnomalia.fotografia &&
                          detailItem.readingRequest.fotos.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Al menos una foto es requerida')));
                    return;
                  }
                  if (bloc.requiredAnomaliaByMeterReading != null &&
                      bloc.requiredAnomaliaByMeterReading! &&
                      bloc.anomaliaSec == 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('La anomalía es requerida')));
                    return;
                  }

                  try {
                    final position = await Geolocator.getCurrentPosition();
                    detailItem.anomSec = bloc.claseAnomalia.anomSec;

                    detailItem.readingRequest
                      ..anomaliaSec = bloc.anomaliaSec
                      ..latLecturaTomada = position.latitude.toString()
                      ..longLecturaTomada = position.longitude.toString()
                      ..claseAnomalia = bloc.claseAnomalia.nombre
                      ..observacionAnomalia = bloc.observacion
                      ..observacionLectura = bloc.observacion == 'Otro'
                          ? bloc.observacionTextController.text
                          : null
                      ..observacionSec = bloc.observacion != 'Otro'
                          ? bloc.observaciones
                              .firstWhere((element) =>
                                  element.descripcion == element.descripcion &&
                                  element.anomaliaSec == bloc.anomaliaSec)
                              .observacionSec
                          : null;

                    await bloc.updateReading(detailItem);

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lectura guardada con éxito')));
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('No pudimos guardar la lectura')));
                  }
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
    final index = bloc.readings
        .indexWhere((element) => bloc.readingDetailItem.id == element.id);
    if (index == -1 || index == bloc.readings.length - 1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Es la última'),
      ));
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.ReadingDetailScreen,
        arguments: {
          READING_DETAIL: bloc.readings[index + 1],
          READINGS: bloc.readings
        });
  }
}
