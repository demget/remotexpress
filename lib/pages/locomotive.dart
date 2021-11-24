import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  static const _buttonsPerPage = 4;

  // Visual data
  int _speedInterval = 4;
  int _visualSpeed = 0;
  int _previousSpeed = 0;

  void _onSpeedStepLabel(AxisLabelCreatedArgs args) {
    args.text = _speedSteps[int.parse(args.text) - 1].toString();
  }

  int _power = 0;
  int _speed = 0;
  int _speedStep = 28;
  int _speedStepIndex = 2;
  int _direction = 0;

  void _forceSpeed(int value) {
    _previousSpeed = _visualSpeed;
    _speed = _visualSpeed = value;
  }

  void _onSpeedChanged(dynamic value) {
    if (value > _speedStep) return;

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
      _speedStep = _speedSteps[_speedStepIndex - 1];
      _speedInterval = _speedStep == 128 ? 16 : _speedStep ~/ 7;
      _forceSpeed(0);
    });
  }

  void _onDirectionChanged(value) {
    setState(() {
      int direction = value.toInt();
      if (_direction == direction) return;

      _direction = value.toInt();
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
              left: 5,
              right: 5,
              top: reversed ? 15 : i * 40,
              bottom: reversed ? i * 40 : 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                columns,
                (j) {
                  int n = i + j * rows + offset + 1;
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                    ),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        backgroundColor: Color.fromRGBO(60, 62, 107, 1),
                        side: BorderSide.none,
                        elevation: 3,
                        shape: StadiumBorder(),
                      ),
                      child: Text('F${n}'),
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
          height: MediaQuery.of(context).size.height / 2 + 20,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: AnimatedToggle(
                  onToggleCallback: (value) {
                    setState(() {
                      _power = value;
                      if (_power == 2) {
                        _direction = 0;
                        _forceSpeed(0);
                      }
                    });
                  },
                  values: ['IDLE', 'STOP', 'OFF'],
                  width: 250,
                  backgroundColor: Color.fromARGB(0xff, 33, 33, 47),
                  buttonColor: [
                    Color.fromARGB(0xff, 77, 172, 100),
                    Color.fromARGB(0xff, 234, 192, 49),
                    Color(0xffA81B24),
                  ][_power],
                  textColor: Colors.white,
                ),
              ),
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
                          // Color.fromARGB(0xff, 77, 172, 100),
                          // Color.fromARGB(0xff, 234, 192, 49),
                          // Color(0xffb279a7),
                          offsetUnit: GaugeSizeUnit.factor,
                          overlayRadius: 12,
                        ),
                      ],
                      axisLineStyle: AxisLineStyle(
                        thicknessUnit: GaugeSizeUnit.factor,
                        thickness: 0.06,
                        cornerStyle: CornerStyle.bothCurve,
                        color: Colors.grey[100],
                        // Color.fromARGB(0xff, 77, 172, 100)
                        //  Color.fromARGB(0xff, 234, 192, 49),
                        // gradient: SweepGradient(
                        //   colors: <Color>[
                        //     Color(0xffb279a7),
                        //     Color(0xffd387ab),
                        //   ],
                        // ),
                      ),
                      axisLabelStyle: GaugeTextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      majorTickStyle: MajorTickStyle(
                        length: 8,
                        thickness: 2,
                        color: Color(0xffd387ab),
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
                      maximum: _speedStep.toDouble() + 0.01,
                      interval: _speedInterval.toDouble(),
                      labelOffset: 20,
                      ranges: [
                        GaugeRange(
                          startValue: 0,
                          endValue: _speedStep.toDouble(),
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
                          // Color.fromARGB(0xff, 77, 172, 100),
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
                            // child: Text(
                            //   _visualSpeed.toString(),
                            //   textScaleFactor: 8,
                            //   style: GoogleFonts.lato(
                            //     color: Colors.grey[350],
                            //     fontWeight: FontWeight.w300,
                            //   ),
                          ),
                          positionFactor: 0.03,
                        ),
                      ],
                      axisLineStyle: AxisLineStyle(
                        thicknessUnit: GaugeSizeUnit.factor,
                        thickness: 0.08,
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
              // Padding(
              //   padding: EdgeInsets.only(top: 38, left: 0),
              //   child: Align(
              //     alignment: Alignment.topLeft,
              //     child: ElevatedButton(
              //       onPressed: () {},
              //       child: Icon(Icons.stop_rounded, size: 40),
              //       style: ElevatedButton.styleFrom(
              //         shape: CircleBorder(),
              //         primary: Color.fromRGBO(233, 190, 65, 1),
              //         fixedSize: Size(40, 50),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(top: 38, right: 0),
              //   child: Align(
              //     alignment: Alignment.topRight,
              //     child: ElevatedButton(
              //       onPressed: () {},
              //       child: Icon(Icons.power_settings_new, size: 40),
              //       style: ElevatedButton.styleFrom(
              //         shape: CircleBorder(),
              //         primary: Theme.of(context).primaryColor,
              //         fixedSize: Size(48, 48),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(top: 205),
              //   child: Align(
              //     alignment: Alignment.center,
              //     child: MaterialButton(
              //       onPressed: _onSpeedStep,
              //       textColor: Colors.white,
              //       child: Icon(Icons.linear_scale),
              //       shape: CircleBorder(),
              //     ),
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Stack(
              //     children: [
              //       MaterialButton(
              //         height: 75,
              //         elevation: 5,
              //         onPressed: () {},
              //         color: Colors.transparent,
              //         shape: CircleBorder(),
              //       ),
              //       ClipPath(
              //         clipper: SemiCircleClipper(direction: 1),
              //         child: MaterialButton(
              //           padding: EdgeInsets.only(bottom: 35),
              //           height: 75,
              //           elevation: 0,
              //           onPressed: () {
              //             print(1);
              //           },
              //           textColor: Colors.white,
              //           color: Colors.red,
              //           child: Text('OFF', style: TextStyle(fontSize: 16)),
              //           shape: CircleBorder(),
              //         ),
              //       ),
              //       ClipPath(
              //         clipper: SemiCircleClipper(direction: -1),
              //         child: MaterialButton(
              //           padding: EdgeInsets.only(top: 35),
              //           height: 75,
              //           elevation: 0,
              //           onPressed: () {},
              //           textColor: Colors.white,
              //           color: Colors.green,
              //           child: Text('ON', style: TextStyle(fontSize: 16)),
              //           shape: CircleBorder(),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: MaterialButton(
              //     height: 75,
              //     elevation: 5,
              //     onPressed: () {},
              //     textColor: Colors.white,
              //     color: Colors.orange,
              //     child: Text('STOP', style: TextStyle(fontSize: 20)),
              //     shape: CircleBorder(),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 2 + 10,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      disabledThumbColor: Color.fromARGB(0xff, 33, 33, 47),
                      disabledInactiveTrackColor:
                          Theme.of(context).primaryColor.withOpacity(0.05),
                      activeTickColor:
                          Theme.of(context).primaryColor.withOpacity(0.40),
                      inactiveTickColor:
                          Theme.of(context).primaryColor.withOpacity(0.40),
                      disabledInactiveTickColor:
                          Theme.of(context).primaryColor.withOpacity(0.20),
                    ),
                    child: SfSlider.vertical(
                      min: 0,
                      max: _speedStep,
                      value: _speed,
                      interval: _speedInterval.toDouble(),
                      showLabels: true,
                      showTicks: true,
                      onChanged: _direction != 0 ? _onSpeedChanged : null,
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
                      // labelOffset: Offset(-25, 0),
                    ),
                    child: SfSlider.vertical(
                      min: -1,
                      max: 1,
                      value: _direction,
                      interval: 1,
                      stepSize: 1,
                      showLabels: true,
                      onChanged: _onDirectionChanged,
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
