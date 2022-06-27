// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Accessory _$AccessoryFromJson(Map<String, dynamic> json) => Accessory(
      json['a'] as int,
      json['on'] as bool? ?? false,
    )..played = json['played'] as bool;

Map<String, dynamic> _$AccessoryToJson(Accessory instance) => <String, dynamic>{
      'a': instance.a,
      'on': instance.on,
      'played': instance.played,
    };
