import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:my_flutter_app/CupertinoListTile.dart';
import 'package:my_flutter_app/todo/settings.dart';
import 'package:provider/provider.dart';

void main() => runApp(RiddTodoApp());

class RiddTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Ridd\'s Todo App',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.light),
      routes: {
        "/": (context) => TodoMain(),
      },
    );
  }
}

CupertinoNavigationBar buildNavigationBar(String title) {
  return CupertinoNavigationBar(
    middle: Text(title),
    // trailing: Consumer<ValueNotifier<Brightness>>(
    //   builder: (context, brightness, child) {
    //     return CupertinoSwitch(
    //       value: brightness.value == Brightness.dark,
    //       onChanged: (value) => brightness.value = value ? Brightness.dark : Brightness.light,
    //     );
    //   },
    // ),
  );
}

class TodoMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text("首页"),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            title: Text("设置"),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return CupertinoPageScaffold(child: TodoList());
                // return TodoList();
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return TodoSettings();
              },
            );
          default:
            throw new Exception("Error");
        }
      },
    );
  }
}

class TodoItem extends StatelessWidget {
  TodoItem({required Key key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: FlutterLogo(size: 56.0),
      title: Text(name),
      subtitle: Text('Second line...'),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> todoItems = [];

  _todoListCupertinoSliverNavigationBar(String title) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(title),
      trailing: CupertinoButton(
        child: Icon(CupertinoIcons.add),
        onPressed: () {
          setState(() {
            todoItems.add(TodoItem(key: Key(todoItems.length.toString()), name: 'test' + todoItems.length.toString()));
            // print(todoItems.length);
          });
        },
      ),
    );
  }

  _todoListSliverChildBuilderDelegate() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        for (int i = 0; i < todoItems.length; i++) {
          return CupertinoListTile(
            leading: FlutterLogo(size: 56.0),
            title: Text(todoItems[i].name),
            subtitle: Text(i.toString()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      semanticChildCount: 10,
      slivers: <Widget>[
        _todoListCupertinoSliverNavigationBar('Ridd\'s Todo App'),
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.only(top: 12.0),
          sliver: SliverList(
            delegate: _todoListSliverChildBuilderDelegate(),
          ),
        ),
      ],
    );
  }
}
