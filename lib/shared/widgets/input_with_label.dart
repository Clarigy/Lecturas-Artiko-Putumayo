import 'package:flutter/material.dart';

class InputWithLabel extends StatelessWidget {
  final String label;
  final String? initialValue;
  final Color? labelColor;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final bool obscureText;
  final bool readOnly;
  final String? errorText;
  final String? hintText;
  final Function(String value)? onChange;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;

  final double? width;

  final Widget? suffixIcon;

  const InputWithLabel(
      {required this.label,
      this.textEditingController,
      this.textInputType,
      this.errorText,
      this.obscureText = false,
      this.onChange,
      this.autovalidateMode,
      this.validator,
      this.labelColor,
      this.hintText,
      this.readOnly = false,
      this.initialValue,
      this.suffixIcon,
      this.width});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: width ?? screenWidth * .8,
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
              initialValue: initialValue,
              autovalidateMode: autovalidateMode,
              autocorrect: false,
              controller: textEditingController,
              keyboardType: textInputType,
              validator: validator,
              readOnly: readOnly,
              obscureText: obscureText,
              onChanged: onChange,
              decoration: InputDecoration(
                  errorText: errorText,
                  filled: true,
                  isDense: true,
                  suffixIcon: suffixIcon,
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
