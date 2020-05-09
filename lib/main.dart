import 'package:firebasedatabasedemo/ui/listview_note.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Returning Data',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: ListViewNote(),
    );
  }
}
