import 'package:flutter/material.dart';

class DropDownInput extends StatefulWidget {
  final String label;

  DropDownInput({required this.label});

  @override
  _DropDownInputState createState() => _DropDownInputState();
}

class _DropDownInputState extends State<DropDownInput> {
  int value = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // final registerPresenter = context.watch<RegisterPresenter>();

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(children: [
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(widget.label,
                            style: theme.textTheme.bodyText2!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor)))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: .62)),
                  child: DropdownButton(
                      isExpanded: true,
                      value: value,
                      items: _getDropDownMenuItems(),
                      onChanged: (int? selectedItem) {
                        setState(() {
                          value = selectedItem!;
                        });
                      }),
                ),
              ]))
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> _getDropDownMenuItems() {
    List<DropdownMenuItem<int>> items = [];

    [1, 2, 3, 4, 5].forEach((key) => items.add(
        new DropdownMenuItem(value: key, child: new Text(key.toString()))));

    return items;
  }
}
