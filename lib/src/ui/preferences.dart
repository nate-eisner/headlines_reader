import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader/src/bloc/preferences/bloc.dart';

class Preferences extends StatefulWidget {
  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  PreferencesBloc _preferencesBloc;

  @override
  void initState() {
    super.initState();

    _preferencesBloc = BlocProvider.of<PreferencesBloc>(context)
      ..dispatch(GetSyncSetting());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Headlines Background Sync'),
              subtitle: Text(
                  'This schedules a background sync of the headlines every 15 minutes'),
              trailing: BlocBuilder(
                bloc: _preferencesBloc,
                builder: (context, state) {
                  if (state is CurrentSyncSettingState ||
                      state is SyncSettingChangedState)
                    return Switch.adaptive(
                        value: state.isOn,
                        onChanged: (val) {
                          _preferencesBloc.dispatch(ToggleSync(val));
                        });
                  return Container(
                    height: 0,
                    width: 0,
                  );
                },
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('CLOSE'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
