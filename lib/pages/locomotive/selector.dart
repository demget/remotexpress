import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int loco = 1;

  @override
  Widget build(BuildContext context) {
    // final style = OutlinedButton.styleFrom(
    //   primary: Colors.grey[400],
    //   backgroundColor: Theme.of(context).primaryColorDark,
    //   side: BorderSide.none,
    //   shape: StadiumBorder(),
    //   elevation: 3,
    // );

    return NumberPicker.horizontal(
      minValue: 1,
      maxValue: 256,
      initialValue: widget.loco,
      onChanged: (v) => widget.onChanged(v.toInt()),
      haptics: true,
      textStyle: GoogleFonts.lato(color: Colors.grey),
      selectedTextStyle: GoogleFonts.lato(
        color: Theme.of(context).primaryColor,
        fontSize: 22,
      ),
    );

    // return Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     OutlinedButton(
    //       onPressed: () {},
    //       style: style,
    //       child: Text('+'),
    //     ),
    //     Container(
    //       width: 60,
    //       child: TextField(
    //         maxLines: null,
    //         style: TextStyle(fontSize: 15),
    //         textAlign: TextAlign.center,
    //         decoration: InputDecoration(labelText: ''),
    //         keyboardType: TextInputType.number,
    //         inputFormatters: [
    //           FilteringTextInputFormatter.digitsOnly,
    //           RangeTextInputFormatter(min: 0, max: 256),
    //         ],
    //       ),
    //     ),
    //     OutlinedButton(
    //       onPressed: () {},
    //       style: style,
    //       child: Text('-'),
    //     ),
    //   ],
    // );
  }
}
