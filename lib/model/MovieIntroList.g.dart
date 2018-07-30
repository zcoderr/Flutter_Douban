// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MovieIntroList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieIntroList _$MovieIntroListFromJson(Map<String, dynamic> json) {
  return new MovieIntroList((json['subjects'] as List)
      ?.map((e) =>
          e == null ? null : new MovieIntro.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

abstract class _$MovieIntroListSerializerMixin {
  List<MovieIntro> get subjects;
  Map<String, dynamic> toJson() => <String, dynamic>{'subjects': subjects};
}
