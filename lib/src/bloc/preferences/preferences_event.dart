import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PreferencesEvent extends Equatable {
  PreferencesEvent([List props = const <dynamic>[]]) : super(props);
}

class GetSyncSetting extends PreferencesEvent {}

class ToggleSync extends PreferencesEvent {
  bool get isOn => props[0];

  ToggleSync(bool isOn) : super([isOn]);
}
