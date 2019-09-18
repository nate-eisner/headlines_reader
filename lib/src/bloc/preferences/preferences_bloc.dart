import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './bloc.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  static const String syncKey = 'SYNC';
  final Future<SharedPreferences> _sharedPreferences;

  PreferencesBloc(Future<SharedPreferences> sharedPreferences)
      : _sharedPreferences = sharedPreferences;

  @override
  PreferencesState get initialState => InitialPreferencesState();

  @override
  Stream<PreferencesState> mapEventToState(
    PreferencesEvent event,
  ) async* {
    if (event is GetSyncSetting) {
      var sharedPreferences = await _sharedPreferences;
      bool isOn = sharedPreferences.getBool(syncKey) ?? false;
      yield CurrentSyncSettingState(isOn);
    }

    if (event is ToggleSync) {
      var sharedPreferences = await _sharedPreferences;
      bool isOn = sharedPreferences.getBool(syncKey) ?? false;
      await sharedPreferences.setBool(syncKey, !isOn);
      yield SyncSettingChangedState(!isOn);
    }
  }
}
