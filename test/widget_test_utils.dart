import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader/src/bloc/favorites/bloc.dart';
import 'package:news_reader/src/bloc/news/news_bloc.dart';
import 'package:news_reader/src/service/api/news_api.dart';
import 'package:news_reader/src/service/news_service.dart';
import 'package:sqflite/sqflite.dart';

class MockNewsBloc extends Mock implements NewsBloc {}

class MockFavoritesBloc extends Mock implements FavoritesBloc {}

class MockNewsService extends Mock implements NewsService {}

class MockNewsApi extends Mock implements NewsApi {}

class MockDatabase extends Mock implements Database {}

class MockImageCacheManager extends Mock implements BaseCacheManager {}
