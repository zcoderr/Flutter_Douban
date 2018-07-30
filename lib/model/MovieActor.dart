import 'package:json_annotation/json_annotation.dart';

import 'MovieImgs.dart';

part 'MovieActor.g.dart';

@JsonSerializable()
class MovieActor extends Object with _$MovieActorSerializerMixin {
  String alt;
  MovieImgs avatars;
  String name;
  String id;

  MovieActor(this.alt, this.avatars, this.name, this.id);

  factory MovieActor.fromJson(Map<String, dynamic> json) =>
      _$MovieActorFromJson(json);
}
