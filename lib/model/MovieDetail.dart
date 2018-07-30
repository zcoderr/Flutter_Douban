import 'package:json_annotation/json_annotation.dart';

import 'MovieActor.dart';
import 'MovieImgs.dart';
import 'MovieRate.dart';

part 'MovieDetail.g.dart';

@JsonSerializable()
class MovieDetail extends Object with _$MovieDetailSerializerMixin {
  MovieRate rating;
  int reviews_count;
  int wish_count;
  String year;
  MovieImgs images;
  String alt;
  String id;
  String mobile_url;
  String title;
  String share_url;
  List<String> genres;
  int collect_count;
  List<MovieActor> casts;
  String original_title;
  String summary;
  List<MovieActor> directors;
  int comments_count;
  int ratings_count;

  MovieDetail(
      this.rating,
      this.reviews_count,
      this.wish_count,
      this.year,
      this.images,
      this.alt,
      this.id,
      this.mobile_url,
      this.title,
      this.share_url,
      this.genres,
      this.collect_count,
      this.casts,
      this.original_title,
      this.summary,
      this.directors,
      this.comments_count,
      this.ratings_count);

  factory MovieDetail.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailFromJson(json);
}
