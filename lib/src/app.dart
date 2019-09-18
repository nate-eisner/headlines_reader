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
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/preferences/bloc.dart';

const syncChannel = const MethodChannel('io.eisner.new_reader');

class MyApp extends StatefulWidget {
  final Config config;
  final NewsService newsService;

  MyApp({Key key, this.config})
      : newsService = NewsService(
          newsApi: NewsApi.withConfig(config),
          db: database(),
          imageCacheManager: DefaultCacheManager(),
        ),
        super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NewsBloc _newsBloc;
  PreferencesBloc _preferencesBloc;

  _startSync() {
    syncChannel.invokeMethod('sync', {
      'timeInSeconds': widget.config.syncDelaySeconds,
      'apiKey': widget.config.apiKey,
    });
  }

  _stopSync() {
    syncChannel.invokeMethod('stop');
  }

  @override
  void initState() {
    super.initState();
    database();
    _newsBloc = NewsBloc(widget.newsService);
    _preferencesBloc = PreferencesBloc(SharedPreferences.getInstance());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(
          builder: (_) => _newsBloc,
        ),
        BlocProvider<FavoritesBloc>(
          builder: (_) => FavoritesBloc(widget.newsService, _newsBloc),
        ),
        BlocProvider<PreferencesBloc>(
          builder: (_) => _preferencesBloc,
        ),
      ],
      child: MaterialApp(
        title: 'News Reader',
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.orange,
        ),
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
        ),
        home: BlocListener(
            bloc: _preferencesBloc,
            listener: (context, state) {
              if (state is SyncSettingChangedState) {
                print('SYNC CHANGED TO ${state.isOn}');
                if (state.isOn) {
                  _startSync();
                } else {
                  _stopSync();
                }
              }
            },
            child: NewsHome()),
      ),
    );
  }
}
