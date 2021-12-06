import 'package:flutter/material.dart';
import 'package:remotexpress/net/accessory.dart';
import 'package:remotexpress/widgets/toggle_button.dart';

class AccessoryButtons extends StatefulWidget {
  final List<Accessory> accessories;
  final void Function(int)? onToggle;
  final Widget Function(int) childBuilder;

  AccessoryButtons({
    required this.accessories,
    required this.childBuilder,
    this.onToggle,
  });

  @override
  _AccessoryButtonsState createState() => _AccessoryButtonsState();
}

class _AccessoryButtonsState extends State<AccessoryButtons> {
  @override
  Widget build(BuildContext context) {
    final accessories = List.from(widget.accessories);
    accessories.sort((a, b) => a.a - b.a);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: accessories.map<Widget>((accessory) {
        return Padding(
          padding: EdgeInsets.all(5),
          child: ToggleButton(
            on: accessory.on,
            child: widget.childBuilder(accessory.a),
            onPressed: widget.onToggle != null
                ? () => widget.onToggle!(accessory.a)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
