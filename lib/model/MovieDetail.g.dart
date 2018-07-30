// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MovieDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetail _$MovieDetailFromJson(Map<String, dynamic> json) {
  return new MovieDetail(
      json['rating'] == null
          ? null
          : new MovieRate.fromJson(json['rating'] as Map<String, dynamic>),
      json['reviews_count'] as int,
      json['wish_count'] as int,
      json['year'] as String,
      json['images'] == null
          ? null
          : new MovieImgs.fromJson(json['images'] as Map<String, dynamic>),
      json['alt'] as String,
      json['id'] as String,
      json['mobile_url'] as String,
      json['title'] as String,
      json['share_url'] as String,
      (json['genres'] as List)?.map((e) => e as String)?.toList(),
      json['collect_count'] as int,
      (json['casts'] as List)
          ?.map((e) => e == null
              ? null
              : new MovieActor.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['original_title'] as String,
      json['summary'] as String,
      (json['directors'] as List)
          ?.map((e) => e == null
              ? null
              : new MovieActor.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['comments_count'] as int,
      json['ratings_count'] as int);
}

abstract class _$MovieDetailSerializerMixin {
  MovieRate get rating;
  int get reviews_count;
  int get wish_count;
  String get year;
  MovieImgs get images;
  String get alt;
  String get id;
  String get mobile_url;
  String get title;
  String get share_url;
  List<String> get genres;
  int get collect_count;
  List<MovieActor> get casts;
  String get original_title;
  String get summary;
  List<MovieActor> get directors;
  int get comments_count;
  int get ratings_count;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'rating': rating,
        'reviews_count': reviews_count,
        'wish_count': wish_count,
        'year': year,
        'images': images,
        'alt': alt,
        'id': id,
        'mobile_url': mobile_url,
        'title': title,
        'share_url': share_url,
        'genres': genres,
        'collect_count': collect_count,
        'casts': casts,
        'original_title': original_title,
        'summary': summary,
        'directors': directors,
        'comments_count': comments_count,
        'ratings_count': ratings_count
      };
}
