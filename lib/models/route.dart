import 'package:remotexpress/net/loco.dart';

class Route {
  String name;
  List<LocoFunction> functions;

  bool expanded = false;

  Route(this.name, this.functions);
}
