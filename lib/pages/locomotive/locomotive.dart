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
  final Station station;

  LocomotivePage(this.station);

  @override
  _LocomotivePageState createState() => _LocomotivePageState(station);
}

class _LocomotivePageState extends State<LocomotivePage> {
  final Station station;
  final List<Loco> locos = List.generate(256, (i) => Loco(i + 1));
  late Loco loco;

  _LocomotivePageState(this.station) {
    loco = locos[0];
  }

  int power = 0;
  int visualSpeed = 0;
  int previousSpeed = 0;

  void forceSpeed(int value) {
    previousSpeed = visualSpeed;
    loco.speed = visualSpeed = value;
  }

  void onPowerChanged(int value) {
    setState(() {
      power = value;
      if (power != StationPower.idle) {
        loco.direction = LocoDirections.neutral;
        forceSpeed(0);
      }
    });

    station.power(power);
  }

  void onLocoChanged(int value) {
    setState(() => loco = locos[value - 1]);
    onVisualSpeedChanged();
  }

  void onSpeedChanged(dynamic value) {
    if (value > loco.speedStep) return;
    setState(() => loco.speed = value.round());

    station.updateLoco(loco);
  }

  void onVisualSpeedChanged() {
    setState(() {
      previousSpeed = visualSpeed;
      visualSpeed = loco.speed;
    });
  }

  void onSpeedStepChanged(int value) {
    setState(() {
      loco.speedStep = value;
      forceSpeed(0);
    });

    station.updateLoco(loco);
  }

  void onDirectionChanged(int value) {
    setState(() {
      if (loco.direction == value) return;
      if (value != LocoDirections.neutral) {
        power = StationPower.idle;
      }

      loco.direction = value;
      forceSpeed(0);
    });

    station.updateLoco(loco);
  }

  void onFunctionToggle(int f) {
    setState(() => loco.toggleFunction(f));
    station.updateLocoFunction(loco, f);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: LocomotiveSpeedo(
            speedSteps: Loco.speedSteps,
            onSpeedStepChanged: onSpeedStepChanged,
            speedStep: loco.speedStep,
            speed: loco.speed,
            visualSpeed: visualSpeed,
            previousSpeed: previousSpeed,
          ),
        ),
        SizedBox(height: 30),
        LocomotivePower(
          power: power,
          onPowerChanged: onPowerChanged,
        ),
        SizedBox(height: 40),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                        loco: loco.address,
                        onChanged: onLocoChanged,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  // Flexible(
                  //   flex: 1,
                  //   child: LocomotiveFunctions(
                  //     columns: 1,
                  //     rows: 1,
                  //     functions: loco.functions,
                  //     onToggle: onFunctionToggle,
                  //     childBuilder: (_) => Icon(Icons.lightbulb),
                  //   ),
                  // ),
                  Flexible(
                    flex: 4,
                    child: LocomotiveFunctions(
                      columns: 3,
                      rows: 5,
                      // offset: 1,
                      functions: loco.functions,
                      onToggle: onFunctionToggle,
                      childBuilder: (f) => Text('F$f'),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 30),
              Row(
                children: [
                  LocomotiveDirectionTrack(
                    direction: loco.direction,
                    onChanged:
                        power != StationPower.off ? onDirectionChanged : null,
                  ),
                  LocomotiveSpeedTrack(
                    speedStep: loco.speedStep,
                    speed: loco.speed,
                    interval: LocomotiveSpeedo.speedInterval(loco.speedStep),
                    onPointerUp: onVisualSpeedChanged,
                    onChanged: loco.direction != LocoDirections.neutral
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
