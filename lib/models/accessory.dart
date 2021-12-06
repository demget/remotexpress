import 'package:json_annotation/json_annotation.dart';
import 'package:remotexpress/net/accessory.dart' as net;

part 'accessory.g.dart';

@JsonSerializable()
class Accessory extends net.Accessory {
  Accessory(int a, [bool on = false]) : super(a, on);

  factory Accessory.fromJson(Map<String, dynamic> json) =>
      _$AccessoryFromJson(json);
  Map<String, dynamic> toJson() => _$AccessoryToJson(this);
}
