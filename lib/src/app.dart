import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader/src/bloc/favorites/favorites_bloc.dart';
import 'package:news_reader/src/bloc/news/news_bloc.dart';
import 'package:news_reader/src/config.dart';
import 'package:news_reader/src/service/news_service.dart';
import 'package:news_reader/src/ui/news_home.dart';

class MyApp extends StatefulWidget {
  final Config config;

  const MyApp({Key key, this.config}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // TODO init DB here
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Reader',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.orange,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
      ),
      home: _Home(widget.config),
    );
  }
}

class _Home extends StatelessWidget {
  final NewsService newsService;

  _Home(Config config) : newsService = NewsService(config);

  @override
  Widget build(BuildContext context) {
    var newsBloc = NewsBloc(newsService);
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(
          builder: (_) => newsBloc,
        ),
        BlocProvider<FavoritesBloc>(
          builder: (_) => FavoritesBloc(newsService, newsBloc),
        )
      ],
      child: NewsHome(),
    );
  }
}
