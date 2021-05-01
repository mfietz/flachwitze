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
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrange,
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
  String _title = 'Witze';

  @override
  void initState() {
    super.initState();
    loadJokes();
  }

  void loadJokes({String name = "witze"}) async {
    var filename = 'assets/$name.txt';
    String text = await rootBundle.loadString(filename);
    _jokes = text.split("\n");
    _refresh();
    String title = name.replaceAll('-', ' ').toTitleCase();
    setState(() {
      _title = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      backgroundColor: Colors.orange,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text('Flachwitze'),
              onTap: () {
                loadJokes();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Mutterwitze'),
              onTap: () {
                loadJokes(name: "deine-mutter");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _idx < 0
              ? CircularProgressIndicator()
              : SelectableText(
                  joke(),
                  style: TextStyle(fontSize: 48.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: _refresh,
            tooltip: 'Refresh',
            child: Icon(Icons.refresh),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _next,
            tooltip: 'Next',
            child: Icon(Icons.arrow_forward),
          ),
        ],
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
    _jokes.removeAt(idx);
  }

  void _next() {
    if (_jokes == null) {
      return;
    }
    setState(() {
      _idx++;
    });
  }
}

extension CapitalizedStringExtension on String {
  String toTitleCase() {
    if (this == null) {
      return null;
    }

    if (this.length <= 1) {
      return this.toUpperCase();
    }

    final List<String> words = this.split(' ');

    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    return capitalizedWords.join(' ');
  }
}
