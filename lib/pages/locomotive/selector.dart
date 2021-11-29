import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      // haptics: true,
      textStyle: GoogleFonts.lato(color: Colors.grey),
      selectedTextStyle: GoogleFonts.lato(
        color: Theme.of(context).primaryColor,
        fontSize: 22,
      ),
    );
  }
}
