import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remotexpress/net/loco.dart';
import 'package:remotexpress/net/station.dart';
import 'package:remotexpress/widgets/animated_toggle.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class LocomotivePage extends StatefulWidget {
  LocomotivePage({Key? key}) : super(key: key);

  @override
  _LocomotivePageState createState() => _LocomotivePageState();
}

class _LocomotivePageState extends State<LocomotivePage> {
  static const _speedSteps = [14, 28, 128];

  void _onSpeedStepLabel(AxisLabelCreatedArgs args) {
    args.text = _speedSteps[int.parse(args.text) - 1].toString();
  }

  int _speedStepIndex = 2;

  int _speedStep() {
    return _speedSteps[_speedStepIndex - 1];
  }

  int _speedInterval() {
    int speedStep = _speedStep();
    return speedStep == 128 ? 16 : speedStep ~/ 7;
  }

  int _previousSpeed = 0;
  int _visualSpeed = 0;

  void _forceSpeed(int value) {
    _previousSpeed = _visualSpeed;
    _speed = _visualSpeed = value;
  }

  int _power = 0;
  int _speed = 0;
  int _direction = 0;

  void _onPowerChanged(value) {
    setState(() {
      _power = value;
      if (_power != StationPower.idle) {
        _direction = LocoDirections.neutral;
        _forceSpeed(0);
      }
    });
  }

  void _onSpeedChanged(dynamic value) {
    if (value > _speedStep()) return;

    setState(() {
      _speed = value.round();
    });
  }

  void _onVisualSpeedChanged(_) {
    setState(() {
      _previousSpeed = _visualSpeed;
      _visualSpeed = _speed;
    });
  }

  void _onSpeedStepChanged(double value) {
    setState(() {
      int index = value.round();
      if (_speedStepIndex == index) return;

      _speedStepIndex = index;
      _forceSpeed(0);
    });
  }

  void _onDirectionChanged(value) {
    setState(() {
      int direction = value.toInt();
      if (_direction == direction) return;

      if (direction != LocoDirections.neutral) {
        _power = StationPower.idle;
      }

      _direction = direction;
      _forceSpeed(0);
    });
  }

