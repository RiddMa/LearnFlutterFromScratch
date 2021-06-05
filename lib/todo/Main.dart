import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/todo/FileOperations.dart';
import 'package:my_flutter_app/todo/Settings.dart';
import 'package:intl/intl.dart';

import 'EditTodo.dart';

void main() => runApp(RiddTodoApp());

class RiddTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Ridd\'s Todo App',
      debugShowCheckedModeBanner: false,
      // theme: CupertinoThemeData(brightness: Brightness.light),
      routes: <String, WidgetBuilder>{
        "/": (context) => TodoMain(),
      },
    );
  }
}

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

class TodoItemPrototype {}

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

  TodoItem.fromJson(Map<String, dynamic> todoJson) {
    Key key = todoJson['key'];
    title = todoJson['title'];
    isAllDay = todoJson['isAllDay'] == 1 ? true : false;
    dueDate = DateTime.parse(todoJson['dueDate']);
    repeat = todoJson['repeat'];
    remind = todoJson['remind'];
    note = todoJson['note'];
    done = todoJson['isAllDay'] == 1 ? true : false;
  }

  late String title;
  late bool isAllDay;
  late DateTime dueDate;
  late String repeat;
  late String remind;
  late String note;
  late bool done;

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

  ///映射到数据库
  Map<String, dynamic> toJson() {
    return {
      'key': key.toString().substring(3, 29),
      'title': title,
      'isAllDay': (isAllDay ? 1 : 0),
      'dueDate': dueDate.toIso8601String(),
      'repeat': repeat,
      'remind': remind,
      'note': note,
      'done': (done ? 1 : 0),
    };
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

  ///点击按钮切换完成状态
  void _handleLeadingBtnPress() async {
    HapticFeedback.heavyImpact();
    setState(() {
      widget.done = !widget.done;
    });
    DBProvider().updateTodoItem(widget); //这里不用等
  }

  ///点击条目进入编辑
  void _handleItemTap() async {
    HapticFeedback.lightImpact();
    var resultTodoItem = await Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => EditTodo(
                  mode: 'Edit',
                  parentTodoItem: widget,
                )));
    if (resultTodoItem != null) {
      setState(() {
        widget.setTodoItem(resultTodoItem);
      });
      DBProvider().updateTodoItem(widget); //这里不用等

    }
  }

  _buildListTile() {
    return CupertinoListTile(
      contentPadding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 4.0, right: 4.0),
      leading: CupertinoButton(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(0),
        onPressed: _handleLeadingBtnPress,
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
      onTap: _handleItemTap,
    );
  }

  ///构造todoItem条目
  @override
  Widget build(BuildContext context) {
    return _buildListTile();
  }
}

///主界面内容
class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> todoItems = [];

  @override
  void initState() {
    super.initState();
    _loadTodoItemsFromDB();
  }

  void _loadTodoItemsFromDB() async {
    todoItems = await DBProvider().getAllTodoItems();
    setState(() {});
  }

  void _handleAddBtnPress() async {
    HapticFeedback.lightImpact();
    var resultTodoItem = await Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => EditTodo(
                  mode: 'Add',
                )));
    if (resultTodoItem != null) {
      setState(() {
        todoItems.add(resultTodoItem);
      });
      DBProvider().insertTodoItem(resultTodoItem); //这里不用等

    }
  }

  ///生成主页 NavBar
  _todoListCupertinoSliverNavigationBar(String title) {
    return CupertinoSliverNavigationBar(
      // largeTitle: Text(title),
      largeTitle: CupertinoButton(
        child: Text(title), //todo:删掉按钮
        onPressed: () async {
          setState(() {
            todoItems.clear();
            _loadTodoItemsFromDB();
          });
        },
      ),
      trailing: CupertinoButton(
        padding: const EdgeInsets.all(0),
        child: Icon(CupertinoIcons.add),
        onPressed: _handleAddBtnPress,
      ),
    );
  }

  ///处理滑动删除操作
  void _handleDismiss(DismissDirection direction, int index) async {
    DBProvider().deleteTodoItem(todoItems[index]); //这里不用等
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text(todoItems[index].title + ' deleted'),
    // ));

    todoItems.removeAt(index);
    setState(() {});
  }

  ///生成主页 TodoList 项
  _todoListSliverChildBuilderDelegate() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Dismissible(
          key: todoItems[index].key!,
          onDismissed: (direction) => {_handleDismiss(direction, index)},
          background: Container(
            color: CupertinoColors.activeBlue,
            child: CupertinoListTile(
              leading: Icon(
                CupertinoIcons.star,
                color: CupertinoColors.white,
              ),
            ),
          ),
          secondaryBackground: Container(
            color: CupertinoColors.destructiveRed,
            child: CupertinoListTile(
              trailing: Icon(
                CupertinoIcons.delete,
                color: CupertinoColors.white,
              ),
            ),
          ),
          child: todoItems[index],
        );
        return todoItems[index];
      },
      childCount: todoItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _todoListCupertinoSliverNavigationBar('Ridd\'s Todo '),
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
