import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remotexpress/models/accessory.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  String name;
  int iconCodePoint;
  List<Accessory> accessories = [];

  Group(
    this.name,
    this.iconCodePoint, [
    List<Accessory>? accessories,
  ]) : this.accessories = accessories ?? [];

  IconData icon() {
    return IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  }

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
