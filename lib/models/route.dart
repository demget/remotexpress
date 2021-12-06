import 'package:remotexpress/net/accessory.dart';

class Route {
  final String name;
  List<Accessory> turnouts = [];
  bool expanded = false;

  Route(this.name, [List<Accessory>? turnouts])
      : this.turnouts = turnouts ?? [];
}
