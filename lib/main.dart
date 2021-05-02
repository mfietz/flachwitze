import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void loadJokes({String name = 'scherzfragen'}) async {
    var filename = 'assets/$name.txt';
    String text = await rootBundle.loadString(filename);
    _jokes = text.split('\n');
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
        child: Column(
          children: [
            Expanded(
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
                      loadJokes(name: 'deine-mutter');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Chuck Norris Witze'),
                    onTap: () {
                      loadJokes(name: 'chuck-norris');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Sprüche'),
                    onTap: () {
                      loadJokes(name: 'sprueche');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Gespräche'),
                    onTap: () {
                      loadJokes(name: 'gespraeche');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Namenswitze'),
                    onTap: () {
                      loadJokes(name: 'namen');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Anti-Witze'),
                    onTap: () {
                      loadJokes(name: 'anti');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            _madeWithFlutter(),
            _hostedOnGithub(),
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

  Widget _madeWithFlutter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: 'Made with '),
            TextSpan(
              children: [
                TextSpan(
                  text: 'Flutter',
                  style: new TextStyle(color: Colors.blue),
                  mouseCursor: SystemMouseCursors.click,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch('https://flutter.dev');
                    },
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(
                      Icons.open_in_new,
                      size: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String nextJoke() {
    if (_idx >= _jokes.length) {
      return '[Wähle eine andere Kategorie].';
    }
    var joke = _jokes[_idx];
    joke = joke.replaceAll(' - ', '{j\n').replaceAll('. ', '.\n').replaceAll('? ', '?\n');
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

  Widget _hostedOnGithub() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: 'Hosted on '),
            TextSpan(
              children: [
                TextSpan(
                  text: 'Github',
                  style: new TextStyle(color: Colors.blue),
                  mouseCursor: SystemMouseCursors.click,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch('https://github.com/mfietz/flachwitze');
                    },
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(
                      Icons.open_in_new,
                      size: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
