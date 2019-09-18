import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader/src/bloc/favorites/bloc.dart';
import 'package:news_reader/src/data/article.dart';
import 'package:news_reader/src/ui/news_article_view.dart';

class NewsList extends StatefulWidget {
  final List<Article> news;
  final bool isFavorites;

  const NewsList({
    Key key,
    this.news,
    this.isFavorites = false,
  }) : super(key: key);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
            key: Key('News List'),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _NewsItem(
                article: widget.news[index],
                heroTag: widget.isFavorites ? 'fav' : '',
              ),
              childCount: widget.news.length,
            )),
      ],
    );
  }
}

class _NewsItem extends StatefulWidget {
  final Article article;
  final String heroTag;

  const _NewsItem({Key key, this.article, this.heroTag}) : super(key: key);

  @override
  __NewsItemState createState() => __NewsItemState();
}

class __NewsItemState extends State<_NewsItem> with TickerProviderStateMixin {
  Article get article => widget.article;

  TextStyle get subTextStyle => Theme.of(context).textTheme.caption;
  bool expanded = false;

  String get heroTag => widget.heroTag + article.title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: article.urlToImage != null
              ? Hero(
                  tag: heroTag + 'image',
                  child: CachedNetworkImage(
                      imageUrl: article.urlToImage,
                      fit: BoxFit.contain,
                      width: 90,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error)))
              : Container(
                  height: 0,
                  width: 0,
                ),
          title: Hero(
            child:
                Text(article.title, style: Theme.of(context).textTheme.body1),
            tag: heroTag,
          ),
          trailing: (Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  article.isFavorite ? Icons.star : Icons.star_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  article.isFavorite = !article.isFavorite;
                  setState(() {});
                  var event;
                  if (article.isFavorite) {
                    event = StarArticle(article);
                  } else {
                    event = UnStarArticle(article);
                  }
                  BlocProvider.of<FavoritesBloc>(context).dispatch(event);
                },
              ),
              if (expanded)
                IconButton(
                  icon: Icon(
                    Icons.expand_less,
                  ),
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                ),
            ],
          )),
          onLongPress: () {
            setState(() {
              expanded = !expanded;
            });
          },
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => NewsArticle(
                article: article,
                heroTag: heroTag,
              ),
              fullscreenDialog: true,
            ));
          },
        ),
        _expanded(),
      ],
    );
  }

  _expanded() {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      vsync: this,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            expanded
                ? ListTile(
                    subtitle: Text(
                      article.description,
                      style: subTextStyle,
                    ),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
