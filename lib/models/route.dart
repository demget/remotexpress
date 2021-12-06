import 'package:json_annotation/json_annotation.dart';
import 'package:remotexpress/models/accessory.dart';

part 'route.g.dart';

@JsonSerializable()
class Route {
  final String name;
  List<Accessory> turnouts = [];
  bool expanded = false;

  Route(this.name, [List<Accessory>? turnouts])
      : this.turnouts = turnouts ?? [];

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);
  Map<String, dynamic> toJson() => _$RouteToJson(this);
}
