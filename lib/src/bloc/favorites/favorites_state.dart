import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:news_reader/src/data/article.dart';

@immutable
abstract class FavoritesState extends Equatable {
  FavoritesState([List props = const <dynamic>[]]) : super(props);
}

class InitialArticleState extends FavoritesState {}

class LoadingArticlesState extends FavoritesState {}

class HasFavoritesState extends FavoritesState {
  List<Article> get news => props[0];

  HasFavoritesState(List<Article> articles) : super([articles]);
}
