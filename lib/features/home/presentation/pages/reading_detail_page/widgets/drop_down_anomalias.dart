import 'package:artiko/core/readings/domain/entities/anomalia.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'drop_down_input.dart';

class DropDownAnomalias extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bloc = watch(readingDetailBlocProvider);

    return DropDownInput(
      items: _buildClaseAnomaliaItems(bloc.anomalias).toSet(),
      onChanged: (value) {
        bloc.setAnomaliaSec(
            value,
            bloc.anomalias
                .firstWhere((element) => element.anomaliaSec == value)
                .claseAnomalia
                .first);
      },
      value: bloc.anomaliaSec,
    );
  }

  List<DropdownMenuItem<int>> _buildClaseAnomaliaItems(
      List<Anomalia> anomalias) {
    if (anomalias.isEmpty) return [];

    List<DropdownMenuItem<int>> items = [];

    anomalias.forEach((anomalia) => items.add(new DropdownMenuItem(
        value: anomalia.anomaliaSec, child: new Text(anomalia.anomalia))));

    return items;
  }
}
