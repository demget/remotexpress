import 'package:flutter/material.dart';
import 'package:remotexpress/widgets/clip.dart';

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

  void _onSpeedStepLabel(AxisLabelCreatedArgs args) {
    args.text = _speedSteps[int.parse(args.text) - 1].toString();
  }

  int _speed = 0;
  int _speedStep = 28;
  int _direction = 0;

  void _forceSpeed(int value) {
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
      _visualSpeed = _speed;
    });
  }

  void _onSpeedStep() {
    setState(() {
      int i = _speedSteps.indexOf(_speedStep);
      _speedStep = _speedSteps[i == 2 ? 0 : i + 1];
      _speedInterval = _speedStep == 128 ? 16 : _speedStep ~/ 7;
      _forceSpeed(0);
    });
  }

  void _onDirectionChanged(value) {
    setState(() {
      _direction = value.toInt();
      _forceSpeed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: SfRadialGauge(
                axes: [
                  RadialAxis(
                    startAngle: 25,
                    endAngle: 120,
                    minimum: 1,
                    maximum: 3,
                    interval: 1,
                    radiusFactor: 0.45,
                    showAxisLine: false,
                    showLastLabel: false,
                    minorTicksPerInterval: 0,
                    centerY: 0.65,
                    labelOffset: 10,
                    isInversed: true,
                    onLabelCreated: _onSpeedStepLabel,
                    majorTickStyle: MajorTickStyle(
                      length: 8,
                      thickness: 2,
                    ),
                    axisLabelStyle: GaugeTextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    ranges: [
                      GaugeRange(
                        startValue: 1,
                        endValue: 3,
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.03,
                        endWidth: 0.03,
                        color: Theme.of(context).primaryColor,
                        // color: _direction >= 0
                        //     ? Theme.of(context).primaryColor
                        //     : Colors.orange,
                      ),
                    ],
                    pointers: [
                      NeedlePointer(
                        value: _speedSteps.indexOf(_speedStep).toDouble() + 1,
                        needleLength: 0.45,
                        enableAnimation: true,
                        animationType: AnimationType.ease,
                        animationDuration: 500,
                        needleStartWidth: 1,
                        needleEndWidth: 4,
                        needleColor: Colors.red,
                      ),
                    ],
                  ),
                  RadialAxis(
                    startAngle: 155,
                    endAngle: 0,
                    radiusFactor: 1,
                    canScaleToFit: true,
                    canRotateLabels: true,
                    minimum: 0,
                    maximum: _speedStep.toDouble() + 0.01,
                    interval: _speedInterval.toDouble(),
                    labelOffset: 20,
                    ranges: [
                      GaugeRange(
                        startValue: 0,
                        endValue: _speedStep.toDouble(),
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.03,
                        endWidth: 0.03,
                        color: Theme.of(context).primaryColor,
                        // color: _direction >= 0
                        //     ? Theme.of(context).primaryColor
                        //     : Colors.orange,
                      ),
                    ],
                    pointers: [
                      NeedlePointer(
                        value: _visualSpeed.toDouble(),
                        knobStyle: KnobStyle(knobRadius: 0.1),
                        needleLength: 0.75,
                        enableAnimation: true,
                        animationType: AnimationType.ease,
                        animationDuration: 500,
                        needleStartWidth: 1,
                        needleEndWidth: 8,
                        needleColor: Colors.red,
                      ),
                    ],
                    axisLineStyle: AxisLineStyle(
                      thicknessUnit: GaugeSizeUnit.factor,
                      thickness: 0.03,
                    ),
                    majorTickStyle: MajorTickStyle(
                      length: 6,
                      thickness: 3,
                    ),
                    minorTickStyle: MinorTickStyle(
                      length: 4,
                      thickness: 3,
                    ),
                    axisLabelStyle: GaugeTextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 212),
              child: Align(
                alignment: Alignment.center,
                child: MaterialButton(
                  onPressed: _onSpeedStep,
                  textColor: Colors.white,
                  child: Icon(Icons.linear_scale),
                  shape: CircleBorder(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Stack(
                children: [
                  MaterialButton(
                    height: 75,
                    elevation: 5,
                    onPressed: () {},
                    color: Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  ClipPath(
                    clipper: SemiCircleClipper(direction: 1),
                    child: MaterialButton(
                      padding: EdgeInsets.only(bottom: 35),
                      height: 75,
                      elevation: 0,
                      onPressed: () {
                        print(1);
                      },
                      textColor: Colors.white,
                      color: Colors.red,
                      child: Text('OFF', style: TextStyle(fontSize: 16)),
                      shape: CircleBorder(),
                    ),
                  ),
                  ClipPath(
                    clipper: SemiCircleClipper(direction: -1),
                    child: MaterialButton(
                      padding: EdgeInsets.only(top: 35),
                      height: 75,
                      elevation: 0,
                      onPressed: () {},
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('ON', style: TextStyle(fontSize: 16)),
                      shape: CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: MaterialButton(
                height: 75,
                elevation: 5,
                onPressed: () {},
                textColor: Colors.white,
                color: Colors.orange,
                child: Text('STOP', style: TextStyle(fontSize: 20)),
                shape: CircleBorder(),
              ),
            ),
          ],
        ),
        Align(
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ...List.generate(
                    _buttonsPerPage,
                    (i) => Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_buttonsPerPage, (j) {
                          int n = j + i * _buttonsPerPage;
                          return Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: OutlinedButton(
                              onPressed: () {},
                              child: (i == 0 && j == 0)
                                  ? Icon(Icons.lightbulb)
                                  : Text('F${n}'),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              Listener(
                onPointerUp: _onVisualSpeedChanged,
                child: SfSlider.vertical(
                  min: 0.0,
                  max: _speedStep,
                  value: _speed,
                  interval: _speedInterval.toDouble(),
                  showTicks: true,
                  showLabels: true,
                  minorTicksPerInterval: 1,
                  onChanged: _onSpeedChanged,
                  thumbIcon: Icon(
                    Icons.drag_handle,
                    color: Colors.white,
                    size: 17.0,
                  ),
                ),
              ),
              Listener(
                onPointerUp: (_) => _forceSpeed(0),
                child: SfSliderTheme(
                  data: SfSliderThemeData(
                    activeTrackHeight: 5,
                    inactiveTrackHeight: 5,
                    trackCornerRadius: 5,
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
                      size: 17.0,
                    ),
                    trackShape: _SfTrackShape(),
                  ),
                ),
              ),
            ],
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
    inactivePaint = Paint();
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: themeData.disabledInactiveTrackColor,
        end: themeData.inactiveTrackColor);
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
