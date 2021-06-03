import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:my_flutter_app/todo/Settings.dart';
import 'package:provider/provider.dart';

import 'NewTodo.dart';

void main() => runApp(RiddTodoApp());

class RiddTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Ridd\'s Todo App',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.light),
      routes: <String, WidgetBuilder>{
        "/": (context) => TodoMain(),
        "newTodo": (context) => TipRoute(key: Key("some key")),
      },
      // onGenerateRoute: (RouteSettings settings) {
      //   final String? routeName = settings.name;
      //   final Object? args = settings.arguments;
      //   switch (routeName) {
      //     case '/newTodo':
      //       return CupertinoPageRoute(
      //         builder: (context) => NewTodo(),
      //         settings: settings,
      //       );
      //   }
      // },
    );
  }
}

class TipRoute extends StatelessWidget {
  TipRoute({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("提示"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            children: [
              Text('text'),
              CupertinoButton.filled(
                onPressed: () => Navigator.pop(context, ["我是返回值1", "我是返回值2"]),
                child: Text("返回"),
              ),
            ],
          ),
        ),
      ),
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

///主界面
class TodoMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: "设置",
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
            throw new Exception("Page Not Found Error");
        }
      },
    );
  }
}

///todoItem 条目
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

///主界面内容
class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> todoItems = [];

  ///生成主页 NavBar
  _todoListCupertinoSliverNavigationBar(String title) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(title),
      trailing: CupertinoButton(
        padding: const EdgeInsets.all(0),
        child: Icon(CupertinoIcons.add),
        onPressed: () async {
          var result = await Navigator.push(context, new CupertinoPageRoute(builder: (context) => NewTodo()));
          print("$result");
          // setState(() {
          //   todoItems.add(TodoItem(key: Key(todoItems.length.toString()), name: 'test' + todoItems.length.toString()));
          //   // print(todoItems.length);
          // });
        },
      ),
    );
  }

  ///生成主页 TodoList 项
  _todoListSliverChildBuilderDelegate() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return CupertinoListTile(
          leading: FlutterLogo(size: 56.0),
          title: Text(todoItems[index].name),
          subtitle: Text(index.toString()),
        );
      },
      childCount: todoItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _todoListCupertinoSliverNavigationBar('Ridd\'s Todo App'),
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.only(top: 10.0),
          sliver: SliverList(
            delegate: _todoListSliverChildBuilderDelegate(),
          ),
        ),
      ],
    );
  }
}
