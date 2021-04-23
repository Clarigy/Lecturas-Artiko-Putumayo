import 'package:flutter/material.dart';

class InputWithLabel extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool obscureText;
  final String? errorText;
  final String? hintText;
  final Function(String value)? onChange;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;

  const InputWithLabel(
      {required this.label,
      required this.textEditingController,
      required this.textInputType,
      this.errorText,
      this.obscureText = false,
      this.onChange,
      this.autovalidateMode,
      this.validator,
      this.labelColor,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: screenWidth * .8,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(label,
                        style: theme.textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: labelColor ?? theme.primaryColor)))),
            TextFormField(
              autovalidateMode: autovalidateMode,
              autocorrect: false,
              controller: textEditingController,
              keyboardType: textInputType,
              validator: validator,
              obscureText: obscureText,
              onChanged: onChange,
              decoration: InputDecoration(
                  errorText: errorText,
                  filled: true,
                  isDense: true,
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
