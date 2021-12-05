class Accessory {
  final int a;
  bool on;

  Accessory(this.a, [this.on = false]);

  void toggle() {
    on = !on;
  }

  int byte() {
    return 0x88 + ((a - 1) % 4 * 2 + (on ? 1 : 0));
  }
}
