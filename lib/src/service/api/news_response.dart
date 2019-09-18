import 'package:json_annotation/json_annotation.dart';
import 'package:news_reader/src/data/article.dart';

part 'news_response.g.dart';

@JsonSerializable()
class NewsResponse {
  /// If the request was successful or not. Options: ok, error. In the case of
  /// error a code and message property will be populated.
  String status;

  /// The total number of results available for your request.
  int totalResults;

  /// The results of the request.
  List<Article> articles;

  NewsResponse();

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}
