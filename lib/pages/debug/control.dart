import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/formatters/range.dart';
import 'package:remotexpress/models/cv.dart';
import 'package:remotexpress/widgets/toggle_button.dart';

class DebugControl extends StatefulWidget {
  final List<Cv> cvs;
  final void Function(Cv) onConfigure;

  DebugControl({
    required this.cvs,
    required this.onConfigure,
  });

  @override
  _DebugControlState createState() => _DebugControlState();
}

class _DebugControlState extends State<DebugControl> {
  TextEditingController acontroller = TextEditingController();
  TextEditingController bcontroller = TextEditingController();

  int address() {
    return (int.tryParse(acontroller.value.text) ?? 1);
  }

  int value() {
    return (int.tryParse(bcontroller.value.text) ?? 0);
  }

  bool isValid() {
    bool emp = acontroller.value.text.isEmpty || bcontroller.value.text.isEmpty;
    if (emp) return false;

    int i = address();
    return i >= 0 && i < widget.cvs.length;
  }

  Cv current() {
    if (!isValid()) return Cv(0);
    return Cv(address(), value());
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
              controller: acontroller,
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
                labelText: L10n.of(context)!.cvLabel,
                labelStyle: TextStyle(color: Colors.grey[400]),
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                prefixIcon: Icon(
                  Icons.numbers,
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
            flex: 5,
            child: TextFormField(
              controller: bcontroller,
              onChanged: (_) => setState(() {}),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[300],
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RangeTextInputFormatter(min: 0, max: 1024),
              ],
              decoration: InputDecoration(
                labelText: L10n.of(context)!.cvDataLabel,
                labelStyle: TextStyle(color: Colors.grey[400]),
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                prefixIcon: Icon(
                  Icons.amp_stories,
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
              on: false,
              child: Icon(Icons.settings),
              onPressed: isValid() ? () => widget.onConfigure(current()) : null,
            ),
          ),
        ],
      ),
    );
  }
}