  Row generateFunctionButtons(
    int rows,
    int columns, [
    int offset = 0,
    bool reversed = false,
  ]) {
    return Row(
      children: [
        ...List.generate(
          rows,
          (i) => Padding(
            padding: EdgeInsets.only(
              top: reversed ? 25 : i * 50,
              bottom: reversed ? i * 50 : 25,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                columns,
                (j) {
                  int n = (reversed ? 1 - i : i) + j * rows + offset + 1;
                  return Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        primary: Colors.grey[400],
                        backgroundColor: Theme.of(context).primaryColorDark,
                        side: BorderSide.none,
                        shape: StadiumBorder(),
                        elevation: 3,
                      ),
                      child: Text('F$n'),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 50,
                  left: 10,
                  right: 10,
                ),
                child: SfRadialGauge(
                  axes: [
                    RadialAxis(
                      startAngle: 50,
                      endAngle: 130,
                      minimum: 1,
                      maximum: 3,
                      interval: 1,
                      radiusFactor: 0.45,
                      showAxisLine: true,
                      showTicks: false,
                      minorTicksPerInterval: 0,
                      centerY: 0.65,
                      labelOffset: 20,
                      isInversed: true,
                      onLabelCreated: _onSpeedStepLabel,
                      ranges: [
                        GaugeRange(
                          startValue: 1,
                          endValue: 3,
                          sizeUnit: GaugeSizeUnit.factor,
                          startWidth: 0.03,
                          endWidth: 0.03,
                          color: Colors.transparent,
                        ),
                      ],
                      pointers: [
                        MarkerPointer(
                          enableDragging: true,
                          value: _speedStepIndex.toDouble(),
                          onValueChanged: _onSpeedStepChanged,
                          enableAnimation: false,
                          animationDuration: 300,
                          markerType: MarkerType.circle,
                          markerWidth: 12,
                          markerHeight: 12,
                          color: Colors.grey[100],
                          offsetUnit: GaugeSizeUnit.factor,
                          overlayRadius: 12,
                        ),
                      ],
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.06,
                        thicknessUnit: GaugeSizeUnit.factor,
                        cornerStyle: CornerStyle.bothCurve,
                        color: Colors.grey[100],
                      ),
                      axisLabelStyle: GaugeTextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    RadialAxis(
                      startAngle: 150,
                      endAngle: 30,
                      radiusFactor: 1,
                      canScaleToFit: true,
                      canRotateLabels: true,
                      showTicks: false,
                      minimum: 0,
                      maximum: _speedStep() + 0.01,
                      interval: _speedInterval().toDouble(),
                      labelOffset: 20,
                      ranges: [
                        GaugeRange(
                          startValue: 0,
                          endValue: _speedStep().toDouble(),
                          sizeUnit: GaugeSizeUnit.factor,
                          startWidth: 0.07,
                          endWidth: 0.07,
                          color: Colors.transparent,
                        ),
                      ],
                      pointers: [
                        RangePointer(
                          value: _visualSpeed > 0
                              ? _visualSpeed.toDouble() + 0.11
                              : 0,
                          enableAnimation: true,
                          animationType: AnimationType.ease,
                          animationDuration: 500,
                          color: Theme.of(context).primaryColor,
                          cornerStyle: CornerStyle.bothCurve,
                          width: 15,
                        ),
                      ],
                      annotations: [
                        GaugeAnnotation(
                          widget: Padding(
                            padding: EdgeInsets.only(bottom: 80),
                            child: Countup(
                              begin: _previousSpeed.toDouble(),
                              end: _visualSpeed.toDouble(),
                              duration: Duration(milliseconds: 500),
                              textScaleFactor: 8,
                              style: GoogleFonts.lato(
                                color: Colors.grey[350],
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          positionFactor: 0.03,
                        ),
                      ],
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.08,
                        thicknessUnit: GaugeSizeUnit.factor,
                        cornerStyle: CornerStyle.bothCurve,
                        color: Theme.of(context).primaryColor.withOpacity(0.28),
                      ),
                      axisLabelStyle: GaugeTextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      majorTickStyle: MajorTickStyle(
                        length: 6,
                        thickness: 3,
                      ),
                      minorTickStyle: MinorTickStyle(
                        length: 4,
                        thickness: 3,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 25,
                ),
                child: AnimatedToggle(
                  onToggleCallback: _onPowerChanged,
                  index: _power,
                  values: ['IDLE', 'STOP', 'OFF'],
                  width: 250,
                  backgroundColor: Theme.of(context).backgroundColor,
                  buttonColor: [
                    Color.fromARGB(0xff, 77, 172, 100),
                    Color.fromARGB(0xff, 234, 192, 49),
                    Color(0xffA81B24),
                  ][_power],
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 2 - 10,
            // bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                generateFunctionButtons(2, 5),
                Listener(
                  onPointerUp: _onVisualSpeedChanged,
                  child: SfSliderTheme(
                    data: SfSliderThemeData(
                      tickOffset: Offset(-0.2, 0.1),
                      thumbRadius: 12,
                      trackCornerRadius: 0,
                      activeTrackHeight: 5,
                      inactiveTrackHeight: 4,
                      activeLabelStyle: GoogleFonts.lato(
                        color: Theme.of(context).primaryColor.withOpacity(0.88),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      inactiveLabelStyle: GoogleFonts.lato(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      activeTickColor:
                          Theme.of(context).primaryColor.withOpacity(0.40),
                      inactiveTickColor:
                          Theme.of(context).primaryColor.withOpacity(0.40),
                      disabledInactiveTickColor:
                          Theme.of(context).backgroundColor,
                      disabledThumbColor: Theme.of(context).backgroundColor,
                    ),
                    child: SfSlider.vertical(
                      min: 0,
                      max: _speedStep(),
                      value: _speed,
                      interval: _speedInterval().toDouble(),
                      showLabels: true,
                      showTicks: true,
                      onChanged: _direction != LocoDirections.neutral
                          ? _onSpeedChanged
                          : null,
                      thumbIcon: Icon(
                        Icons.drag_handle,
                        color: Colors.white,
                        size: 18,
                      ),
                      labelFormatterCallback: (value, s) =>
                          value == 0 && _speed == 0 ? '' : s,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: SfSliderTheme(
                    data: SfSliderThemeData(
                      activeTrackHeight: 5,
                      inactiveTrackHeight: 5,
                      trackCornerRadius: 5,
                      thumbRadius: 12,
                      activeLabelStyle: GoogleFonts.lato(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      inactiveLabelStyle: GoogleFonts.lato(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      disabledThumbColor: Theme.of(context).backgroundColor,
                    ),
                    child: SfSlider.vertical(
                      min: LocoDirections.reverse,
                      max: LocoDirections.forward,
                      value: _direction,
                      interval: 1,
                      stepSize: 1,
                      showLabels: true,
                      onChanged: _power != StationPower.off
                          ? _onDirectionChanged
                          : null,
                      labelFormatterCallback: (value, _) {
                        return ['R', 'N', 'F'][value.toInt() + 1];
                      },
                      thumbIcon: Icon(
                        Icons.unfold_more,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      trackShape: _SfTrackShape(),
                    ),
                  ),
                ),
                generateFunctionButtons(2, 5, 10, true),
              ],
            ),
          ),
        ),
      ],
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

    inactivePaint = Paint();
    inactivePaint.color = inactiveTrackColorTween.evaluate(enableAnimation)!;

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
