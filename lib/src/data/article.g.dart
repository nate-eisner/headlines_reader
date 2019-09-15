// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article()
    ..source = json['source'] == null
        ? null
        : ArticleSource.fromJson(json['source'] as Map<String, dynamic>)
    ..url = json['url'] as String
    ..author = json['author'] as String
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..publishedAt = json['publishedAt'] as String
    ..content = json['content'] as String;
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'source': instance.source,
      'url': instance.url,
      'author': instance.author,
      'title': instance.title,
      'description': instance.description,
      'publishedAt': instance.publishedAt,
      'content': instance.content,
    };
