![news_reader](images/news.png)

# Headlines Reader
A simple news reader that allows you to cache and favorite news
headlines from [News API](https://newsapi.org/)

*Android support for background syncing to a shared sqlite database via
Room and WorkManager*

### Running the App

* [Install & Setup Flutter](https://flutter.dev/docs/get-started/install)

* Get an API key from [News API](https://newsapi.org/) and include it
  in the [Config](lib/src/config.dart)

* To run this on a connected device, Android emulator, or iOS simulator
you can use the Flutter CLI `flutter run` or the run option from your
Flutter supported IDE of choice


#### Run Unit & Widget Tests

* Use `flutter test` to run all unit and widget tests

### How it's Made 

#### Flutter
* BLoC pattern and [`flutter_bloc` ](https://pub.dev/packages/flutter_bloc)
* HTTP via [`dio`](https://pub.dev/packages/dio)
* SQL database via [`sqflite`](https://pub.dev/packages/sqflite)

#### Android
* WorkManager
* Room
* Retrofit