import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sanity Keeper',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new MyHomePage(title: 'Sanity Keeper', storage: new ListStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.storage}) : super(key: key);

  final ListStorage storage;

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _notes = new List<String>();

  @override
  void initState() {
    super.initState();
    widget.storage.readList().then((List<String> notes) {
      setState(() {
        _notes = notes;
      });
    });
  }

  Future<File> _addNote(String newNote) {
    setState(() {
      _notes.add(newNote);
    });
    return widget.storage.writeList(_notes);
  }

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
      body: new Center(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new ListView.builder(
              shrinkWrap: true,
              itemCount: _notes.length,
              itemBuilder: (BuildContext context, int index) {
                final String noteText = _notes[index];
                return new NoteItem(
                  text: noteText
                );
              },
            ),
            new Positioned(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
              child: new NoteEntryBox(
                onSubmit: _addNote,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  NoteItem({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Container(
        child: new Text(
          text,
          style: new TextStyle(fontSize: 18.0),
        ),
        padding: new EdgeInsets.all(8.0),
      ),
    );

  }
}

class NoteEntryBox extends StatelessWidget {
  NoteEntryBox({this.onSubmit});

  final TextEditingController controller = new TextEditingController();

  final ValueChanged<String> onSubmit;

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new Container(
          padding: new EdgeInsets.all(8.0),
          child: new TextField(
            controller: controller,
            decoration: new InputDecoration(
              isDense: true,
            ),
            onSubmitted: (String newNote) {
              controller.clear();
              onSubmit(newNote);
            },
          ),
        )
    );
  }
}

class ListStorage {
  ListStorage() {
    this.json = new JsonCodec();
  }

  JsonCodec json;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/list.txt');
  }

  Future<List<String>> readList() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      List<dynamic> decoded = json.decode(contents);
      List<String> notes = new List<String>();
      for (dynamic d in decoded) {
        notes.add(d as String);
      }
      return notes;
    } catch (e) {
      print("Couldn't find file, returning empty list");
      return new List<String>();
    }
  }

  Future<File> writeList(List<String> list) async {
    final file = await _localFile;
    
    // Write the file
    return file.writeAsString(json.encode(list));
  }
}
