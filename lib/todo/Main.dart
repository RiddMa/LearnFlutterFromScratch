import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/todo/Settings.dart';
import 'package:intl/intl.dart';

import 'EditTodo.dart';
import 'NewTodo.dart';
import 'dart:io';

void main() => runApp(RiddTodoApp());

vibrate(String type) async {
  switch (type) {
    case 'heavy':
      HapticFeedback.heavyImpact();
      break;
    case 'medium':
      HapticFeedback.mediumImpact();
      break;
    case 'light':
      HapticFeedback.lightImpact();
      break;
    case 'click':
    case 'medium':
      HapticFeedback.selectionClick();
      break;
  }
}

class RiddTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Ridd\'s Todo App',
      debugShowCheckedModeBanner: false,
      // theme: CupertinoThemeData(brightness: Brightness.light),
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

class TodoItem extends StatefulWidget {
  TodoItem({
    required Key key,
    required this.title,
    required this.isAllDay,
    required this.dueDate,
    required this.repeat,
    required this.remind,
    required this.note,
    required this.done,
  }) : super(key: key);

  String title;
  bool isAllDay;
  DateTime dueDate;
  String repeat;
  String remind;
  String note;
  bool done;

  ///更新自身状态
  setTodoItem(TodoItem newItem) {
    this.title = newItem.title;
    this.isAllDay = newItem.isAllDay;
    this.dueDate = newItem.dueDate;
    this.repeat = newItem.repeat;
    this.remind = newItem.remind;
    this.note = newItem.note;
    this.done = newItem.done;
  }

  @override
  State<StatefulWidget> createState() => _TodoItemState();
}

///todoItem条目状态
class _TodoItemState extends State<TodoItem> {
  String _formatDate(DateTime srcDate) {
    if (widget.isAllDay) {
      return DateFormat('yyyy-MM-dd').format(srcDate);
    } else {
      return DateFormat('yyyy-MM-dd – kk:mm').format(srcDate);
    }
  }

  Widget _getFinishedIcon() {
    if (widget.done) {
      return Icon(
        CupertinoIcons.check_mark_circled_solid,
        size: 30,
      );
    } else {
      return Icon(
        CupertinoIcons.check_mark_circled,
        size: 30,
      );
    }
  }

  ///构造todoItem条目
  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      contentPadding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 4.0, right: 4.0),
      leading: CupertinoButton(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(0),
        onPressed: () {
          vibrate('heavy');
          setState(() {
            widget.done = !widget.done;
          });
        },
        child: _getFinishedIcon(),
      ),
      title: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              textScaleFactor: 1.25,
              softWrap: true,
              maxLines: 1,
            ),
            Text(
              "Due: " + _formatDate(widget.dueDate),
              textScaleFactor: 0.75,
              softWrap: true,
              maxLines: 1,
            ),
          ],
        ),
      ),
      onTap: () async {
        vibrate('light');
        var resultTodoItem = await Navigator.push(
            context,
            new CupertinoPageRoute(
                builder: (context) =>
                    EditTodo(
                      mode: 'Edit',
                      parentTodoItem: widget,
                    )));
        if (resultTodoItem != null) {
          setState(() {
            widget.setTodoItem(resultTodoItem);
          });
        }
      },
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
          vibrate('light');
          var resultTodoItem = await Navigator.push(
              context,
              new CupertinoPageRoute(
                  builder: (context) =>
                      EditTodo(
                        mode: 'Add',
                      )));
          setState(() {
            if (resultTodoItem != null) {
              todoItems.add(resultTodoItem);
            }
          });
        },
      ),
    );
  }

  ///生成主页 TodoList 项
  _todoListSliverChildBuilderDelegate() {
    return SliverChildBuilderDelegate(
          (BuildContext context, int index) {
        return todoItems[index];
      },
      childCount: todoItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _todoListCupertinoSliverNavigationBar('Ridd\'s Todo'),
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
