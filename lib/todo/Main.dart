import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/todo/FileOperations.dart';
import 'package:my_flutter_app/todo/Settings.dart';
import 'package:intl/intl.dart';

import 'EditTodo.dart';
import 'TodoList.dart';

void main() => runApp(RiddTodoApp());

class RiddTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Ridd\'s Todo',
      debugShowCheckedModeBanner: false,
      // theme: CupertinoThemeData(brightness: Brightness.light),
      routes: <String, WidgetBuilder>{
        "/": (context) => TodoMainRoute(),
      },
    );
  }
}

///主界面
class TodoMainRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return CupertinoPageScaffold(
                    backgroundColor: CupertinoColors.systemGroupedBackground,
                    // resizeToAvoidBottomInset: true,
                    child: TodoList());
                // return TodoList();
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) {
                // return TodoSettings();
                return CupertinoPageScaffold(child: TodoSettings());
              },
            );
          default:
            throw new Exception("Page Not Found Error");
        }
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
