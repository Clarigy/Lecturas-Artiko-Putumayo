import 'package:artiko/features/home/presentation/pages/activities_page/exports/activities_page_labels.dart';
import 'package:artiko/shared/widgets/input_with_label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../activities_bloc.dart';

class SearchInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ActivitiesBloc>();

    return Center(
      child: InputWithLabel(
        label: '',
        width: double.infinity,
        textEditingController: bloc.filterTextController,
        onChange: (_) => bloc.doFilter(),
        hintText: LABEL_SEARCH_MEASURE,
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {},
        ),
      ),
    );
  }
}
