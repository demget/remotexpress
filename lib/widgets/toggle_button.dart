import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final bool on;
  final Widget child;
  final void Function()? onPressed;
  final void Function()? onLongPress;

  ToggleButton({
    required this.on,
    required this.child,
    this.onPressed,
    this.onLongPress,
  });

  @override
  _ToggleButtonState createState() => _ToggleButtonState();

  bool isDisabled() => onPressed == null;
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: widget.child,
      onPressed: widget.onPressed,
      onLongPress: widget.onLongPress,
      style: OutlinedButton.styleFrom(
        primary: widget.on ? Theme.of(context).primaryColor : Colors.grey[400],
        backgroundColor: Theme.of(context).primaryColorDark,
        onSurface: widget.on ? Theme.of(context).primaryColor : null,
        side: BorderSide.none,
        shape: StadiumBorder(),
        elevation: widget.on && !widget.isDisabled() ? 0.5 : 3,
      ),
    );
  }
}
