import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String favoritesTable = 'favorite';
const String articlesTable = 'article';

Future<Database> database() async => openDatabase(
      join(await getDatabasesPath(), 'news_database.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $favoritesTable(title TEXT PRIMARY KEY NOT NULL, "
          "url TEXT, "
          "urlToImage TEXT, "
          "author TEXT, "
          "description TEXT, "
          "publishedAt TEXT, "
          "content TEXT"
          ")",
        );
        db.execute(
          "CREATE TABLE $articlesTable(title TEXT PRIMARY KEY NOT NULL, "
          "url TEXT, "
          "urlToImage TEXT, "
          "author TEXT, "
          "description TEXT, "
          "publishedAt TEXT, "
          "content TEXT"
          ")",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        //TODO handle DB upgrade
      },
    );
