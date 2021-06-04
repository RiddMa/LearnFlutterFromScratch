import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/todo/Settings.dart';
import 'package:intl/intl.dart';

import 'EditTodo.dart';
import 'NewTodo.dart';

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

// ignore: must_be_immutable
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

  @override
  State<StatefulWidget> createState() => _TodoItemState();
}

///todoItem 条目
class _TodoItemState extends State<TodoItem> {
  String _formatDate(DateTime srcDate) {
    if (widget.isAllDay) {
      return DateFormat('yyyy-MM-dd').format(srcDate);
    } else {
      return DateFormat('yyyy-MM-dd – kk:mm').format(srcDate);
    }
  }

  ///构造todoItem条目
  @override
  Widget build(BuildContext context) {
    print(widget.dueDate);
    return CupertinoListTile(
      leading: CupertinoButton(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(0),
        onPressed: () => vibrate('heavy'),
        child: Icon(
          CupertinoIcons.check_mark_circled,
          size: 30,
        ),
      ),

      // Container(
      //   constraints: BoxConstraints.tightFor(width: 40, height: 40),
      //   alignment: Alignment.center,
      //   child: CupertinoButton(
      //     alignment: Alignment.center,
      //     onPressed: () => vibrate('heavy'),
      //     child: Icon(
      //       CupertinoIcons.check_mark_circled,
      //       size: 30,
      //     ),
      //   ),
      // ),
      title: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              textScaleFactor: 1.25,
            ),
            Text(
              "Due: " + _formatDate(widget.dueDate),
              textScaleFactor: 0.75,
            ),
          ],
        ),
      ),
      onTap: () async {
        vibrate('light');
        var result = await Navigator.push(context, new CupertinoPageRoute(builder: (context) => EditTodo()));
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
          var result = await Navigator.push(context, new CupertinoPageRoute(builder: (context) => NewTodo()));
          setState(() {
            if (result != null) {
              todoItems.add(TodoItem(
                key: Key(result[2].toString()),
                title: result[0],
                isAllDay: result[1],
                dueDate: result[2],
                repeat: result[3],
                remind: result[4],
                note: result[5],
                done: false,
              ));
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
