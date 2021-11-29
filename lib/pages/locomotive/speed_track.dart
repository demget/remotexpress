import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class LocomotiveSpeedTrack extends StatefulWidget {
  final int speedStep;
  final int speed;
  final void Function(int)? onChanged;
  final void Function() onPointerUp;
  final int interval;

  LocomotiveSpeedTrack({
    required this.speedStep,
    required this.speed,
    required this.onChanged,
    required this.onPointerUp,
    this.interval = 1,
  });

  @override
  _LocomotiveSpeedTrackState createState() => _LocomotiveSpeedTrackState();
}

class _LocomotiveSpeedTrackState extends State<LocomotiveSpeedTrack> {
  static final labelStyle = GoogleFonts.lato(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  String formatLabel(dynamic value, String s) {
    int speed = widget.speed, interval = widget.interval - 1;
    bool inRange = speed > value - interval && speed < value + interval;
    return value == 0 || inRange ? '' : s;
  }

  @override
  Widget build(BuildContext context) {
    final Color tickColor = Theme.of(context).primaryColor.withOpacity(0.40);
    final Color activeColor = Theme.of(context).primaryColor.withOpacity(0.88);
    final Color disabledColor = Theme.of(context).backgroundColor;

    return Listener(
      onPointerUp: (_) => widget.onPointerUp(),
      child: SfSliderTheme(
        data: SfSliderThemeData(
          thumbRadius: 16,
          trackCornerRadius: 14,
          activeTrackHeight: 14,
          inactiveTrackHeight: 14,
          labelOffset: Offset(6, 0),
          activeLabelStyle: labelStyle.copyWith(color: activeColor),
          inactiveLabelStyle: labelStyle,
          activeTickColor: tickColor,
          inactiveTickColor: tickColor,
          disabledInactiveTickColor: disabledColor,
          disabledThumbColor: disabledColor,
        ),
        child: SfSlider.vertical(
          min: 0,
          max: widget.speedStep,
          value: widget.speed,
          interval: widget.interval.toDouble(),
          showLabels: true,
          showTicks: false,
          labelFormatterCallback: formatLabel,
          onChanged: widget.onChanged != null
              ? (v) => widget.onChanged!(v.toInt())
              : null,
          thumbIcon: Icon(
            Icons.drag_handle,
            color: Colors.white,
            size: 26,
          ),
          // thumbShape:
        ),
      ),
    );
  }
}
