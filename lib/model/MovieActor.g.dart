// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MovieActor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieActor _$MovieActorFromJson(Map<String, dynamic> json) {
  return new MovieActor(
      json['alt'] as String,
      json['avatars'] == null
          ? null
          : new MovieImgs.fromJson(json['avatars'] as Map<String, dynamic>),
      json['name'] as String,
      json['id'] as String);
}

abstract class _$MovieActorSerializerMixin {
  String get alt;
  MovieImgs get avatars;
  String get name;
  String get id;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'alt': alt, 'avatars': avatars, 'name': name, 'id': id};
}
