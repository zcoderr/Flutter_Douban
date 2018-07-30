// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MovieIntro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieIntro _$MovieIntroFromJson(Map<String, dynamic> json) {
  return new MovieIntro(
      json['rating'] == null
          ? null
          : new MovieRate.fromJson(json['rating'] as Map<String, dynamic>),
      (json['genres'] as List)?.map((e) => e as String)?.toList(),
      json['title'] as String,
      (json['casts'] as List)
          ?.map((e) => e == null
              ? null
              : new MovieActor.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['collect_count'] as int,
      json['original_title'] as String,
      json['subtype'] as String,
      (json['directors'] as List)
          ?.map((e) => e == null
              ? null
              : new MovieActor.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['year'] as String,
      json['images'] == null
          ? null
          : new MovieImgs.fromJson(json['images'] as Map<String, dynamic>),
      json['alt'] as String,
      json['id'] as String);
}

abstract class _$MovieIntroSerializerMixin {
  MovieRate get rating;
  List<String> get genres;
  String get title;
  List<MovieActor> get casts;
  int get collect_count;
  String get original_title;
  String get subtype;
  List<MovieActor> get directors;
  String get year;
  MovieImgs get images;
  String get alt;
  String get id;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'rating': rating,
        'genres': genres,
        'title': title,
        'casts': casts,
        'collect_count': collect_count,
        'original_title': original_title,
        'subtype': subtype,
        'directors': directors,
        'year': year,
        'images': images,
        'alt': alt,
        'id': id
      };
}
