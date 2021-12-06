// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      json['name'] as String,
      (json['turnouts'] as List<dynamic>?)
          ?.map((e) => Accessory.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..expanded = json['expanded'] as bool;

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'name': instance.name,
      'turnouts': instance.turnouts,
      'expanded': instance.expanded,
    };
