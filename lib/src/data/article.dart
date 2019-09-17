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

  /// The URL to a relevant image for the article.
  String urlToImage;

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

  @JsonKey(ignore: true)
  bool isFavorite = false;

  Article();

  factory Article.fromDB(Map<String, dynamic> map) {
    return Article()
      ..url = map['url'] as String
      ..urlToImage = map['urlToImage'] as String
      ..author = map['author'] as String
      ..title = map['title'] as String
      ..description = map['description'] as String
      ..publishedAt = map['publishedAt'] as String
      ..content = map['content'] as String
      ..isFavorite = true;
  }

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  Map<String, dynamic> toDBMap() => {
        'url': url,
        'urlToImage': urlToImage,
        'author': author,
        'title': title,
        'description': description,
        'publishedAt': publishedAt,
        'content': content,
      };
}
