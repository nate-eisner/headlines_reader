import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_reader/src/data/article.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsArticle extends StatefulWidget {
  final Article article;
  final String heroTag;

  NewsArticle({this.article, this.heroTag});

  @override
  _NewsArticleState createState() => _NewsArticleState();
}

class _NewsArticleState extends State<NewsArticle>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Wrap(
              children: <Widget>[
                widget.article.urlToImage != null
                    ? Hero(
                        tag: widget.heroTag + 'image',
                        child: CachedNetworkImage(
                            imageUrl: widget.article.urlToImage,
                            imageBuilder: (context, imageProvider) => Container(
                                  constraints: BoxConstraints(maxHeight: 225),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error))))
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    child: Text(
                      widget.article.title,
                      style: Theme.of(context).textTheme.headline,
                    ),
                    tag: widget.article.title,
                  ),
                ),
                if (widget.article.content != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.article.content,
                      textAlign: TextAlign.justify,
                      softWrap: true,
                    ),
                  ),
                Center(
                  child: IconButton(
                      icon: Icon(Icons.launch),
                      onPressed: () => launch(widget.article.url)),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                color: Theme.of(context).accentColor,
              ),
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
