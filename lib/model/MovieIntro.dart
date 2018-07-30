import 'package:json_annotation/json_annotation.dart';

import 'MovieActor.dart';
import 'MovieImgs.dart';
import 'MovieRate.dart';

part 'MovieIntro.g.dart';

@JsonSerializable()
class MovieIntro extends Object with _$MovieIntroSerializerMixin {
  MovieRate rating;
  List<String> genres;
  String title;
  List<MovieActor> casts;
  int collect_count;
  String original_title;
  String subtype;
  List<MovieActor> directors;
  String year;
  MovieImgs images;
  String alt;
  String id;

  MovieIntro(
      this.rating,
      this.genres,
      this.title,
      this.casts,
      this.collect_count,
      this.original_title,
      this.subtype,
      this.directors,
      this.year,
      this.images,
      this.alt,
      this.id);

  factory MovieIntro.fromJson(Map<String, dynamic> json) =>
      _$MovieIntroFromJson(json);
}
