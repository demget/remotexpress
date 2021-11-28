import 'package:flutter/material.dart';
import 'package:remotexpress/widgets/animated_toggle.dart';

class LocomotivePower extends StatefulWidget {
  final int power;
  final void Function(int) onPowerChanged;

  LocomotivePower({
    required this.power,
    required this.onPowerChanged,
  });

  @override
  _LocomotivePowerState createState() => _LocomotivePowerState();
}

class _LocomotivePowerState extends State<LocomotivePower> {
  static const List<Color> colors = [
    Color.fromARGB(0xff, 77, 172, 100),
    Color.fromARGB(0xff, 234, 192, 49),
    Color(0xffA81B24),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedToggle(
      index: widget.power,
      onToggleCallback: (v) => widget.onPowerChanged(v.toInt()),
      values: ['IDLE', 'STOP', 'OFF'],
      heightScale: 1.5,
      buttonColor: colors[widget.power],
      backgroundColor: Theme.of(context).backgroundColor,
      textColor: Colors.white,
    );
  }
}
