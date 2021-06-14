import 'package:flutter/material.dart';

class DropDownInput extends StatefulWidget {
  final Set<DropdownMenuItem> items;
  final void Function(dynamic value) onChanged;
  final dynamic value;

  DropDownInput(
      {required this.items, required this.onChanged, required this.value});

  @override
  _DropDownInputState createState() => _DropDownInputState();
}

class _DropDownInputState extends State<DropDownInput> {
  // dynamic value;

  @override
  Widget build(BuildContext context) {
    // if (value == null) {
    //   value = widget.items.first.value;
    // }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: .62)),
                  child: DropdownButton(
                      isExpanded: true,
                      value: widget.value,
                      items: widget.items.toList(),
                      onChanged: (dynamic selectedItem) {
                        // setState(() {
                        // value = selectedItem;
                        widget.onChanged(selectedItem);
                        // });
                      }),
                ),
              ]))
        ],
      ),
    );
  }
}
