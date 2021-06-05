import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
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
      largeTitle: Text(title),
      // largeTitle: CupertinoButton(
      //   child: Text(title),
      //   onPressed: () async {
      //     setState(() {
      //       todoItems.clear();
      //       _loadTodoItemsFromDB();
      //     });
      //   },
      // ),
      trailing: CupertinoButton(
        padding: const EdgeInsets.all(0),
        child: Icon(CupertinoIcons.add),
        onPressed: _handleAddBtnPress,
      ),
    );
  }

  ///处理滑动删除操作
  Future<bool> _handleDismiss(DismissDirection direction, int index) async {
    bool _toDismiss = false;
    if (direction == DismissDirection.endToStart) {
      ///从右向左滑动删除
      _toDismiss = true;
      DBProvider().deleteTodoItem(todoItems[index]); //这里不用等
      setState(() {
        todoItems.removeAt(index);
      });
    } else {
      ///从左向右滑动
      _toDismiss = true;
      setState(() {
        todoItems[index].done = true;
      });
      DBProvider().updateTodoItem(todoItems[index]);
    }

    return _toDismiss;
  }

  ///生成主页 TodoList 项
  _todoListSliverChildBuilderDelegate() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Dismissible(
          key: todoItems[index].key!,
          confirmDismiss: (direction) => _handleDismiss(direction, index),
          // onDismissed: (direction) => _handleDismiss(direction, index),
          resizeDuration: const Duration(milliseconds: 500),
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
      },
      childCount: todoItems.length,
    );
  }

  ///构建主tab界面
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
