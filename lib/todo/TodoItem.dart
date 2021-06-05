import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'EditTodo.dart';
import 'FileOperations.dart';

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

  // TodoItem.fromJson(Map<String, dynamic> todoJson) {
  //   Key key = todoJson['key'];
  //   title = todoJson['title'];
  //   isAllDay = todoJson['isAllDay'] == 1 ? true : false;
  //   dueDate = DateTime.parse(todoJson['dueDate']);
  //   repeat = todoJson['repeat'];
  //   remind = todoJson['remind'];
  //   note = todoJson['note'];
  //   done = todoJson['isAllDay'] == 1 ? true : false;
  // }

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
