import 'package:artiko/core/readings/data/data_sources/routes_dao.dart';
import 'package:artiko/core/readings/data/repository/reading_repository.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/create_measurer/presentation/manager/create_measure_bloc.dart';
import 'package:artiko/features/create_measurer/presentation/pages/validators/create_measure_validators.dart';
import 'package:artiko/features/home/presentation/pages/providers/home_provider.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_bloc.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/widgets/drop_down_input.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/routes/route_args_keys.dart';
import 'package:artiko/shared/widgets/input_with_label.dart';
import 'package:artiko/shared/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as P show Provider;

class CreateMeasureForm extends StatefulWidget {
  @override
  _CreateMeasureFormState createState() => _CreateMeasureFormState();
}

class _CreateMeasureFormState extends State<CreateMeasureForm> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterLayout());

    super.initState();
  }

  void afterLayout() async {
    try {
      await P.Provider.of<CreateMeasureBloc>(context, listen: false)
          .loadInitialData();
    } on Exception catch (_) {
      showSnackbar(
          context, 'No pudimos cargar la ubicación, intente más tarde');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);

    final bloc = P.Provider.of<CreateMeasureBloc>(context);

    return bloc.isLoading
        ? Padding(
            padding: EdgeInsets.only(top: 32),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * .05),
              child: Form(
                  key: bloc.formKey,
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 32),
                          child: DefaultLabel(label: 'Clase de servicio (*)')),
                      DropDownInput(
                          items: _buildClaseServicioItems(bloc.clasesServicio)
                              .toSet(),
                          onChanged: (value) =>
                              bloc.claseServicio = value.toString(),
                          value: bloc.claseServicio),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: InputWithLabel.number(
                          label: 'Número del medidor (*)',
                          textEditingController:
                              bloc.numeroMedidorTextEditingController,
                          width: double.infinity,
                          validator: validateNumber,
                          onSaved: (value) => bloc.numeroMedidor = value!,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: InputWithLabel(
                          label: 'Marca del medidor (*)',
                          textEditingController:
                              bloc.marcaMedidorTextEditingController,
                          width: double.infinity,
                          validator: validateRequiredValue,
                          onSaved: (value) {
                            bloc.marcaMedidor = value!;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: InputWithLabel.number(
                          label: 'Enteros del medidor (*)',
                          validator: validateNumber,
                          textEditingController:
                              bloc.enterosTextEditingController,
                          width: double.infinity,
                          onSaved: (value) => bloc.enteros = value!,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: InputWithLabel.number(
                          label: 'Decimales del medidor (*)',
                          validator: validateNumber,
                          textEditingController:
                              bloc.decimalesTextEditingController,
                          width: double.infinity,
                          onSaved: (value) {
                            bloc.decimales = value!;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: InputWithLabel(
                            label: 'Ubicación del medidor (*)',
                            textEditingController:
                                bloc.locationTextEditingController,
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: theme.primaryColor,
                            ),
                            readOnly: true,
                            onSaved: (_) {},
                            width: double.infinity),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 12),
                          child: DefaultLabel(label: 'Tipo medidor (*)')),
                      Row(
                        children: [
                          RoundedChoiceChip(
                            onTap: (value) {
                              if (!value)
                                bloc.tiposConsumoSeleccionados.add('A');
                              else
                                bloc.tiposConsumoSeleccionados.remove('A');
                            },
                            text: 'A',
                            isActive:
                                bloc.tiposConsumoSeleccionados.contains('A'),
                          ),
                          RoundedChoiceChip(
                            onTap: (value) {
                              if (!value)
                                bloc.tiposConsumoSeleccionados.add('R');
                              else
                                bloc.tiposConsumoSeleccionados.remove('R');
                            },
                            text: 'R',
                            isActive:
                                bloc.tiposConsumoSeleccionados.contains('R'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * .01,
                      ),
                      MainButton(
                          text: 'Guardar', onTap: () => _submitForm(bloc))
                    ],
                  )),
            ),
          );
  }

  void _submitForm(CreateMeasureBloc bloc) async {
    if (!bloc.formKey.currentState!.validate()) return;
    if (bloc.tiposConsumoSeleccionados.isEmpty) {
      showSnackbar(context, 'Por favor seleccione al menos un tipo de medidor');
      return;
    }

    bloc.formKey.currentState!.save();

    try {
      bloc.isLoading = true;

      final allReadings =
          await sl<ReadingRepository>().getAllReadingsFuture(null);
      final data = await bloc.buildReadingDetailItem(allReadings);
      final ids = await bloc.createMeasures(data);
      final activitiesBloc = context.read(activitiesBlocProvider);

      activitiesBloc.needRefreshList = true;
      final readings = await bloc.getReadings(activitiesBloc.filterType);

      final r = data[0].copyWith(id: ids[0]);
      final route =
          await sl<RoutesDao>().getRouteByLecturaRutaSec(r.lecturaRutaSec);

      if (route != null) r.routesItem = route;

      sl<ReadingDetailBloc>().reset();
      Navigator.pop(context);
      if (bloc.isFromMap) {
        Navigator.pushNamed(context, AppRoutes.ReadingDetailScreen,
            arguments: {READING_DETAIL: r, READINGS: readings});
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.ReadingDetailScreen,
            arguments: {READING_DETAIL: r, READINGS: readings});
      }
    } on Exception catch (_) {
      showSnackbar(context, 'No pudimos guardar la lectura, intenta de nuevo');
    }
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<DropdownMenuItem<String>> _buildClaseServicioItems(
      List<String> clasesServicios) {
    List<DropdownMenuItem<String>> items = [];

    clasesServicios.forEach((claseServicio) => items.add(new DropdownMenuItem(
        value: claseServicio, child: new Text(claseServicio))));

    return items;
  }
}

class RoundedChoiceChip extends StatefulWidget {
  final String text;
  final bool isActive;
  final void Function(bool) onTap;

  RoundedChoiceChip(
      {required this.text, required this.onTap, this.isActive = false});

  @override
  _RoundedChoiceChipState createState() =>
      _RoundedChoiceChipState(isActive: this.isActive);
}

class _RoundedChoiceChipState extends State<RoundedChoiceChip> {
  bool isActive;

  _RoundedChoiceChipState({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          isActive = !isActive;
        });
        return widget.onTap(!isActive);
      },
      child: Container(
        width: screenWidth * .13,
        height: screenWidth * .13,
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
            color: isActive ? theme.secondaryHeaderColor : Colors.grey,
            borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(widget.text,
              style: theme.textTheme.headline6?.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}

class DefaultLabel extends StatelessWidget {
  final String label;

  const DefaultLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(label,
            style: theme.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.bold, color: theme.primaryColor)));
  }
}
