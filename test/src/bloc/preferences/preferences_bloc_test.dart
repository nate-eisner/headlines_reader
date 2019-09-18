import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader/src/bloc/preferences/bloc.dart';

import '../../../test_utils.dart';

void main() {
  MockSharedPreferences mockSharedPreferences;

  PreferencesBloc preferencesBloc;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    preferencesBloc = PreferencesBloc(Future.value(mockSharedPreferences));
  });

  test('Get sync setting', () {
    when(mockSharedPreferences.getBool(any)).thenReturn(true);
    final expectedResponse = [
      isA<InitialPreferencesState>(),
      CurrentSyncSettingState(true),
    ];
    expectLater(
      preferencesBloc.state,
      emitsInOrder(expectedResponse),
    );
    preferencesBloc.dispatch(GetSyncSetting());
  });

  test('Get sync setting, never set', () {
    when(mockSharedPreferences.getBool(any)).thenReturn(null);
    final expectedResponse = [
      isA<InitialPreferencesState>(),
      CurrentSyncSettingState(false),
    ];
    expectLater(
      preferencesBloc.state,
      emitsInOrder(expectedResponse),
    );
    preferencesBloc.dispatch(GetSyncSetting());
  });

  test('Sync setting changed', () {
    when(mockSharedPreferences.getBool(any)).thenReturn(false);
    final expectedResponse = [
      isA<InitialPreferencesState>(),
      SyncSettingChangedState(true),
    ];
    expectLater(
      preferencesBloc.state,
      emitsInOrder(expectedResponse),
    );
    preferencesBloc.dispatch(ToggleSync(true));
  });
}
