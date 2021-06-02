import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter剪贴板操作',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter剪贴板操作',
        key: null,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // 待复制的文字
  String _txtToBeCopied = "";

  // 保存粘贴的文字
  String _txtToBePaste = "";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  /// 变更待复制的文字
  void _chgTxt() {
    setState(() {
      _txtToBeCopied = Random().nextInt(10000).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '待复制的文字:',
            ),
            Text(
              _txtToBeCopied,
              style: Theme.of(context).textTheme.headline3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () => _chgTxt(),
                  child: Text("生成文字"),
                ),
                RaisedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _txtToBeCopied)).then((value) => print("已复制!"));
                  },
                  child: Text("复制"),
                )
              ],
            ),
            Text(
              '剪贴板的文字:',
            ),
            Text(
              _txtToBePaste,
              style: Theme.of(context).textTheme.headline3,
            ),
            RaisedButton(
              onPressed: () {
                Clipboard.getData(Clipboard.kTextPlain).then((value) {
                  if (value != null) {
                    _txtToBePaste = value.text!;
                    setState(() {});
                  }
                });
              },
              child: Text("获取"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
