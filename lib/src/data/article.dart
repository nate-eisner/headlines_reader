import 'package:json_annotation/json_annotation.dart';
import 'package:news_reader/src/data/article_source.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  /// The identifier id and a display name for the source this article came
  /// from.
  ArticleSource source;

  /// The direct URL to the article.
  String url;

  /// The author of the article
  String author;

  /// The headline or title of the article.
  String title;

  /// A description or snippet from the article.
  String description;

  /// The date and time that the article was published, in UTC (+000)
  String publishedAt;

  /// This is truncated to 260 chars for Developer plan users.
  String content;

  Article();

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
