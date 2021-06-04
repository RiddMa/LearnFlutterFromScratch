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
    List<Widget> settingItems = [
      CupertinoFormSection(
        header: Text('Personal'),
        children: [
          CupertinoFormRow(
            child: Text('aaa'),
          ),
          CupertinoFormRow(
            child: Text('bbb'),
          )
        ],
      ),
      CupertinoFormSection(
        header: Text('General'),
        children: [
          CupertinoFormRow(
            child: Text('aaa'),
          ),
          CupertinoFormRow(
            child: Text('bbb'),
          )
        ],
      ),
      CupertinoFormSection(
        header: Text('Lists'),
        children: [
          CupertinoFormRow(
            child: Text('aaa'),
          ),
          CupertinoFormRow(
            child: Text('bbb'),
          )
        ],
      ),
      CupertinoFormSection(
        header: Text('Notifications'),
        children: [
          CupertinoFormRow(
            child: Text('aaa'),
          ),
          CupertinoFormRow(
            child: Text('bbb'),
          )
        ],
      ),
      CupertinoFormSection(
        header: Text('About'),
        children: [
          CupertinoFormRow(
            child: Text('aaa'),
          ),
          CupertinoFormRow(
            child: Text('bbb'),
          )
        ],
      ),
    ];
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return settingItems[index];
      },
      childCount: settingItems.length,
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
          bottom: false,
          // minimum: const EdgeInsets.only(top: 10.0),
          sliver: SliverList(
            delegate: _todoSettingsSliverChildBuilderDelegate(),
          ),
        ),
      ],
    );
  }
}
