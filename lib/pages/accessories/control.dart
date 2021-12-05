import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/formatters/range.dart';
import 'package:remotexpress/widgets/toggle_button.dart';

class AccessoriesControl extends StatefulWidget {
  List<bool> accessories;
  void Function(int) onToggle;
  void Function(int) onAdd;

  AccessoriesControl({
    required this.accessories,
    required this.onToggle,
    required this.onAdd,
  });

  @override
  _AccessoriesControlState createState() => _AccessoriesControlState();
}

class _AccessoriesControlState extends State<AccessoriesControl> {
  TextEditingController controller = TextEditingController();

  // void toggleAccessory() {
  //   final accessories = widget.accessories;
  //   int i = (int.tryParse(controller.value.text) ?? 1) - 1;
  //   if (i < 0 || i >= accessories.length) return;
  //   setState(() => accessories[i] = !accessories[i]);
  // }

  int address() {
    return (int.tryParse(controller.value.text) ?? 1) - 1;
  }

  bool isValid() {
    int i = address();
    return i > 0 && i < widget.accessories.length;
  }

  bool currentAccessory() {
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
            flex: 3,
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
            flex: 1,
            child: ToggleButton(
              on: currentAccessory(),
              child: Text(currentAccessory() ? 'ON' : 'OFF'),
              onPressed: isValid() ? () => widget.onToggle(address()) : null,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Tooltip(
              message: L10n.of(context)!.addToGroupTooltip,
              child: ToggleButton(
                on: false,
                child: Icon(Icons.add_to_photos),
                onPressed: isValid() ? () => widget.onAdd(address()) : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
