import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/formatters/range.dart';
import 'package:remotexpress/net/accessory.dart';
import 'package:remotexpress/widgets/toggle_button.dart';

class AccessoriesControl extends StatefulWidget {
  final List<Accessory> accessories;
  final void Function(int) onToggle, onAddToGroup, onAddToRoute;

  AccessoriesControl({
    required this.accessories,
    required this.onToggle,
    required this.onAddToGroup,
    required this.onAddToRoute,
  });

  @override
  _AccessoriesControlState createState() => _AccessoriesControlState();
}

class _AccessoriesControlState extends State<AccessoriesControl> {
  TextEditingController controller = TextEditingController();

  int address() {
    return (int.tryParse(controller.value.text) ?? 1) - 1;
  }

  bool isValid() {
    if (controller.value.text.isEmpty) return false;
    int i = address();
    return i >= 0 && i < widget.accessories.length;
  }

  Accessory currentAccessory() {
    if (!isValid()) return Accessory(0);
    return widget.accessories[address()];
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: TextFormField(
              controller: controller,
              onChanged: (_) => setState(() {}),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[300],
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RangeTextInputFormatter(min: 1, max: 1024),
              ],
              decoration: InputDecoration(
                labelText: L10n.of(context)!.accessoryLabel,
                labelStyle: TextStyle(color: Colors.grey[400]),
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                prefixIcon: Icon(
                  Icons.memory,
                  size: 28,
                  color: Theme.of(context).primaryColor,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: ToggleButton(
              on: currentAccessory().on,
              child: Text(currentAccessory().on ? 'ON' : 'OFF'),
              onPressed: isValid() ? () => widget.onToggle(address()) : null,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Tooltip(
              message: L10n.of(context)!.addToGroupTooltip,
              child: ToggleButton(
                on: false,
                child: Icon(Icons.add_to_photos),
                onPressed:
                    isValid() ? () => widget.onAddToGroup(address()) : null,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Tooltip(
              message: L10n.of(context)!.addToRouteTooltip,
              child: ToggleButton(
                on: false,
                child: Icon(Icons.alt_route),
                onPressed:
                    isValid() ? () => widget.onAddToRoute(address()) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
