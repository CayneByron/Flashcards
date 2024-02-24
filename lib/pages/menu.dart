import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    List<String> menuItems = ['Hiragana', 'Katakana', 'Common Words 1', 'Common Words 2', 'Common Words 3'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanarama'),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/flashcard', arguments: {
                'menuItem': menuItems[index],
              });
            },
            child: Card(
              child: SizedBox(
                height: 85.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.translate,
                        size: 35.0,
                        // color: primaryBlue,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('TRANSLATE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(menuItems[index],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 28.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      // body: GridView.count(
      //   crossAxisCount: 2,
      //   children: List.generate(menuItems.length, (index) {
      //     return Center(
      //       child: Card(
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: <Widget>[
      //             GestureDetector(
      //               onTap: () {
      //                 Navigator.pushNamed(context, '/flashcard', arguments: {
      //                   'menuItem': menuItems[index],
      //                 });
      //               },
      //               child: ListTile(
      //                 title: Center(
      //                   child: Text(menuItems[index],
      //                     style: Theme.of(context).textTheme.headline5,
      //                   ),
      //                 ),
      //                 // subtitle: Text('A'),
      //               ),
      //             ),
      //           ]
      //         ),
      //       ),
      //     );
      //   }),
      // ),
    );
  }
}
