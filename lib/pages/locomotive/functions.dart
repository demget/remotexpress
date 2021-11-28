import 'package:flutter/material.dart';

class LocomotiveFunctions extends StatefulWidget {
  final int rows, columns;

  LocomotiveFunctions({
    required this.rows,
    required this.columns,
  });

  @override
  _LocomotiveFunctionsState createState() => _LocomotiveFunctionsState();
}

class _LocomotiveFunctionsState extends State<LocomotiveFunctions> {
  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      primary: Colors.grey[400],
      backgroundColor: Theme.of(context).primaryColorDark,
      side: BorderSide.none,
      shape: StadiumBorder(),
      elevation: 3,
    );

    return Container(
      child: Row(
        children: [
          ...List.generate(
            widget.rows,
            (i) => Padding(
              padding: EdgeInsets.only(
                left: 5,
                right: 5,
                // top: reversed ? 25 : i * 50,
                // bottom: reversed ? i * 50 : 25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.columns,
                  (j) {
                    // int n = (reversed ? 1 - i : i) + j * rows + offset;
                    int n = i + j * widget.rows;
                    return Container(
                      child: Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: style,
                          child: n == 0
                              ? Icon(Icons.lightbulb, size: 18)
                              : Text('F$n'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
