import 'package:flutter/material.dart';
import 'package:remotexpress/net/loco.dart';

class LocomotiveFunctions extends StatefulWidget {
  final int rows, columns;
  final List<LocoFunction> functions;
  final void Function(int) onToggle;

  LocomotiveFunctions({
    required this.rows,
    required this.columns,
    required this.functions,
    required this.onToggle,
  });

  @override
  _LocomotiveFunctionsState createState() => _LocomotiveFunctionsState();
}

class _LocomotiveFunctionsState extends State<LocomotiveFunctions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          widget.rows,
          (i) => Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.columns,
                (j) {
                  int f = i + j * widget.rows;
                  final style = OutlinedButton.styleFrom(
                    primary: widget.functions[f].on
                        ? Theme.of(context).primaryColor
                        : Colors.grey[400],
                    backgroundColor: Theme.of(context).primaryColorDark,
                    side: BorderSide.none,
                    shape: StadiumBorder(),
                    elevation: widget.functions[f].on ? 0.5 : 3,
                  );
                  return Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: OutlinedButton(
                        onPressed: () => widget.onToggle(f),
                        style: style,
                        child: f == 0
                            ? Icon(Icons.lightbulb, size: 18)
                            : Text('F$f'),
                      ),
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
}
