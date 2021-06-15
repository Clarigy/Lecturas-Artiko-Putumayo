import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_bloc.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeterReading extends StatefulWidget {
  @override
  _MeterReadingState createState() => _MeterReadingState();
}

class _MeterReadingState extends State<MeterReading> {
  late ReadingDetailItem detailItem;

  @override
  void initState() {
    detailItem = context
        .read(readingDetailBlocProvider)
        .readingDetailItem
        .copyWith(readingRequest: ReadingRequest());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);

    final bloc = context.read(readingDetailBlocProvider);

    return Container(
      margin: EdgeInsets.only(top: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * .55,
            child: TextFormField(
              autocorrect: false,
              controller: bloc.readingIntegers,
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
              controller: bloc.readingDecimals,
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
                onPressed: () {
                  _validateReading(context);
                }),
          )
        ],
      ),
    );
  }

  void _validateReading(BuildContext context) {
    final bloc = context.read(readingDetailBlocProvider);

    final request = detailItem.readingRequest;

    request.lectura = getReadingValue(bloc);

    if (request.lectura != null &&
        request.lectura! <= double.parse(detailItem.lecturaAnterior) &&
        request.lecturaIntento2 == null) {
      if (request.lecturaIntento1 != null) {
        clearInputs(bloc);
        request
          ..lecturaIntento2 = request.lectura
          ..lectura = null;
        showSnackbar(context,
            'Por favor, confirme lectura. Lectura ingresada es menor o igual que la lectura anterior');
      } else {
        clearInputs(bloc);
        request
          ..lecturaIntento1 = request.lectura
          ..lectura = null;
        showSnackbar(context, 'Por favor, confirme lectura');
      }
    } else if (request.lecturaIntento1 != null &&
        request.lecturaIntento1! <= double.parse(detailItem.lecturaAnterior) &&
        request.lecturaIntento2 != null &&
        request.lecturaIntento2! <= double.parse(detailItem.lecturaAnterior) &&
        request.lectura != null) {
      if (request.lectura! > double.parse(detailItem.lecturaAnterior)) {
        //TODO PREGUNTAR 1.E
        bloc.verifiedReading = true;
      } else if (request.lectura! <= double.parse(detailItem.lecturaAnterior)) {
        bloc.requiredAnomaliaByMeterReading = true;
        bloc.requiredPhotoByMeterReading = true;
        bloc.verifiedReading = true;
      }
    }
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
