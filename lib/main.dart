import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(WordPairsApp());
}

class WordPairsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WordPairsGenerator(),
    );
  }
}

class WordPairsGenerator extends StatefulWidget {
  @override
  WordPairsGeneratorState createState() => WordPairsGeneratorState();
}

class WordPairsGeneratorState extends State<WordPairsGenerator> {
  final _suggested = <WordPair>[];
  final _saved = <WordPair>[];
  final _bigFont = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WordPairs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: suggestedList(),
    );
  }

  Widget suggestedList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();

        final index = i ~/ 2;

        if (index >= _suggested.length) {
          _suggested.addAll(generateWordPairs().take(10));
        }

        return suggestedItems(_suggested[index]);
      },
    );
  }

  Widget suggestedItems(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _bigFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? "Removed from saved" : "Save",
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
  }


  void _pushSaved() {

    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) {
            final titles = _saved.map(
                (pair){
                  return ListTile(
                    title: Text(
                      pair.asPascalCase,
                      style: _bigFont,
                    ),
                  );
                },
            );
            final divided = titles.isNotEmpty
                ? ListTile.divideTiles(
              context: context,
              tiles: titles,
            ).toList()
                : <Widget>[];

            return Scaffold(
              appBar: AppBar(
                title: const Text("Saved Suggestions"),
              ),
              body: ListView(children: divided),
            );
          },
      )
    );
  }


}
