import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NewsEvent extends Equatable {
  NewsEvent([List props = const <dynamic>[]]) : super(props);
}

class GetHeadlines extends NewsEvent {
  bool get hardRefresh => props[0];

  GetHeadlines(bool hardRefresh) : super([hardRefresh]);
}

class SearchNews extends NewsEvent {
  String get query => props[0];

  SearchNews(String query) : super([0]);
}
