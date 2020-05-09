import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasedatabasedemo/model/note.dart';

import 'package:flutter/material.dart';

import 'note_screen.dart';


class ListViewNote extends StatefulWidget {
  @override
  _ListViewNoteState createState() => new _ListViewNoteState();
}

final notesReference = FirebaseDatabase.instance.reference().child('notes');
/*
To get main reference, we need to do is get access to static field in FirebaseDatabase
class. If we wanna access more specific child of our database, just use child() method
 */
class _ListViewNoteState extends State<ListViewNote> {
  List<Note> items;
  StreamSubscription<Event> _onNoteAddedSubscription;
  StreamSubscription<Event> _onNoteChangedSubscription;
/*
A subscription on events from a [Stream].
When you listen on a [Stream] using [Stream.listen], a [StreamSubscription] object is returned.
The subscription provides events to the listener, and holds the callbacks used to handle the events.
 The subscription can also be used to temporarily pause the events from the stream.
 */
  @override
  void initState() {
    super.initState();

    items = new List();

    _onNoteAddedSubscription = notesReference.onChildAdded.listen(_onNoteAdded);
    _onNoteChangedSubscription = notesReference.onChildChanged.listen(_onNoteUpdated);
  }

  @override
  void dispose() {
    _onNoteAddedSubscription.cancel();
    _onNoteChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Firebase DB Demo'),
          centerTitle: true,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(20.0),
              itemBuilder: (context, position) {
                return  Column(
                    children: <Widget>[
                      Divider(height: 5.0),
                      ListTile(
                        title: Text(
                          '${items[position].title}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        subtitle: Text(
                          '${items[position].description}',
                          style: new TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        leading:   IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => _deleteNote(context, items[position], position)),

                        onTap: () => _navigateToNote(context, items[position]),
                      ),
                    ],
                  );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewNote(context),
        )
    );
  }

  void _onNoteAdded(Event event) {
    setState(() {
      items.add(new Note.fromSnapshot(event.snapshot));//Instance of 'DataSnapshot'
      print(event.snapshot);
    });
  }

  void _onNoteUpdated(Event event) {
    var oldNoteValue = items.singleWhere((note) => note.id == event.snapshot.key);
    /*
    Returns the single element that satisfies [test].
Cheecks elements to see if test(element) returns true.
 If exactly on element satisfies [test], that element is returned.
 If more than one matching element is found, throws [StateError].
  If no matching element is found, returns the result of [orElse].
  If [orElse] is omitted, it defaults to throwing a [StateError].
     */
    setState(() {
      items[items.indexOf(oldNoteValue)] = new Note.fromSnapshot(event.snapshot);//return note changed to update it
    });
  }

  void _deleteNote(BuildContext context, Note note, int position) async {
    await notesReference.child(note.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToNote(BuildContext context, Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note)),
    );
  }

  void _createNewNote(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(Note(null, '', ''))),
    );
  }
}
