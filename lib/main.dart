import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = new ThemeData(
      primaryColor: Colors.blueGrey,
    );

    return new MaterialApp(
      title: 'Flutter App by Hong Xiao',
      //theme: new ThemeData.dark(),
      theme: themeData,
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    final iconList =
        new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[iconList],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    final route = new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        final text = new Text(pair.asPascalCase, style: _biggerFont);
        return new ListTile(title: text);
      });

      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return new Scaffold(
        appBar: new AppBar(title: new Text('Saved Suggestions')),
        body: new ListView(children: divided),
      );
    });

    Navigator.of(context).push(route);
  }

  Widget _buildSuggestions() {
    final listView = new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          final index = i;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });

    return listView;
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    final listTile = new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.orange : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );

    return listTile;
  }
}
