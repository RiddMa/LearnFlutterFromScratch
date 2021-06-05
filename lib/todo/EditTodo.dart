import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'Main.dart';

// ignore: must_be_immutable
class EditTodo extends StatefulWidget {
  EditTodo({required this.mode, TodoItem? parentTodoItem}) {
    if (mode == 'Add') {
      _todoItem = TodoItem(
        key: Key(DateTime.now().toString()),
        title: '',
        isAllDay: true,
        dueDate: DateTime.now(),
        repeat: '',
        remind: '',
        note: '',
        done: false,
      );
    } else if (mode == 'Edit') {
      _todoItem = parentTodoItem!;
    }
  }

  static var _todoItem;
  final String mode;

  @override
  State<StatefulWidget> createState() {
    return _EditTodoState(_todoItem);
  }
}

class _EditTodoState extends State<EditTodo> {
  _EditTodoState(TodoItem parentItem) {
    this._key = parentItem.key;
    this._titleController = TextEditingController(text: parentItem.title);
    this._isAllDay = parentItem.isAllDay;
    this._dueDate = parentItem.dueDate;
    this._repeatController = TextEditingController(text: parentItem.repeat);
    this._remindController = TextEditingController(text: parentItem.remind);
    this._noteController = TextEditingController(text: parentItem.note);
    this._done = parentItem.done;
  }

  final double _dateTimePickerHeight = 192;
  final double _formRowHeight = 40;

  var _key;
  var _titleController;
  var _isAllDay;
  var _dueDate;
  var _repeatController;
  var _remindController;
  var _noteController;
  var _done;

  ///编辑完成退出界面并返回新的Todo对象
  _handleDoneBtnPress() async {
    Navigator.of(context).pop(TodoItem(
      key: _key,
      title: _titleController.text,
      isAllDay: _isAllDay,
      dueDate: _dueDate,
      repeat: _repeatController.text,
      remind: _remindController.text,
      note: _noteController.text,
      done: _done,
    ));
  }

  ///生成NavBar
  _newTodoNavigationBar(String title) {
    return CupertinoNavigationBar(
      middle: Text(title),
      leading: CupertinoNavigationBarBackButton(
        onPressed: () => Navigator.of(context).pop(),
      ),
      trailing: CupertinoButton(
        child: Text('Done'),
        padding: const EdgeInsets.all(0),
        onPressed: _handleDoneBtnPress,
      ),
    );
  }

  ///将DatePicker返回的DateTime格式化
  String _formatDate(DateTime srcDate) {
    if (_isAllDay) {
      return DateFormat('yyyy-MM-dd').format(srcDate);
    } else {
      return DateFormat('yyyy-MM-dd – kk:mm').format(srcDate);
    }
  }

  Widget _getFinishedIcon() {
    if (_done) {
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

  ///生成newTodo表单控件
  // ignore: non_constant_identifier_names
  newTodoBodyLayout_sliver() {
    ///控件list
    List<Widget> items = [
      Container(
        child: CupertinoFormSection(
          header: Text("Title"),
          children: [
            CupertinoTextFormFieldRow(
              autofocus: true,
              maxLines: 1,
              controller: _titleController,
              // prefix: Text("Title"),
              placeholder: "What todo?",
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            CupertinoFormRow(
              prefix: Text("Finished"),
              child: CupertinoButton(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  vibrate('heavy');
                  setState(() {
                    _done = !_done;
                  });
                },
                child: _getFinishedIcon(),
              ),
            ),
          ],
        ),
      ),
      CupertinoFormSection(
        header: Text("Date"),
        children: [
          CupertinoFormRow(
              prefix: Text("All-day"),
              child: CupertinoSwitch(
                  value: _isAllDay,
                  onChanged: (bool value) {
                    setState(() {
                      _isAllDay = !_isAllDay;
                    });
                  })),
          CupertinoFormRow(
            prefix: Text("Due Date"),
            child: Container(
              height: _formRowHeight,
              alignment: Alignment.centerRight,
              child: Text(_formatDate(_dueDate).toString()),
            ),
          ),
        ],
      ),
      Container(
        height: _dateTimePickerHeight,
        child: CupertinoDatePicker(
          key: Key('date'),
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _dueDate,
          onDateTimeChanged: (newDateTime) {
            setState(() {
              _dueDate = newDateTime;
            });
          },
        ),
      ),
      CupertinoFormSection(
        children: [
          CupertinoTextFormFieldRow(
            controller: _repeatController,
            prefix: Text("Repeat"),
            placeholder: "",
          ),
          CupertinoTextFormFieldRow(
            controller: _remindController,
            prefix: Text("Remind Me"),
            placeholder: "",
          ),
        ],
      ),
      CupertinoFormSection(
        header: Text("Note"),
        children: [
          CupertinoTextFormFieldRow(
            controller: _noteController,
            prefix: Text("Add Note"),
            placeholder: "",
          ),
        ],
      ),
    ];

    Container _dateTimePickerContainer = Container(
      height: _dateTimePickerHeight,
      child: CupertinoDatePicker(
        key: Key("dateTime"),
        mode: CupertinoDatePickerMode.dateAndTime,
        initialDateTime: _dueDate,
        use24hFormat: true,
        onDateTimeChanged: (newDateTime) {
          setState(() {
            _dueDate = newDateTime;
          });
        },
      ),
    );

    ///init
    if (_isAllDay == false) {
      items.removeAt(2);
      items.insert(2, _dateTimePickerContainer);
    }

    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return items[index];
      },
      childCount: items.length,
    );
  }

  ///构造newTodo界面
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _newTodoNavigationBar(widget.mode + ' Todo Item'),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverSafeArea(
            top: true,
            left: true,
            right: true,
            minimum: const EdgeInsets.only(top: 10.0),
            sliver: SliverList(
              delegate: newTodoBodyLayout_sliver(),
            ),
          ),
        ],
      ),
    );
  }
}
