import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'EditTodo.dart';
import 'FileOperations.dart';
import 'TodoItem.dart';

///主界面tab内容
class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> todoItems = [];
  List<TodoItem> doneItems = [];

  @override
  void initState() {
    super.initState();
    _loadTodoItemsFromDB();
  }

  void _loadTodoItemsFromDB() async {
    var allItems = await DBProvider().getAllTodoItems();
    for (int i = 0; i < allItems.length; i++) {
      if (allItems[i].done) {
        doneItems.add(allItems[i]);
      } else {
        todoItems.add(allItems[i]);
      }
    }
    setState(() {});
  }

  void _addTodoItem(TodoItem _todoItem) {
    setState(() {
      todoItems.add(_todoItem);
    });
    DBProvider().insertTodoItem(_todoItem);
  }

  void _updateTodoItem(TodoItem _todoItem, int index, bool done) async {
    if (done) {
      _todoItem.done = true;
      doneItems.add(_todoItem);
      todoItems.removeAt(index);
      setState(() {});
      DBProvider().updateTodoItem(_todoItem);
    } else {
      doneItems[index].done = false;
      todoItems.add(_todoItem);
      doneItems.removeAt(index);
      setState(() {});
      DBProvider().updateTodoItem(_todoItem);
    }
  }

  void _deleteTodoItem(TodoItem _todoItem, int index) {
    DBProvider().deleteTodoItem(_todoItem);
    setState(() {
      todoItems.removeAt(index);
    });
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
      _addTodoItem(resultTodoItem);
    }
  }

  ///生成主页 NavBar
  _todoListCupertinoSliverNavigationBar(String title) {
    return CupertinoSliverNavigationBar(
      // stretch: true,
      // backgroundColor: Colors(BFFFFFFF),
      transitionBetweenRoutes: true,
      padding: const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
      largeTitle: Text(title),
      trailing: CupertinoButton(
        padding: const EdgeInsets.all(0),
        child: Icon(
          CupertinoIcons.add,
        ),
        onPressed: _handleAddBtnPress,
      ),
    );
  }

  ///处理滑动删除Todo操作
  Future<bool> _handleTodoDismiss(DismissDirection direction, int index) async {
    bool _toDismiss = false;
    if (direction == DismissDirection.endToStart) {
      ///从右向左滑动删除
      _toDismiss = true;
      _deleteTodoItem(todoItems[index], index);
    } else {
      ///从左向右滑动完成
      _toDismiss = true;
      // todoItems[index].update(done: true);
      _updateTodoItem(todoItems[index], index, true);
    }
    return _toDismiss;
  }

  ///处理滑动删除Done操作
  Future<bool> _handleDoneDismiss(DismissDirection direction, int index) async {
    bool _toDismiss = false;
    if (direction == DismissDirection.endToStart) {
      ///从右向左滑动删除
      _toDismiss = true;
      _deleteTodoItem(doneItems[index], index);
    } else {
      ///从左向右滑动完成
      _toDismiss = true;
      // todoItems[index].update(done: true);
      _updateTodoItem(doneItems[index], index, false);
    }
    return _toDismiss;
  }

  _bgFormRow() {
    return CupertinoFormRow(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 9.0),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            //   child: Container(),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    CupertinoIcons.star,
                    color: CupertinoColors.white,
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///生成TodoRow
  Dismissible _buildTodoRow(int index) {
    return Dismissible(
      key: todoItems[index].key!,
      confirmDismiss: (direction) => _handleTodoDismiss(direction, index),
      // onDismissed: (direction) => _handleDismiss(direction, index),
      // resizeDuration: const Duration(milliseconds: 1000),
      // movementDuration: const Duration(milliseconds: 1000),
      background: Container(
        color: CupertinoColors.activeBlue,
        child: _bgFormRow(),
      ),
      secondaryBackground: Container(
        color: CupertinoColors.destructiveRed,
        child: _bgFormRow(),
      ),
      child: todoItems[index],
    );
  }

  ///生成DoneRow
  Dismissible _buildDoneRow(int index) {
    return Dismissible(
      key: doneItems[index].key!,
      confirmDismiss: (direction) => _handleDoneDismiss(direction, index),
      // onDismissed: (direction) => _handleDismiss(direction, index),
      resizeDuration: const Duration(milliseconds: 500),
      background: Container(
        alignment: Alignment.centerLeft,
        color: CupertinoColors.activeBlue,
        child: _bgFormRow(),
      ),
      secondaryBackground: Container(
        color: CupertinoColors.destructiveRed,
        child: _bgFormRow(),
      ),
      child: doneItems[index],
    );
  }

  ///生成主页TodoList项
  _todoListSliverChildBuilderDelegate() {
    List<Widget> todoChildren = [];
    List<Widget> doneChildren = [];
    if (todoItems.isEmpty) {
      todoChildren.add(Text('nothing'));
    } else {
      for (int i = 0; i < todoItems.length; i++) {
        todoChildren.add(_buildTodoRow(i));
      }
    }
    if (doneItems.isEmpty) {
      doneChildren.add(Text('nothing'));
    } else {
      for (int i = 0; i < doneItems.length; i++) {
        doneChildren.add(_buildDoneRow(i));
      }
    }

    List<Widget> listItems = [
      CupertinoFormSection.insetGrouped(
        header: Text('Due'),
        children: todoChildren,
      ),
      CupertinoFormSection.insetGrouped(
        header: Text('Done'),
        children: doneChildren,
      ),
    ];

    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return listItems[index];
      },
      childCount: listItems.length,
    );
  }

  ///构建主tab界面
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < todoItems.length; i++) {
      if (todoItems[i].done) {
        doneItems.add(todoItems[i]);
        todoItems.removeAt(i);
      }
    }
    for (int i = 0; i < doneItems.length; i++) {
      if (!doneItems[i].done) {
        todoItems.add(doneItems[i]);
        doneItems.removeAt(i);
      }
    }
    return CustomScrollView(
      slivers: <Widget>[
        _todoListCupertinoSliverNavigationBar('Ridd\'s Todo '),
        SliverSafeArea(
          top: false,
          bottom: false,
          sliver: SliverList(
            delegate: _todoListSliverChildBuilderDelegate(),
          ),
        ),
      ],
    );
  }
}
