import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader/src/bloc/news/bloc.dart';
import 'package:news_reader/src/data/article.dart';
import 'package:news_reader/src/ui/news_list.dart';

class HeadlinesTab extends StatefulWidget {
  HeadlinesTab() : super(key: Key('NewsFeed'));

  @override
  _HeadlinesTabState createState() => _HeadlinesTabState();
}

class _HeadlinesTabState extends State<HeadlinesTab>
    with AutomaticKeepAliveClientMixin {
  NewsBloc _newsBloc;
  List<Article> _news = [];

  @override
  void initState() {
    super.initState();

    _newsBloc = BlocProvider.of<NewsBloc>(context)
      ..dispatch(GetHeadlines(true));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener(
      bloc: _newsBloc,
      listener: (context, state) {
        if (state is HasNewsState) {
          setState(() {
            _news = state.news;
          });
        }

        if (state is! NewsLoadingState && state is! NewsErrorState) {
          Scaffold.of(context).hideCurrentSnackBar();
        }

        if (state is NewsErrorState) {
          Scaffold.of(context).showSnackBar(SnackBar(
              key: Key('snackbar-error'),
              content: Text('Failed to refresh headlines')));
        }

        if (state is NewsLoadingState) {
          Scaffold.of(context).showSnackBar(SnackBar(
              key: Key('snackbar-loading'),
              content: Container(
                constraints: BoxConstraints(maxHeight: 36),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Refreshing Headlines'),
                    Container(
                      width: 26,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              )));
        }
      },
      child: Container(
        child: _news != null && _news.isNotEmpty
            ? NewsList(key: Key('headlines list'), news: _news)
            : null,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
