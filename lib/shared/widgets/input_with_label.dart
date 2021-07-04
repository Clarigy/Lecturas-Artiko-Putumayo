import 'package:flutter/material.dart';

class InputWithLabel extends StatelessWidget {
  final String? errorText;
  final String? hintText;
  final String label;
  final String? initialValue;

  final Color? labelColor;

  final TextEditingController? textEditingController;
  final TextInputType? textInputType;

  final bool obscureText;
  final bool readOnly;

  final AutovalidateMode? autovalidateMode;

  final Function(String value)? onChange;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  final double? width;

  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final TextInputAction? textInputAction;

  const InputWithLabel(
      {required this.label,
      this.textEditingController,
      this.textInputType,
      this.errorText,
      this.obscureText = false,
      this.onChange,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.validator,
      this.labelColor,
      this.hintText,
      this.readOnly = false,
      this.initialValue,
      this.suffixIcon,
      this.width,
      this.prefixIcon,
      this.textInputAction,
      this.onSaved});

  const InputWithLabel.number(
      {required this.label,
      this.textEditingController,
      this.textInputType = TextInputType.number,
      this.errorText,
      this.obscureText = false,
      this.onChange,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.validator,
      this.labelColor,
      this.hintText,
      this.readOnly = false,
      this.initialValue,
      this.suffixIcon,
      this.width,
      this.prefixIcon,
      this.textInputAction,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: width ?? screenWidth * .8,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: screenHeight * .01),
                child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(label,
                        style: theme.textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: labelColor ?? theme.primaryColor)))),
            Container(
              decoration: BoxDecoration(
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
              child: TextFormField(
                initialValue: initialValue,
                autovalidateMode: autovalidateMode,
                autocorrect: false,
                controller: textEditingController,
                textInputAction: textInputAction,
                keyboardType: textInputType,
                validator: validator,
                onSaved: onSaved,
                readOnly: readOnly,
                obscureText: obscureText,
                onChanged: onChange,
                decoration: InputDecoration(
                  errorText: errorText,
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  isDense: true,
                  suffixIcon: suffixIcon,
                  contentPadding: EdgeInsets.fromLTRB(
                      12, screenHeight * .02, 12, screenHeight * .02),
                  hintText: hintText,
                  prefixIcon: prefixIcon,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
