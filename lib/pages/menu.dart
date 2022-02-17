import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    List<String> menuItems = ['Hiragana', 'Katakana', 'Common Words 1', 'Common Words 2'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanarama'),
      ),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(menuItems.length, (index) {
          return Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/flashcard', arguments: {
                        'menuItem': menuItems[index],
                      });
                    },
                    child: ListTile(
                      title: Center(
                        child: Text(menuItems[index],
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      // subtitle: Text('A'),
                    ),
                  ),
                ]
              ),
            ),
          );
        }),
      ),
    );
  }
}
