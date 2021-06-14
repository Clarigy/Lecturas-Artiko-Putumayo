import 'package:artiko/core/readings/domain/entities/anomalia.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
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
  final ReadingDetailItem readingDetailItem;

  ReadingDetailPage._(this.readingDetailItem);

  static Widget init(ReadingDetailItem readingDetailItem) {
    return ChangeNotifierProvider(
      create: (context) => sl<ReadingDetailBloc>(),
      builder: (_, __) => ReadingDetailPage._(readingDetailItem),
    );
  }

  @override
  _ReadingDetailPageState createState() => _ReadingDetailPageState();
}

class _ReadingDetailPageState extends State<ReadingDetailPage> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => afterLayout());
    super.initState();
  }

  void afterLayout() async {
    try {
      await context.read<ReadingDetailBloc>().loadInitInfo();
    } catch (_) {
      final snackBar =
          SnackBar(content: Text('No pudimos cargar la información'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    Provider.of<ReadingDetailBloc>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);

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
                    ReadingsCard(
                      item: widget.readingDetailItem,
                    ),
                    MeterReading(),
                    Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text('Anomalia',
                            style: theme.textTheme.bodyText2!.copyWith(
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
                          child: _DropdDownClaseAnomalia(),
                        ),
                      ],
                    ),
                    TakePictures(
                      margin: EdgeInsets.only(top: 24),
                      readingId: widget.readingDetailItem.numeroMedidor,
                    ),
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

class DropDownAnomalias extends StatefulWidget {
  const DropDownAnomalias({Key? key}) : super(key: key);

  @override
  _DropDownAnomaliasState createState() => _DropDownAnomaliasState();
}

class _DropDownAnomaliasState extends State<DropDownAnomalias> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ReadingDetailBloc>();

    return DropDownInput(
      items: _buildClaseAnomaliaItems(bloc.anomalias).toSet(),
      onChanged: (value) {
        bloc.anomaliaSec = value;
      },
      value: bloc.anomaliaSec,
    );
  }

  List<DropdownMenuItem<int>> _buildClaseAnomaliaItems(
      List<Anomalia> anomalias) {
    List<DropdownMenuItem<int>> items = [];

    anomalias.forEach((anomalia) => items.add(new DropdownMenuItem(
        value: anomalia.anomaliaSec, child: new Text(anomalia.anomalia))));

    return items;
  }
}

class _DropdDownClaseAnomalia extends StatefulWidget {
  const _DropdDownClaseAnomalia({Key? key}) : super(key: key);

  @override
  __DropdDownClaseAnomaliaState createState() =>
      __DropdDownClaseAnomaliaState();
}

class __DropdDownClaseAnomaliaState extends State<_DropdDownClaseAnomalia> {
  bool isSetState = false;

  @override
  void initState() {
    final bloc = context.read<ReadingDetailBloc>();
    bloc.claseAnomalia = _buildAnomaliaItems(bloc)[0].value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ReadingDetailBloc>();
    if (!isSetState) {
      bloc.claseAnomalia = _buildAnomaliaItems(bloc)[0].value!;
    }
    isSetState = false;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: .62)),
                  child: DropdownButton(
                      isExpanded: true,
                      value: bloc.claseAnomalia,
                      items: _buildAnomaliaItems(bloc),
                      onChanged: (dynamic selectedItem) {
                        setState(() {
                          isSetState = true;
                          bloc.claseAnomalia = selectedItem;
                        });
                      }),
                ),
              ]))
        ],
      ),
    );
  }

  List<DropdownMenuItem<ClaseAnomalia>> _buildAnomaliaItems(
      ReadingDetailBloc bloc) {
    List<DropdownMenuItem<ClaseAnomalia>> items = [];

    bloc.anomalias
        .firstWhere((element) => element.anomaliaSec == bloc.anomaliaSec)
        .claseAnomalia
        .forEach((claseAnomalia) => items.add(new DropdownMenuItem(
            value: claseAnomalia, child: new Text(claseAnomalia.nombre))));

    return items;
  }
}
