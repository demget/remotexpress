import 'package:flutter/material.dart';
import 'package:remotexpress/net/loco.dart';
import 'package:remotexpress/widgets/toggle_button.dart';

class LocomotiveFunctions extends StatefulWidget {
  final int columns, rows, offset;
  final List<LocoFunction> functions;
  final void Function(int)? onToggle;
  final Widget Function(int) childBuilder;

  LocomotiveFunctions({
    required this.columns,
    required this.rows,
    this.offset = 0,
    required this.functions,
    required this.childBuilder,
    this.onToggle,
  });

  @override
  _LocomotiveFunctionsState createState() => _LocomotiveFunctionsState();
}

class _LocomotiveFunctionsState extends State<LocomotiveFunctions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.columns,
        (i) => Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.rows,
              (j) {
                int f = i + j * widget.columns + widget.offset;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: ToggleButton(
                      on: widget.functions[f].on,
                      onPressed: widget.onToggle != null
                          ? () => widget.onToggle!(f)
                          : null,
                      child: widget.childBuilder(f),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
