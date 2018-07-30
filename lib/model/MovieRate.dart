import 'package:json_annotation/json_annotation.dart';

part 'MovieRate.g.dart';

@JsonSerializable()
class MovieRate extends Object with _$MovieRateSerializerMixin {
  double max;
  double average;
  String stars;
  double min;

  MovieRate(this.max, this.average, this.stars, this.min);

  factory MovieRate.fromJson(Map<String, dynamic> json) =>
      _$MovieRateFromJson(json);
}
