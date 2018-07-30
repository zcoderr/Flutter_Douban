// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MovieRate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieRate _$MovieRateFromJson(Map<String, dynamic> json) {
  return new MovieRate(
      (json['max'] as num)?.toDouble(),
      (json['average'] as num)?.toDouble(),
      json['stars'] as String,
      (json['min'] as num)?.toDouble());
}

abstract class _$MovieRateSerializerMixin {
  double get max;
  double get average;
  String get stars;
  double get min;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'max': max,
        'average': average,
        'stars': stars,
        'min': min
      };
}
