import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const MainButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Container(
      width: screenSize.width * .8,
      child: ElevatedButton(
          onPressed: onTap,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.headline6?.copyWith(
                color: theme.scaffoldBackgroundColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}
