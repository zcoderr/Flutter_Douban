import 'package:json_annotation/json_annotation.dart';

part 'MovieImgs.g.dart';

@JsonSerializable()
class MovieImgs extends Object with _$MovieImgsSerializerMixin {
  String small;
  String large;
  String medium;

  MovieImgs(this.small, this.large, this.medium);

  factory MovieImgs.fromJson(Map<String, dynamic> json) =>
      _$MovieImgsFromJson(json);
}
