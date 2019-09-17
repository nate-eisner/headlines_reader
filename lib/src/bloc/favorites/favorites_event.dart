import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:news_reader/src/data/article.dart';

@immutable
abstract class FavoritesEvent extends Equatable {
  FavoritesEvent([List props = const <dynamic>[]]) : super(props);
}

class StarArticle extends FavoritesEvent {
  Article get article => props[0];

  StarArticle(Article article) : super([article]);
}

class UnStarArticle extends FavoritesEvent {
  Article get article => props[0];

  UnStarArticle(Article article) : super([article]);
}

class GetFavorites extends FavoritesEvent {}
