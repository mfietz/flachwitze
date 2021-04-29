import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flachwitze',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  final Random random = Random();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> _jokes;
  int _idx = -1;

  @override
  void initState() {
    super.initState();
    loadJokes();
  }

  void loadJokes() async {
    String text = await rootBundle.loadString('assets/witze.txt');
    _jokes = text.split("\n");
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade300,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _idx < 0
              ? CircularProgressIndicator()
              : Text(
                  joke(),
                  style: TextStyle(fontSize: 48.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }

  String joke() {
    var joke = _jokes[_idx];
    return joke.replaceAll(" - ", "\n").replaceAll(". ", ".\n").replaceAll("? ", "?\n");
  }

  void _refresh() {
    if (_jokes == null) {
      return;
    }
    int idx = widget.random.nextInt(_jokes.length);
    setState(() {
      _idx = idx;
    });
  }
}
