import 'package:flutter/material.dart';
import 'package:news_reader/src/app.dart';
import 'package:news_reader/src/config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(config: Config()));
}
