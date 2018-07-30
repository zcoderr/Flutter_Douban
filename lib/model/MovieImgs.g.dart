// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MovieImgs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieImgs _$MovieImgsFromJson(Map<String, dynamic> json) {
  return new MovieImgs(json['small'] as String, json['large'] as String,
      json['medium'] as String);
}

abstract class _$MovieImgsSerializerMixin {
  String get small;
  String get large;
  String get medium;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'small': small, 'large': large, 'medium': medium};
}
