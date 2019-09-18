import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader/src/bloc/preferences/bloc.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  PreferencesBloc _preferencesBloc;

  @override
  void initState() {
    super.initState();

    _preferencesBloc = BlocProvider.of<PreferencesBloc>(context)
      ..dispatch(GetSyncSetting());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Stack(fit: StackFit.expand, children: <Widget>[
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 24,
              ),
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
              )
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              color: Theme.of(context).accentColor,
            ),
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        )
      ]),
    );
  }
}
