import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

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
