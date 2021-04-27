import 'package:artiko/features/create_measurer/presentation/manager/create_measure_bloc.dart';
import 'package:artiko/shared/widgets/input_with_label.dart';
import 'package:artiko/shared/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateMeasureForm extends StatefulWidget {
  @override
  _CreateMeasureFormState createState() => _CreateMeasureFormState();
}

class _CreateMeasureFormState extends State<CreateMeasureForm> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);

    final bloc = Provider.of<CreateMeasureBloc>(context, listen: false);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * .05),
      child: Form(
          key: bloc.formKey,
          child: Column(
            children: [
              InputWithLabel(
                label: 'Clase de servicio (*)',
                width: double.infinity,
              ),
              InputWithLabel(
                label: 'Número del medidor (*)',
                width: double.infinity,
              ),
              InputWithLabel(
                label: 'Marca del medidor (*)',
                width: double.infinity,
              ),
              InputWithLabel(
                label: 'Enteros del medidor (*)',
                width: double.infinity,
              ),
              InputWithLabel(
                label: 'Decimales del medidor (*)',
                width: double.infinity,
              ),
              InputWithLabel(
                  label: 'Ubicación del medidor (*)',
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: theme.primaryColor,
                  ),
                  width: double.infinity),
              Row(
                children: [
                  RoundedChoiceChip(
                    onTap: (value) => print(value),
                    text: 'R',
                  ),
                  RoundedChoiceChip(
                    onTap: (value) => print(value),
                    text: 'R',
                  ),
                  RoundedChoiceChip(
                    onTap: (value) => print(value),
                    text: 'R',
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * .01,
              ),
              MainButton(text: 'Guardar', onTap: _submitForm)
            ],
          )),
    );
  }

  void _submitForm() {}
}

class RoundedChoiceChip extends StatefulWidget {
  final String text;
  final void Function(bool) onTap;

  RoundedChoiceChip({required this.text, required this.onTap});

  @override
  _RoundedChoiceChipState createState() => _RoundedChoiceChipState();
}

class _RoundedChoiceChipState extends State<RoundedChoiceChip> {
  bool isActive;

  _RoundedChoiceChipState({this.isActive = false});

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
