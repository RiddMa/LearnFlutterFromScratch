import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TodoSettingsState();
}

class _TodoSettingsState extends State<TodoSettings> {
  //TODO: add config

  _todoListCupertinoSliverNavigationBar(String title) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(title),
    );
  }

  _todoSettingsSliverChildBuilderDelegate() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return CupertinoListTile(
          leading: FlutterLogo(size: 56.0),
          title: Text("Setting"),
          subtitle: Text('Second line...'),
        );
      },
      childCount: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      semanticChildCount: 10,
      slivers: <Widget>[
        _todoListCupertinoSliverNavigationBar('Settings'),
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.only(top: 12.0),
          sliver: SliverList(
            delegate: _todoSettingsSliverChildBuilderDelegate(),
          ),
        ),
      ],
    );
  }
}
