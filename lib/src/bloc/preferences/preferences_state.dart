import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PreferencesState extends Equatable {
  PreferencesState([List props = const <dynamic>[]]) : super(props);
}

class InitialPreferencesState extends PreferencesState {}

class CurrentSyncSettingState extends PreferencesState {
  bool get isOn => props[0];

  CurrentSyncSettingState(bool isOn) : super([isOn]);
}

class SyncSettingChangedState extends PreferencesState {
  bool get isOn => props[0];

  SyncSettingChangedState(bool isOn) : super([isOn]);
}
