import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/create_measurer/presentation/manager/create_measure_bloc.dart';
import 'package:artiko/features/create_measurer/presentation/pages/widgets/create_measure_form.dart';
import 'package:artiko/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateMeasurePage extends StatefulWidget {
  CreateMeasurePage._(this.isFromMap);

  final bool isFromMap;

  static Widget init(bool isFromMap) {
    return ChangeNotifierProvider(
      create: (context) => sl<CreateMeasureBloc>(),
      builder: (_, __) => CreateMeasurePage._(isFromMap),
    );
  }

  @override
  _CreateMeasurePageState createState() => _CreateMeasurePageState();
}

class _CreateMeasurePageState extends State<CreateMeasurePage> {
  @override
  Widget build(BuildContext context) {
    context.read<CreateMeasureBloc>().isFromMap = widget.isFromMap;
    return Scaffold(
      appBar: DefaultAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreateMeasureForm(),
          ],
        ),
      ),
    );
  }
}
