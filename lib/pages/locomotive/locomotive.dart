import 'package:flutter/material.dart';
import 'package:remotexpress/pages/locomotive/functions.dart';
import 'package:remotexpress/pages/locomotive/power.dart';
import 'package:remotexpress/pages/locomotive/direction_track.dart';
import 'package:remotexpress/pages/locomotive/selector.dart';
import 'package:remotexpress/pages/locomotive/speed_track.dart';
import 'package:remotexpress/pages/locomotive/speedo.dart';

import 'package:remotexpress/net/loco.dart';
import 'package:remotexpress/net/station.dart';

class LocomotivePage extends StatefulWidget {
  LocomotivePage({Key? key}) : super(key: key);

  @override
  _LocomotivePageState createState() => _LocomotivePageState();
}

class _LocomotivePageState extends State<LocomotivePage> {
  static const speedSteps = [14, 28, 128];

  int speedStep = 28;
  int visualSpeed = 0;
  int previousSpeed = 0;

  int power = 0;
  int loco = 1;
  int speed = 0;
  int direction = 1;

  void forceSpeed(int value) {
    previousSpeed = visualSpeed;
    speed = visualSpeed = value;
  }

  void onPowerChanged(value) {
    setState(() {
      power = value;
      if (power != StationPower.idle) {
        direction = LocoDirections.neutral;
        forceSpeed(0);
      }
    });
  }

  void onLocoChanged(value) {
    setState(() {
      loco = value;
    });
  }

  void onSpeedChanged(dynamic value) {
    if (value > speedStep) return;

    setState(() {
      speed = value.round();
    });
  }

  void onVisualSpeedChanged() {
    setState(() {
      previousSpeed = visualSpeed;
      visualSpeed = speed;
    });
  }

  void onSpeedStepChanged(int value) {
    setState(() {
      speedStep = value;
      forceSpeed(0);
    });
  }

  void onDirectionChanged(int value) {
    setState(() {
      if (direction == value) return;

      direction = value;
      if (direction != LocoDirections.neutral) {
        power = StationPower.idle;
      }

      forceSpeed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 300,
          child: LocomotiveSpeedo(
            speedSteps: speedSteps,
            onSpeedStepChanged: onSpeedStepChanged,
            speedStep: speedStep,
            speed: speed,
            visualSpeed: visualSpeed,
            previousSpeed: previousSpeed,
          ),
        ),
        SizedBox(height: 25),
        LocomotivePower(
          power: power,
          onPowerChanged: onPowerChanged,
        ),
        SizedBox(height: 25),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: LocomotiveSelector(
                        loco: loco,
                        onChanged: onLocoChanged,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: LocomotiveFunctions(
                      rows: 3,
                      columns: 5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  LocomotiveDirectionTrack(
                    direction: direction,
                    onChanged:
                        power != StationPower.off ? onDirectionChanged : null,
                  ),
                  LocomotiveSpeedTrack(
                    speedStep: speedStep,
                    speed: speed,
                    interval: LocomotiveSpeedo.speedInterval(speedStep),
                    onPointerUp: onVisualSpeedChanged,
                    onChanged: direction != LocoDirections.neutral
                        ? onSpeedChanged
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
