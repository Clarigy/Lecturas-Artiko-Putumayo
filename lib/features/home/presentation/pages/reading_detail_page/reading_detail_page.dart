import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/widgets/readings_card.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_bloc.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/drop_down_input.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/meter_reading.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/take_pictures.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/widgets/default_app_bar.dart';
import 'package:artiko/shared/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadingDetailPage extends StatefulWidget {
  ReadingDetailPage._();

  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => sl<ReadingDetailBloc>(),
      builder: (_, __) => ReadingDetailPage._(),
    );
  }

  @override
  _ReadingDetailPageState createState() => _ReadingDetailPageState();
}

class _ReadingDetailPageState extends State<ReadingDetailPage> {
  @override
  void dispose() {
    Provider.of<ReadingDetailBloc>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: DefaultAppBar(),
      bottomNavigationBar: _NavigationButtons(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * .03),
                child: Column(
                  children: [
                    ReadingsCard(),
                    MeterReading(),
                    DropDownInput(
                      label: 'Anomalía',
                    ),
                    DropDownInput(
                      label: 'Clase de Anomalía',
                    ),
                    TakePictures(
                      margin: EdgeInsets.only(top: 24),
                    ),
                    DropDownInput(
                      label: 'Observaciones',
                    ),
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
  }
}

class _NavigationButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          ),
          MainButton(
              text: 'Agregar nuevo medidor',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.CreateMeasure);
              }),
          InkWell(
            child: Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }
}
