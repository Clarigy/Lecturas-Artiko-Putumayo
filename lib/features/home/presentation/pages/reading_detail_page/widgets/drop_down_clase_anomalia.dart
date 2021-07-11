import 'package:artiko/core/readings/domain/entities/anomalia.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../reading_detail_bloc.dart';

class DropDownClaseAnomalia extends StatefulWidget {
  const DropDownClaseAnomalia({Key? key}) : super(key: key);

  @override
  _DropDownClaseAnomaliaState createState() => _DropDownClaseAnomaliaState();
}

class _DropDownClaseAnomaliaState extends State<DropDownClaseAnomalia> {
  bool isSetState = false;
  int times = 0;

  @override
  void initState() {
    final bloc = context.read(readingDetailBlocProvider);
    if (bloc.readingDetailItem.readingRequest.claseAnomalia == null) {
      bloc.setClaseAnomaliaSinRefresh(_buildAnomaliaItems(bloc)[0].value!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context,
          T Function<T>(ProviderBase<Object?, T>) watch, Widget? child) {
        final bloc = watch(readingDetailBlocProvider);
        final items = _buildAnomaliaItems(bloc);

        if (!isSetState) {
          if (bloc.readingDetailItem.readingRequest.claseAnomalia == null &&
              times == 0) {
            bloc.setClaseAnomaliaSinRefresh(
                _buildAnomaliaItems(bloc)[0].value!);
            times++;
          }
        }
        isSetState = false;

        if (!items.contains(bloc.claseAnomalia)) {
          bloc.setClaseAnomaliaSinRefresh(ClaseAnomalia.ninguna());
        }

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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: const Offset(0, -1),
                          ),
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: items.isEmpty
                          ? Offstage()
                          : DropdownButton(
                              isExpanded: true,
                              value: bloc.claseAnomalia,
                              items: items,
                              onChanged: !bloc.allowEdit()
                                  ? null
                                  : (dynamic selectedItem) {
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
      },
    );
  }

  List<DropdownMenuItem<ClaseAnomalia>> _buildAnomaliaItems(
      ReadingDetailBloc bloc) {
    List<DropdownMenuItem<ClaseAnomalia>> items = [
      new DropdownMenuItem(
          value: ClaseAnomalia.ninguna(),
          child: new Text(ClaseAnomalia.ninguna().nombre))
    ];

    if (bloc.anomalias.isEmpty) return items;

    bloc.anomalias
        .firstWhere((element) => element.anomaliaSec == bloc.anomaliaSec)
        .claseAnomalia
        .map((e) {
      if (!bloc.alreadyInsertReading) {
        if (!e.lectura) return e;
      } else {
        return e;
      }
    }).forEach((claseAnomalia) {
      if (claseAnomalia != null) {
        items.add(DropdownMenuItem(
            value: claseAnomalia, child: Text(claseAnomalia.nombre)));
      }
    });

    return items;
  }
}
