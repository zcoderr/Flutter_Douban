import 'package:json_annotation/json_annotation.dart';

import 'MovieIntro.dart';

part 'MovieIntroList.g.dart';

@JsonSerializable()
class MovieIntroList extends Object with _$MovieIntroListSerializerMixin {
  List<MovieIntro> subjects;

  MovieIntroList(this.subjects);

  factory MovieIntroList.fromJson(Map<String, dynamic> json) =>
      _$MovieIntroListFromJson(json);
}
