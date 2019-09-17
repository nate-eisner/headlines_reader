import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader/src/bloc/favorites/bloc.dart';
import 'package:news_reader/src/ui/news_list.dart';

class FavoritesTab extends StatefulWidget {
  FavoritesTab() : super(key: Key('FavoritesTab'));

  @override
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab>
    with AutomaticKeepAliveClientMixin {
  FavoritesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FavoritesBloc>(context)..dispatch(GetFavorites());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        if (state is HasFavoritesState) {
          return NewsList(
            key: Key('favorites list'),
            news: state.news,
            isFavorites: true,
          );
        }

        if (state is LoadingArticlesState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          height: 0,
          width: 0,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
