import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flachwitze',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({super.key});

  final Random random = Random();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<String> _jokes;
  int _idx = -1;
  String _title = 'Scherzfragen';
  String? _joke;

  @override
  void initState() {
    super.initState();
    loadJokes();
  }

  void loadJokes({String name = 'scherzfragen'}) async {
    var filename = 'assets/$name.txt';
    String contents = await rootBundle.loadString(filename);
    _jokes = contents.split('\n').where((text) => text.isNotEmpty).toList();
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
        elevation: 8.0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    title: const Text('Scherzfragen'),
                    onTap: () {
                      loadJokes();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Mutterwitze'),
                    onTap: () {
                      loadJokes(name: 'deine-mutter');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Chuck Norris Witze'),
                    onTap: () {
                      loadJokes(name: 'chuck-norris');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Sprüche'),
                    onTap: () {
                      loadJokes(name: 'sprueche');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Gespräche'),
                    onTap: () {
                      loadJokes(name: 'gespraeche');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Namenswitze'),
                    onTap: () {
                      loadJokes(name: 'namen');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Anti-Witze'),
                    onTap: () {
                      loadJokes(name: 'anti');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Verabschiedungen'),
                    onTap: () {
                      loadJokes(name: 'verabschiedungen');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('NSFW'),
                    onTap: () {
                      loadJokes(name: 'scherzfragen-nsfw');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Sich betrinken'),
                    onTap: () {
                      loadJokes(name: 'betrinken');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _joke == null
              ? const CircularProgressIndicator()
              : SelectableText(
                  _joke!,
                  style: const TextStyle(fontSize: 48.0),
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
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _next,
            tooltip: 'Next',
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  String nextJoke() {
    if (_idx >= _jokes.length) {
      return '[Wähle eine andere Kategorie].';
    }
    var joke = _jokes[_idx];
    joke = joke
        .replaceAll(' - ', '\n')
        .replaceAll('. ', '.\n')
        .replaceAll('? ', '?\n');
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
    if (length <= 1) {
      return toUpperCase();
    }

    final List<String> words = split(' ');

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
