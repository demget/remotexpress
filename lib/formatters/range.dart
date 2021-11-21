import 'package:flutter/services.dart';

class RangeTextInputFormatter extends TextInputFormatter {
  int min;
  int max;

  RangeTextInputFormatter({required int min, required int max})
      : this.min = min,
        this.max = max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') return newValue;

    final number = int.parse(newValue.text);
    if (number < min) return TextEditingValue().copyWith(text: min.toString());
    if (number > max) return TextEditingValue().copyWith(text: max.toString());

    final text = number.toString();
    final selection = TextSelection.collapsed(offset: text.length);
    return newValue.copyWith(text: text, selection: selection);
  }
}
