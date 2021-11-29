import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remotexpress/net/loco.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class LocomotiveDirectionTrack extends StatefulWidget {
  final int direction;
  final void Function(int)? onChanged;

  LocomotiveDirectionTrack({
    required this.direction,
    required this.onChanged,
  });

  @override
  _LocomotiveDirectionTrackState createState() =>
      _LocomotiveDirectionTrackState();
}

class _LocomotiveDirectionTrackState extends State<LocomotiveDirectionTrack> {
  static final labelStyle = GoogleFonts.lato(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final Color dividerColor = Theme.of(context).primaryColor;

    return SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 8,
        inactiveTrackHeight: 8,
        trackCornerRadius: 4,
        activeDividerRadius: 3,
        inactiveDividerRadius: 3,
        thumbRadius: 15,
        activeLabelStyle: labelStyle,
        inactiveLabelStyle: labelStyle,
        disabledThumbColor: Theme.of(context).backgroundColor,
        activeDividerColor: dividerColor,
        inactiveDividerColor: dividerColor,
      ),
      child: SfSlider.vertical(
        min: LocoDirections.reverse,
        max: LocoDirections.forward,
        value: widget.direction,
        interval: 1,
        stepSize: 1,
        showDividers: true,
        onChanged: widget.onChanged != null
            ? (v) => widget.onChanged!(v.toInt())
            : null,
        thumbIcon: Center(
          child: Text(
            ['R', 'N', 'F'][widget.direction + 1],
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
        trackShape: _SfTrackShape(),
      ),
    );
  }
}

class _SfTrackShape extends SfTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Animation<double> enableAnimation,
    required Paint? inactivePaint,
    required Paint? activePaint,
    required TextDirection textDirection,
  }) {
    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: themeData.disabledInactiveTrackColor,
      end: themeData.inactiveTrackColor,
    );

    inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    super.paint(
      context,
      offset,
      thumbCenter?.translate(0.0, 0.0),
      startThumbCenter,
      endThumbCenter,
      parentBox: parentBox,
      themeData: themeData,
      enableAnimation: enableAnimation,
      inactivePaint: inactivePaint,
      activePaint: inactivePaint,
      textDirection: textDirection,
    );
  }
}
