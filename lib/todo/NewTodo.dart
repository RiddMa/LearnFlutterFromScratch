import 'dart:core';

import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_app/todo/main.dart';

class NewTodo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  final double _dateTimePickerHeight = 192;
  final double _formRowHeight = 40;

  // GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  bool _isAllDay = true;
  DateTime _dueDate = new DateTime.now();
  TextEditingController _repeatController = new TextEditingController();
  TextEditingController _remindController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();

  ///生成NavBar
  _newTodoNavigationBar(String title) {
    return CupertinoNavigationBar(
      middle: Text(title),
      leading: CupertinoNavigationBarBackButton(
        onPressed: () => Navigator.of(context).pop(),
      ),
      trailing: CupertinoButton(
        child: Text('Add'),
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.of(context).pop([
            _titleController.text,
            _isAllDay,
            _dueDate,
            _repeatController.text,
            _remindController.text,
            _noteController.text,
          ]);
        },
      ),
    );
  }

  String _formatDate(DateTime srcDate) {
    if (_isAllDay) {
      return DateFormat('yyyy-MM-dd').format(srcDate);
    } else {
      return DateFormat('yyyy-MM-dd – kk:mm').format(srcDate);
    }
  }

  ///生成newTodo表单控件
  // ignore: non_constant_identifier_names
  newTodoBodyLayout_sliver() {
    List<Widget> items = [
      Container(
        child: CupertinoFormSection(
          header: Text("Title"),
          children: [
            CupertinoTextFormFieldRow(
              controller: _titleController,
              prefix: Text("Title"),
              placeholder: "What todo?",
            ),
          ],
        ),
      ),
      CupertinoFormSection(
        header: Text("Date"),
        children: [
          CupertinoFormRow(
              prefix: Text("All day"),
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
              child: Text(_formatDate(_dueDate)),
            ),
          ),
        ],
      ),
      Container(
        height: _dateTimePickerHeight,
        child: CupertinoDatePicker(
          key: Key('date'),
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.now(),
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

    Container _timePickerContainer = Container(
      height: _dateTimePickerHeight,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        initialDateTime: DateTime.now(),
        use24hFormat: true,
        onDateTimeChanged: (newDateTime) {
          setState(() {
            _dueDate = newDateTime;
          });
        },
      ),
    );

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

    if (_isAllDay == false) {
      // items.insert(3, _timePickerContainer);
      items.removeAt(2);
      items.insert(2, _dateTimePickerContainer);
      // items[2]=_timePickerContainer;
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
      navigationBar: _newTodoNavigationBar('Add Todo Item'),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverSafeArea(
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
