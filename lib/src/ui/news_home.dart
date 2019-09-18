import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader/src/bloc/news/news_bloc.dart';
import 'package:news_reader/src/bloc/news/news_event.dart';
import 'package:news_reader/src/ui/favorites_tab.dart';
import 'package:news_reader/src/ui/headlines_tab.dart';
import 'package:news_reader/src/ui/preferences.dart';

class NewsHome extends StatefulWidget {
  @override
  _NewsHomeState createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome>
    with SingleTickerProviderStateMixin {
  PageController _controller;
  int _currentIndex = 0;

  List<BottomNavigationBarItem> _tabs = [
    BottomNavigationBarItem(
        icon: Icon(Icons.rss_feed), title: Text('Headlines')),
    BottomNavigationBarItem(icon: Icon(Icons.star), title: Text('Favorites')),
  ];
  List<Widget> _pages = [HeadlinesTab(), FavoritesTab()];
  List<String> _titles = ['Headlines', 'Favorites'];

  @override
  void initState() {
    super.initState();
    _controller = PageController(keepPage: true, initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: <Widget>[
          if (_currentIndex == 0)
            Tooltip(
              message: 'Refresh Headlines',
              child: IconButton(
                key: Key('refresh'),
                icon: Icon(Icons.sync),
                onPressed: () {
                  BlocProvider.of<NewsBloc>(context)
                      .dispatch(GetHeadlines(true));
                },
              ),
            ),
          if (Theme.of(context).platform == TargetPlatform.android)
            Tooltip(
              message: 'Preferences',
              child: IconButton(
                key: Key('preferences'),
                icon: Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => SimpleDialog(
                            children: <Widget>[Preferences()],
                          ));
                },
              ),
            ),
        ],
      ),
      body: PageView(
        children: _pages,
        controller: _controller,
        onPageChanged: (page) {
          setState(() {
            _currentIndex = page;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Theme.of(context).accentColor,
        unselectedItemColor: Theme.of(context).accentColor.withAlpha(150),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: (index) {
          _controller.animateToPage(index,
              curve: Curves.linear,
              duration: Duration(
                milliseconds: 250,
              ));
        },
        items: _tabs,
        type: BottomNavigationBarType.shifting,
      ),
    );
  }
}
