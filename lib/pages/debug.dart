import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remotexpress/formatters/range.dart';

class DebugPage extends StatefulWidget {
  DebugPage({Key? key}) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: "CV"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    RangeTextInputFormatter(min: 0, max: 1024),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: "Value"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    RangeTextInputFormatter(min: 0, max: 1024),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("PROGRAM!"),
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
