import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:news_reader/src/bloc/favorites/favorites_bloc.dart';
import 'package:news_reader/src/bloc/news/bloc.dart';
import 'package:news_reader/src/bloc/news/news_bloc.dart';
import 'package:news_reader/src/config.dart';
import 'package:news_reader/src/data/sql/database.dart';
import 'package:news_reader/src/service/api/news_api.dart';
import 'package:news_reader/src/service/news_service.dart';
import 'package:news_reader/src/ui/news_home.dart';

const syncChannel = const MethodChannel('io.eisner.new_reader');

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
    database();
    syncChannel.invokeMethod('sync', {
      'timeInSeconds': 30,
      'apiKey': widget.config.apiKey,
    });
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

  _Home(Config config)
      : newsService = NewsService(
          newsApi: NewsApi.withConfig(config),
          db: database(),
          imageCacheManager: DefaultCacheManager(),
        );

  @override
  Widget build(BuildContext context) {
    var newsBloc = NewsBloc(newsService);
    syncChannel.setMethodCallHandler((call) async {
      if (call.method == 'syncSuccess') {
        newsBloc.dispatch(GetHeadlines(false));
      }
    });
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
