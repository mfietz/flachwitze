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
  String _title = 'Scherzfragen';
  String _joke;

  @override
  void initState() {
    super.initState();
    loadJokes();
  }

  void loadJokes({String name = "scherzfragen"}) async {
    var filename = 'assets/$name.txt';
    String text = await rootBundle.loadString(filename);
    _jokes = text.split("\n");
    String title = name.replaceAll('-', ' ').toTitleCase();
    setState(() {
      _title = title;
    });
    _randomJoke();
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
              title: Text('Scherzfragen'),
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
            ListTile(
              title: Text('Chuck Norris Witze'),
              onTap: () {
                loadJokes(name: "chuck-norris");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Sprüche'),
              onTap: () {
                loadJokes(name: "sprueche");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Gespräche'),
              onTap: () {
                loadJokes(name: "gespraeche");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Namenswitze'),
              onTap: () {
                loadJokes(name: "namen");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Anti-Witze'),
              onTap: () {
                loadJokes(name: "anti");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _joke == null
              ? CircularProgressIndicator()
              : SelectableText(
                  _joke,
                  style: TextStyle(fontSize: 48.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: _randomJoke,
            tooltip: 'Random',
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

  String nextJoke() {
    if (_idx >= _jokes.length) {
      return "[Wähle eine andere Kategorie].";
    }
    var joke = _jokes[_idx];
    joke = joke.replaceAll(" - ", "{j\n").replaceAll(". ", ".\n").replaceAll("? ", "?\n");
    _jokes.removeAt(_idx);
    return joke;
  }

  void _randomJoke() {
    int idx = widget.random.nextInt(_jokes.length);
    setState(() {
      _idx = min(idx, _jokes.length - 1);
      _joke = nextJoke();
    });
  }

  void _next() {
    setState(() {
      _joke = nextJoke();
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
