import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:numberpicker/numberpicker.dart';

class LocomotiveSelector extends StatefulWidget {
  final int loco;
  final void Function(int) onChanged;

  LocomotiveSelector({
    required this.loco,
    required this.onChanged,
  });

  @override
  _LocomotiveSelectorState createState() => _LocomotiveSelectorState();
}

class _LocomotiveSelectorState extends State<LocomotiveSelector> {
  @override
  Widget build(BuildContext context) {
    return NumberPicker.horizontal(
      minValue: 1,
      maxValue: 256,
      initialValue: widget.loco,
      onChanged: (v) => widget.onChanged(v.toInt()),
      textStyle: TextStyle(color: Colors.grey),
      selectedTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20,
      ),
    );
  }
}
