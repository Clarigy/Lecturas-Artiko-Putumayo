import 'package:artiko/features/home/presentation/pages/activities_page/exports/activities_page_labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../activities_bloc.dart';

class FilterButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ActivitiesBloc>();
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: bloc.filterType == FilterType.PENDING
                      ? theme.primaryColor
                      : Colors.white),
              child: Text(
                BTN_TO_DO,
                style: TextStyle(
                    color: bloc.filterType == FilterType.PENDING
                        ? Colors.white
                        : Colors.black),
              ),
              onPressed: () => bloc.filterType = FilterType.PENDING),
          ElevatedButton(
            child: Text(
              BTN_EXECUTED,
              style: TextStyle(
                  color: bloc.filterType == FilterType.EXCECUTED
                      ? Colors.white
                      : Colors.black),
            ),
            onPressed: () => bloc.filterType = FilterType.EXCECUTED,
            style: ElevatedButton.styleFrom(
                primary: bloc.filterType == FilterType.EXCECUTED
                    ? theme.primaryColor
                    : Colors.white),
          ),
          ElevatedButton(
            child: Text(
              BTN_FAILED,
              style: TextStyle(
                  color: bloc.filterType == FilterType.FAILED
                      ? Colors.white
                      : Colors.black),
            ),
            onPressed: () => bloc.filterType = FilterType.FAILED,
            style: ElevatedButton.styleFrom(
                primary: bloc.filterType == FilterType.FAILED
                    ? theme.primaryColor
                    : Colors.white),
          ),
        ],
      ),
    );
  }
}
