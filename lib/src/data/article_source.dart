import 'package:json_annotation/json_annotation.dart';

part 'article_source.g.dart';

@JsonSerializable()
class ArticleSource {
  String id;
  String name;

  ArticleSource();

  factory ArticleSource.fromJson(Map<String, dynamic> json) =>
      _$ArticleSourceFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleSourceToJson(this);
}
