import 'dart:io';

import 'package:remotexpress/net/accessory.dart';
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

  bool _debug = false;
  late Socket _wifi;

  Station.wifi(this._wifi);
  Station.todo() : _debug = true;

  static Future<Station> connect() async {
    // ignore: close_sinks
    final socket = await Socket.connect(defaultIp, defaultPort);
    return Station.wifi(socket);
  }

  void listen(void Function(List<int>) f) {
    if (_debug) return;
    _wifi.listen(f);
  }

  void send(Command command) {
    if (_debug) return;
    _wifi.add(command.bytes());
  }

  void send2(Command command) async {
    if (_debug) return;
    final bytes = command.bytes();
    _wifi.add(bytes);
    await Future.delayed(Duration(milliseconds: 50));
    _wifi.add(bytes);
  }

  void close() async {
    await _wifi.close();
  }

  void stop() {
    send2(XorCommand([0x80, 0x80]));
  }

  void resume() {
    send2(XorCommand([0x21, 0x81, 0xA0]));
  }

  void off() {
    send(XorCommand([0x21, 0x81, 0xA0]));
    send2(XorCommand([0x21, 0x80, 0xA1]));
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

  void configure(int cv, int data) async {
    // XpressNet 3.6
    // if (cv == 1024) cv = 0;

    // send(XorCommand([0x23, 0x1C + (cv ~/ 256), cv, data]));
    // resume();

    // XpressNet 3.0
    if (cv >= 256) cv = 0;

    send(XorCommand([0x22, 0x15, cv]));
    await Future.delayed(Duration(milliseconds: 100));
    send2(XorCommand([0x23, 0x16, cv, data]));
    await Future.delayed(Duration(milliseconds: 100));
    resume();
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

  void updateAccessory(Accessory accessory) {
    send2(XorCommand([
      0x52,
      (accessory.a - 1) ~/ 4,
      accessory.byte(),
    ]));
  }
}
