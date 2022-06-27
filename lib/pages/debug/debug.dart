import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:remotexpress/net/station.dart';
import 'package:remotexpress/pages/debug/control.dart';
import 'package:remotexpress/pages/debug/output.dart';
import 'package:remotexpress/models/cv.dart';

class DebugPage extends StatefulWidget {
  final Station station;

  DebugPage(this.station);

  late _DebugPageState _state;

  @override
  _DebugPageState createState() {
    _state = _DebugPageState(station);
    return _state;
  }
}

class _DebugPageState extends State<DebugPage> {
  static final defaultCvs = List.generate(
    1024,
    (i) => Cv(i + 1),
  );

  late Station station;
  final List<List<int>> output = [];
  final List<Cv> cvs = defaultCvs;

  late SharedPreferences prefs;

  _DebugPageState(Station? station) {
    if (station != null) {
      station.listen((List<int> command) {
        setState(() => output.add(command));
      });
      this.station = station;
    }
  }

  void onConfigure(Cv cv) {
    station.configure(cv.a, cv.b);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DebugControl(
              cvs: cvs,
              onConfigure: onConfigure,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            flex: 3,
            child: DebugOutput(output: output),
          ),
        ],
      ),
    );
  }
}
