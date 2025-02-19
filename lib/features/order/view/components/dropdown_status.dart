import 'package:flutter/material.dart';

class DropdownStatus extends StatelessWidget {
  final Map<String, String> items;
  final String selectedItem;
  final void Function(String?)? onChanged;

  const DropdownStatus({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DropdownButton<String>(
        value: selectedItem,
        onChanged: onChanged,
        items: items.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        isExpanded: true,
        underline: Container(
          height: 2,
          color: Colors.grey,
        ),
      ),
    );
  }
}