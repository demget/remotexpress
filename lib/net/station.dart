import 'dart:io';

import 'package:remotexpress/net/command.dart';
import 'package:remotexpress/net/loco.dart';

class StationPower {
  static const idle = 0;
  static const stop = 1;
  static const off = 2;
}

class Station {
  static const defaultIp = '192.168.4.1';
  static const defaultPort = 333;

  late Socket _socket;

  Station.todo();
  Station(this._socket);

  static Future<Station> connect() async {
    // ignore: close_sinks
    final socket = await Socket.connect(defaultIp, defaultPort);
    return Station(socket);
  }

  void send(Command command) {
    _socket.add(command.bytes());
  }

  void send2(Command command) {
    final bytes = command.bytes();
    _socket.add(bytes);
    _socket.add(bytes);
  }

  void close() async {
    await _socket.close();
  }

  void stop() {
    send2(XorCommand([0x80, 0x80]));
  }

  void resume() {
    send2(XorCommand([0x21, 0x81, 0xA0]));
  }

  void off() {
    send(XorCommand([0x21, 0x81, 0xA0]));
    send(XorCommand([0x21, 0x80, 0xA1]));
  }

  void power(int power) {
    switch (power) {
      case StationPower.idle:
        resume();
        break;
      case StationPower.stop:
        stop();
        break;
      case StationPower.off:
        off();
        break;
    }
  }

  void updateLoco(Loco loco, [bool functions = false]) {
    send(XorCommand([
      0xE4,
      loco.speedStepByte(),
      0, // always zero
      loco.address,
      loco.speedByte(),
    ]));
  }

  void updateLocoFunction(Loco loco, int f) {
    int group = loco.functions[f].group();
    send(XorCommand([
      0xE4,
      group,
      0, // always zero
      loco.address,
      loco.functionsByte(group),
    ]));
  }
}
