import 'package:flutter/material.dart';

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final double width;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;

  AnimatedToggle({
    required this.values,
    required this.onToggleCallback,
    this.width = 250,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
  });
  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final int length = widget.values.length - 1;
    final double width = widget.width;

    return Container(
      width: width * 0.7 * length,
      height: width * 0.13,
      child: Stack(
        children: <Widget>[
          Container(
            width: width * 0.7 * length,
            height: width * 0.13,
            decoration: ShapeDecoration(
              color: widget.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                widget.values.length,
                (i) => GestureDetector(
                  onTap: () {
                    // index = index == length ? 0 : index + 1;
                    index = i;
                    widget.onToggleCallback(i);
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: Text(
                      widget.values[i],
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF918f95),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment: [
              Alignment.centerLeft,
              Alignment.center,
              Alignment.centerRight
            ][index],
            child: Container(
              width: width * 0.35,
              height: width * 0.13,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.1),
                ),
              ),
              child: Text(
                widget.values[index],
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: width * 0.045,
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
