import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_bloc.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeterReading extends StatefulWidget {
  final ReadingDetailItem readingDetailItem;

  MeterReading({required this.readingDetailItem});

  @override
  _MeterReadingState createState() => _MeterReadingState();
}

class _MeterReadingState extends State<MeterReading> {
  late ReadingDetailItem detailItem;

  @override
  void initState() {
    detailItem = widget.readingDetailItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bloc = context.read(readingDetailBlocProvider);

    return Container(
      margin: EdgeInsets.only(top: 22),
      child: Form(
        key: bloc.formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: TextFormField(
                autocorrect: false,
                controller: bloc.readingIntegers,
                keyboardType: TextInputType.number,
                maxLength: bloc.readingDetailItem.nroEnteros,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: bloc.readingDetailItem.nroDecimales == 0
                    ? TextInputAction.done
                    : TextInputAction.next,
                validator: (value) {
                  if (!bloc.claseAnomalia.lectura ||
                      bloc.readingDetailItem.detalleLecturaRutaSec == null)
                    return null;
                  if (value == null || value.isEmpty) return 'Campo requerido';
                },
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 8),
                decoration: InputDecoration(
                    filled: true,
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            if (bloc.readingDetailItem.nroDecimales > 0)
              ...decimalPart(context),
            Center(
              child: IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: bloc.verifiedReading
                        ? theme.secondaryHeaderColor
                        : theme.primaryColor,
                    size: 36,
                  ),
                  onPressed: () {
                    _validateReading(context);
                  }),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> decimalPart(BuildContext context) {
    final theme = Theme.of(context);

    final bloc = context.read(readingDetailBlocProvider);

    return [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          ',',
          style: TextStyle(color: theme.primaryColor, fontSize: 60),
        ),
      ),
      Flexible(
        flex: 2,
        child: TextFormField(
          autocorrect: false,
          maxLength: bloc.readingDetailItem.nroDecimales,
          controller: bloc.readingDecimals,
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (!bloc.claseAnomalia.lectura ||
                bloc.readingDetailItem.detalleLecturaRutaSec == null)
              return null;
            if (value == null ||
                value.isEmpty && bloc.readingDetailItem.nroDecimales > 0) {
              return 'Campo requerido';
            }
          },
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.w600, letterSpacing: 8),
          decoration: InputDecoration(
            filled: true,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      )
    ];
  }

  void _validateReading(BuildContext context) {
    final bloc = context.read(readingDetailBlocProvider);
    if (!bloc.formKey.currentState!.validate()) return;
    final request = detailItem.readingRequest;

    request.lectura = getReadingValue(bloc);

    if (_esAnomalidaErrada(request)) {
      _lecturaPosibleAnomaliaErrada(request, bloc, context);
    } else if (request.lecturaIntento1 != null &&
        request.lecturaIntento1! <= double.parse(detailItem.lecturaAnterior) &&
        request.lecturaIntento2 != null &&
        request.lecturaIntento2! <= double.parse(detailItem.lecturaAnterior) &&
        request.lectura != null) {
      if (request.lectura! > double.parse(detailItem.lecturaAnterior)) {
        bloc.verifiedReading = true;
      } else if (request.lectura! <= double.parse(detailItem.lecturaAnterior)) {
        bloc.requiredAnomaliaByMeterReading = true;
        bloc.requiredPhotoByMeterReading = true;
        bloc.verifiedReading = true;
      }
    } else if (_esLecturaNormal(request)) {
      _lecturaNormal(bloc);
    } else if (_esBandaConAnomaliaObligatoria(request)) {
      _lecturaBandaAnomaliaObligatoria(request, context, bloc);
    } else if (request.lectura! > detailItem.falsaMaxima) {
      _lecturaBandaConsumoExcedida(request, bloc, context);
    } else {
      bloc.verifiedReading = true;
    }
  }

  void _lecturaBandaConsumoExcedida(
      ReadingRequest request, ReadingDetailBloc bloc, BuildContext context) {
    if (request.lecturaIntento1 != null) {
      _lecturaBandaConsumoExcedidadSegundoIntento(bloc, request, context);
    } else if (request.lecturaIntento2 != null) {
      _lecturaBandaConsumoExcedidadTercerIntento(bloc);
    } else {
      _lecturaPosibleAnomaliaErradaPrimerIntento(bloc, request, context);
    }
  }

  void _lecturaBandaConsumoExcedidadTercerIntento(ReadingDetailBloc bloc) {
    bloc.requiredAnomaliaByMeterReading = true;
    bloc.requiredPhotoByMeterReading = true;

    final anomaliaSec = bloc.anomalias
        .firstWhere((element) => element.anomalia == 'AL5_2')
        .anomaliaSec;
    bloc.setAnomaliaSec(
        anomaliaSec,
        bloc.anomalias
            .firstWhere((element) => element.anomaliaSec == anomaliaSec)
            .claseAnomalia
            .first);

    bloc.verifiedReading = true;
  }

  void _lecturaBandaConsumoExcedidadSegundoIntento(
      ReadingDetailBloc bloc, ReadingRequest request, BuildContext context) {
    clearInputs(bloc);
    request
      ..lecturaIntento2 = request.lectura
      ..lectura = null;
    bloc.verifiedReading = false;
    showSnackbar(
        context, 'Por favor, confirme Lectura. Lectura ingresada es excedida');
  }

  void _lecturaPosibleAnomaliaErrada(
      ReadingRequest request, ReadingDetailBloc bloc, BuildContext context) {
    if (request.lecturaIntento1 != null) {
      _lecturaPosibleAnomaliaErradaSegundoIntento(bloc, request, context);
    } else {
      _lecturaPosibleAnomaliaErradaPrimerIntento(bloc, request, context);
    }
  }

  void _lecturaBandaAnomaliaObligatoria(
      ReadingRequest request, BuildContext context, ReadingDetailBloc bloc) {
    if (request.lecturaIntento1 != null) {
      _lecturaBandaAnomaliaObligatoriaIntento2(request, context);
    } else {
      _lecturaPosibleAnomaliaErradaPrimerIntento(bloc, request, context);
    }
  }

  void _lecturaNormal(ReadingDetailBloc bloc) {
    bloc.requiredAnomaliaByMeterReading = false;
    bloc.verifiedReading = true;
  }

  bool _esLecturaNormal(ReadingRequest request) {
    return request.lectura! >= detailItem.lecturaMinima &&
        request.lectura! <= detailItem.lecturaMaxima;
  }

  void _lecturaBandaAnomaliaObligatoriaIntento2(
      ReadingRequest request, BuildContext context) {
    final bloc = context.read(readingDetailBlocProvider);
    final anomaliaSec = bloc.anomalias
        .firstWhere((element) => element.anomalia == 'AL5_1')
        .anomaliaSec;

    request..lecturaIntento2 = request.lectura;
    showSnackbar(
      context,
      'Por favor ingrese anomalía, consumo fuera de rango',
    );
    bloc.setAnomaliaSec(
        anomaliaSec,
        bloc.anomalias
            .firstWhere((element) => element.anomaliaSec == anomaliaSec)
            .claseAnomalia
            .first);

    bloc.verifiedReading = true;
  }

  bool _esBandaConAnomaliaObligatoria(ReadingRequest request) {
    return request.lectura! > detailItem.lecturaMaxima &&
            request.lectura! <= detailItem.falsaMaxima ||
        request.lectura! < detailItem.lecturaMaxima ||
        request.lectura! > detailItem.falsaMinima;
  }

  bool _esAnomalidaErrada(ReadingRequest request) {
    return request.lectura != null &&
        request.lectura! <= double.parse(detailItem.lecturaAnterior) &&
        request.lecturaIntento2 == null;
  }

  void _lecturaPosibleAnomaliaErradaPrimerIntento(
      ReadingDetailBloc bloc, ReadingRequest request, BuildContext context) {
    clearInputs(bloc);
    request
      ..lecturaIntento1 = request.lectura
      ..lecturaIntento2 = null
      ..lectura = null;
    bloc.verifiedReading = false;
    showSnackbar(context, 'Por favor, confirme lectura');
  }

  void _lecturaPosibleAnomaliaErradaSegundoIntento(
      ReadingDetailBloc bloc, ReadingRequest request, BuildContext context) {
    clearInputs(bloc);
    request
      ..lecturaIntento2 = request.lectura
      ..lectura = null;
    bloc.verifiedReading = false;
    showSnackbar(context,
        'Por favor, confirme lectura. Lectura ingresada es menor o igual que la lectura anterior');
  }

  void clearInputs(ReadingDetailBloc bloc) {
    bloc.readingIntegers.clear();
    bloc.readingDecimals.clear();
  }

  double? getReadingValue(ReadingDetailBloc bloc) {
    final integer = bloc.readingIntegers.text;
    final decimal = bloc.readingDecimals.text;

    final valueInString = '$integer.$decimal';

    return double.tryParse(valueInString);
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
