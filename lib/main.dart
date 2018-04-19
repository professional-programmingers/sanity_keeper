import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import 'storage.dart';

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

  Future<File> _removeNote(int index) {
    print("asdf");
    setState(() {
      _notes.removeAt(index);
    });
    return widget.storage.writeList(_notes);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new ListView.builder(
              padding: EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0, bottom: 62.0),
              shrinkWrap: true,
              itemCount: _notes.length,
              itemBuilder: (BuildContext context, int index) {
                final int arrIndex = _notes.length - index - 1;
                final String noteText = _notes[arrIndex];
                return new NoteItem(
                  text: noteText,
                  index: arrIndex,
                  onDismiss: _removeNote,
                );
              },
            ),
            new Positioned(
              bottom: 6.0,
              left: 6.0,
              right: 6.0,
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
  NoteItem({this.text, this.index, this.onDismiss});

  final String text;
  final int index;

  final ValueChanged<int> onDismiss;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(bottom: 2.0),
      child: new Dismissible(
        key: new Key(text),
        onDismissed: (DismissDirection direction) {
          onDismiss(index);
        },
        child: new Card(
          child: new Container(
            child: new Text(
              text,
              style: new TextStyle(fontSize: 18.0),
            ),
            padding: new EdgeInsets.all(8.0),
          ),
        ),
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
      elevation: 4.0,
      child: new Container(
        padding: new EdgeInsets.all(6.0),
        child: new TextField(
          //maxLines: null,
          controller: controller,
          decoration: new InputDecoration(
            isDense: true,
            hintText: "New note...",
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

