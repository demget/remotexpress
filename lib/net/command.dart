abstract class Command {
  List<int> bytes();
}

class XorCommand implements Command {
  List<int> _bytes;

  XorCommand(this._bytes);

  List<int> bytes() {
    int xor = 0;
    _bytes.forEach((byte) => xor ^= byte);
    _bytes.add(xor);
    return _bytes;
  }
}
