import 'package:flutter/material.dart';
import 'package:remotexpress/net/accessory.dart';

class Group {
  String name;
  IconData icon;
  List<Accessory> accessories = [];

  Group(
    this.name,
    this.icon, [
    List<Accessory>? accessories,
  ]) : this.accessories = accessories ?? [];
}
