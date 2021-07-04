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

  @override
  Widget build(BuildContext context) {
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
                  child: DropdownButton(
                      isExpanded: true,
                      value: widget.value,
                      items: widget.items.toList(),
                      onChanged: (dynamic selectedItem) {
                        widget.onChanged(selectedItem);
                      }),
                ),
              ]))
        ],
      ),
    );
  }
}
