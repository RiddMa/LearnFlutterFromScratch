import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: new MyHomePage(
      //   title: 'Flutter Demo Home Page',
      //   key: new Key('Home'),
      // ),
      routes: {
        "new_page": (context) => NewRoute(),
        "tip_page": (context, {args}) => TipRoute(key: Key("some key"), text: args.toString()),
        "/": (context) => MyHomePage(key: Key("A home page"), title: "Ridd's Flutter Demo"),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required Key key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Scrollbar(
        child: new SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'You have pushed the button this many times:',
                ),
                new Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
                new FlatButton(
                  child: new Text("Open new route"),
                  textColor: Colors.blue,
                  onPressed: () {
                    Navigator.pushNamed(context, "new_page");
                  },
                ),
                new RouterTestRoute(),
                new NamedRouteArg(),
                new MyImageView(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('New route'),
      ),
      body: new Center(
        child: new Text('This is the new route'),
      ),
    );
  }
}

class TipRoute extends StatelessWidget {
  TipRoute({
    required Key key,
    required this.text,
  }) : super(key: key);

  final String text;

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
              Text(text),
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

class RouterTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoButton.filled(
        onPressed: () async {
          //open `TipRoute` and wait for return
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return TipRoute(key: Key("1"), text: "我是提示xxx");
            }),
          );
          print("$result");
        },
        child: Text("打开提示"),
      ),
    );
  }
}

class NamedRouteArg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    return Center(
      child: CupertinoButton(
        onPressed: () async {
          var result = await Navigator.pushNamed(context, "tip_page", arguments: args);
          print("$result");
        },
        child: Text("打开提示-命名路由"),
      ),
    );
  }
}

class MyImageView extends StatelessWidget {
  final String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Image.asset('assets/test.jpg'),
      ),
    );
  }
}
