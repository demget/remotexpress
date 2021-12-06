// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      json['name'] as String,
      json['iconCodePoint'] as int,
      (json['accessories'] as List<dynamic>?)
          ?.map((e) => Accessory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'name': instance.name,
      'iconCodePoint': instance.iconCodePoint,
      'accessories': instance.accessories,
    };
