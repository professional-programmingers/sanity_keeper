import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sanity Keeper',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: new MyHomePage(title: 'Sanity Keeper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _notes = new List<String>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new DrawerHeader(
              child: new Text('Sanity Keeper'),
              decoration: new BoxDecoration(
                color: Colors.orange,
              ),
            ),
            new ListTile(
              title: new Text('To-Do'),
              onTap: () {

              },
            ),
            new ListTile(
              title: new Text('Scratchbook'),
              onTap: () {

              },
            ),
          ],
        ),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new TextField(
            onSubmitted: (String newNote) {
              setState(() {
                _notes.add(newNote);
              });
            }
          ),
          new ListView(
            shrinkWrap: true,
            padding: new EdgeInsets.all(8.0),
            children: _notes.map((String str) {
              return new Card(
                child: new Container(
                  child: new Text(
                    str,
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  padding: new EdgeInsets.all(8.0),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
