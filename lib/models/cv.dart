import 'package:json_annotation/json_annotation.dart';

part 'cv.g.dart';

@JsonSerializable()
class Cv {
  int a;
  int b;

  Cv(this.a, [this.b = 0]);

  factory Cv.fromJson(Map<String, dynamic> json) => _$CvFromJson(json);
  Map<String, dynamic> toJson() => _$CvToJson(this);
}
