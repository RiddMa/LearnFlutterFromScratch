import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewTodo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  _newTodoNavigationBar(String title) {
    return CupertinoNavigationBar(
      middle: Text(title),
      leading: CupertinoNavigationBarBackButton(
        onPressed: () => Navigator.of(context).pop(),
      ),
      trailing: CupertinoButton(
        child: Text('Add'),
        padding: const EdgeInsets.all(0),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  _newTodoBodyLayout_sliver() {
    List<Widget> items = [
      CupertinoListTile(
        title: Text('Title'),
      ),

      ///todo seperator
      CupertinoListTile(
        title: Text('Due Date'),
      ),
      CupertinoListTile(
        title: Text('Repeat'),
      ),
      CupertinoListTile(
        title: Text('Remind Me'),
      ),
      CupertinoListTile(
        title: Text('Add Note'),
      ),
    ];

    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return items[index];
      },
      childCount: items.length,
    );
  }

  _newTodoBodyLayout() {
    return Column(
      children: [
        CupertinoListTile(
          title: Text('Title'),
        ),
        CupertinoListTile(
          title: Text('Location'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _newTodoNavigationBar('Add Todo Item'),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverSafeArea(
            minimum: const EdgeInsets.only(top: 10.0),
            sliver: SliverList(
              delegate: _newTodoBodyLayout_sliver(),
            ),
          ),
        ],
      ),
    );
  }
}
