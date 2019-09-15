import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader/src/bloc/news/bloc.dart';
import 'package:news_reader/src/data/article.dart';

class NewsFeedPage extends StatefulWidget {
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  NewsBloc _newsBloc;

  @override
  void initState() {
    super.initState();

    _newsBloc = BlocProvider.of<NewsBloc>(context)..dispatch(GetHeadlines());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder(
        bloc: _newsBloc,
        builder: (context, state) {
          if (state is HasNewsState) {
            var news = state.news;
            if (news.isNotEmpty) return Center(child: (Text('No News found')));
            return _newsList(news);
          }

          if (state is NewsLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            height: 0,
            width: 0,
          );
        },
      ),
    );
  }

  Widget _newsList(List<Article> news) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        //TODO make exapandable news item
        var article = news[index];
        return ListTile(
          leading: Icon(Icons.art_track),
          title: Text(article.title),
        );
      },
    );
  }
}
