import 'package:firebase_database/firebase_database.dart';

class Note {
  String _id;
  String _title;
  String _description;

  Note(this._id, this._title, this._description);

  String get id => _id;
  String get title => _title;
  String get description => _description;

  Note.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _title = snapshot.value['title'];
    _description = snapshot.value['description'];
  }
  /*
  A DataSnapshot contains data from a Firebase Database location.
   Any time you read Firebase data, you receive the data as a DataSnapshot.
   */
}
