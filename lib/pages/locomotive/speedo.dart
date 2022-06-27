import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:countup/countup.dart';

class LocomotiveSpeedo extends StatefulWidget {
  final List<int> speedSteps;
  final void Function(int) onSpeedStepChanged;
  final int speed;
  final int speedStep;
  final int visualSpeed;
  final int previousSpeed;

  LocomotiveSpeedo({
    required this.speedSteps,
    required this.onSpeedStepChanged,
    required this.speedStep,
    this.speed = 0,
    this.visualSpeed = 0,
    this.previousSpeed = 0,
  }) {
    assert(speedSteps.length != 0);
  }

  @override
  _LocomotiveSpeedoState createState() => _LocomotiveSpeedoState();

  static int speedInterval(int speedStep) {
    return speedStep == 128 ? 16 : speedStep ~/ 7;
  }
}

class _LocomotiveSpeedoState extends State<LocomotiveSpeedo> {
  late int previousSpeedStep;

  @override
  void initState() {
    super.initState();
    previousSpeedStep = widget.speedStep;
  }

  double speedStepIndex() {
    return widget.speedSteps.indexOf(widget.speedStep) + 1.0;
  }

  void onSpeedStepLabel(AxisLabelCreatedArgs args) {
    args.text = widget.speedSteps[int.parse(args.text) - 1].toString();
  }

  void onSpeedStepChanged(double index) {
    final speedStep = widget.speedSteps[index.round() - 1];
    if (previousSpeedStep == speedStep) return;
    previousSpeedStep = speedStep;
    widget.onSpeedStepChanged(speedStep);
  }

  double speedInterval() {
    return LocomotiveSpeedo.speedInterval(widget.speedStep).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          startAngle: 50,
          endAngle: 130,
          minimum: 1,
          maximum: 3,
          interval: 1,
          radiusFactor: 0.5,
          showAxisLine: true,
          showTicks: false,
          minorTicksPerInterval: 0,
          centerY: 0.7,
          labelOffset: 20,
          isInversed: true,
          onLabelCreated: onSpeedStepLabel,
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
              value: speedStepIndex(),
              onValueChanged: onSpeedStepChanged,
              enableAnimation: false,
              animationDuration: 300,
              markerType: MarkerType.circle,
              markerWidth: 12,
              markerHeight: 12,
              color: Colors.grey[200],
              offsetUnit: GaugeSizeUnit.factor,
              overlayRadius: 12,
            ),
          ],
          axisLineStyle: AxisLineStyle(
            thickness: 0.06,
            thicknessUnit: GaugeSizeUnit.factor,
            cornerStyle: CornerStyle.bothCurve,
            color: Colors.grey[250],
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
          maximum: widget.speedStep + 0.01,
          interval: speedInterval(),
          labelOffset: 20,
          ranges: [
            GaugeRange(
              startValue: 0,
              endValue: widget.speedStep.toDouble(),
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.07,
              endWidth: 0.07,
              color: Colors.transparent,
            ),
          ],
          pointers: [
            RangePointer(
              value: widget.visualSpeed.toDouble(),
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
                  begin: widget.previousSpeed.toDouble(),
                  end: widget.visualSpeed.toDouble(),
                  duration: Duration(milliseconds: 500),
                  textScaleFactor: 8,
                  style: TextStyle(
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
    );
  }
}
