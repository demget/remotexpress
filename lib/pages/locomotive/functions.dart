import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icon_picker/icon_picker.dart';
import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/net/loco.dart';
import 'package:remotexpress/widgets/custom_dialog.dart';
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
  static const iconCollection = {
    'lightbulb': Icons.lightbulb,
    'volume_up': Icons.volume_up,
    'air': Icons.air,
    'traffic_rounded': Icons.traffic_rounded,
  };

  Map<int, String> icons = {};

  void onLongPress(int f) {
    CustomDialog.show(
      context,
      title: L10n.of(context)!.dialogFunctionTitle,
      icon: Icons.info,
      child: _iconPicker(f),
      negativeText: L10n.of(context)!.dialogFunctionNegative,
      onNegativePressed: () {
        setState(() => icons.remove(f));
        CustomDialog.pop(context);
      },
    );
  }

  Widget _iconPicker(int f) {
    return IconPicker(
      initialValue: icons[f],
      title: L10n.of(context)!.dialogFunctionTitle,
      cancelBtn: L10n.of(context)!.dialogPositive,
      decoration: InputDecoration(
        icon: Icon(Icons.apps),
        labelStyle: TextStyle(color: Colors.grey[400]),
        labelText: L10n.of(context)!.dialogFunctionLabel,
        floatingLabelStyle: TextStyle(
          color: Theme.of(context).primaryColorDark,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
        ),
      ),
      style: TextStyle(color: Colors.grey[400], fontSize: 15),
      enableSearch: false,
      iconCollection: iconCollection,
      onChanged: (v) {
        setState(() {
          icons[f] = jsonDecode(v)['iconName'];
        });
      },
    );
  }

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
                final f = i + j * widget.columns + widget.offset;
                final iconKey = icons[f];

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: ToggleButton(
                      on: widget.functions[f].on,
                      child: iconKey != null
                          ? Icon(iconCollection[iconKey])
                          : widget.childBuilder(f),
                      onPressed: widget.onToggle != null
                          ? () => widget.onToggle!(f)
                          : null,
                      onLongPress: () => onLongPress(f),
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
