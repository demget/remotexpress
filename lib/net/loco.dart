class LocoDirections {
  static const int forward = 1;
  static const int neutral = 0;
  static const int reverse = -1;
}

class LocoFunction {
  final int f;
  bool on;

  LocoFunction(this.f, [this.on = false]);

  void toggle() {
    on = !on;
  }

  int group() {
    return f > 20 ? 0x28 : (f > 16 ? 0x23 : 0x20 + (f - 1) ~/ 4);
  }

  int groupAddress() {
    if (f == 0) return 3;
    return 8 - (f - ((f - 1) ~/ 4 * 4));
  }
}

class Loco {
  static const speedSteps = [14, 28, 128];

  final int address;

  int speed = 0;
  int speedStep = speedSteps[1];
  int direction = LocoDirections.neutral;
  List<LocoFunction> functions = List.generate(28, (i) => LocoFunction(i));

  Loco(this.address);

  void toggleFunction(int f) {
    functions[f].toggle();
  }

  int speedByte() {
    if (speed == 0) return 0;

    bool forward = direction != LocoDirections.reverse;
    int byte = forward ? 0x81 : 0x01;

    if (speed % 2 == 0) {
      byte += 0x10 + speed ~/ 2;
    } else {
      byte += (speed + 1) ~/ 2;
    }

    return byte;
  }

  int speedStepByte() {
    const bytes = {14: 0x10, 28: 0x12, 128: 0x13};
    return bytes[speedStep] ?? 0;
  }

  int functionsByte(int group) {
    int byte = 0;
    final fs = functions.where((f) => f.group() == group && f.on);
    fs.forEach((f) => byte += 0x80 >> f.groupAddress());
    return byte;
  }
}
