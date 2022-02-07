import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:typed_data';
import 'dart:async';

class Flashcard extends StatefulWidget {
  const Flashcard({Key? key}) : super(key: key);

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  Map widgetData = {};
  String menuItem = '';
  bool hasData = false;
  bool hasAnswer = false;
  bool isCorrect = false;
  String currentText = '';
  String currentQuestion = '?';
  String currentAnswer = '?';
  int currentIndex = 0;
  dynamic data;
  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // loadAll();
  }

  void loadAll() async {
    print('LOAD ALL');
    print(menuItem);
    if (menuItem.isNotEmpty) {
      String loadedData = await DefaultAssetBundle.of(context).loadString("assets/${menuItem.toLowerCase()}.json");
      final jsonData = jsonDecode(loadedData);
      Random random = Random();
      int nextInt = random.nextInt(jsonData.length - 1);
      setState(() {
        data = jsonData;
        currentQuestion = jsonData[nextInt]['kana'];
        currentAnswer = jsonData[nextInt]['roumaji'];
        hasData = true;
        hasAnswer = false;
        isCorrect = false;
        currentIndex = nextInt;
      });
    }

  }

  void submit(String answer, String submittedAnswer) {
      submittedAnswer = submittedAnswer.toUpperCase();
      if (submittedAnswer == answer.toUpperCase()) {
        isCorrect = true;
      }
      setState(() {
        hasAnswer = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    widgetData = widgetData.isNotEmpty ? widgetData : ModalRoute.of(context)?.settings.arguments as Map;
    menuItem = widgetData['menuItem'];
    TextEditingController answerController = TextEditingController();
    String question = currentQuestion;
    String answer = currentAnswer;
    answerController.text = currentText;
    answerController.selection = TextSelection.fromPosition(TextPosition(offset: answerController.text.length));
    if (hasData) {
      FocusScope.of(context).requestFocus(focus);
    } else {
      loadAll();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(menuItem),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Visibility(
                visible: hasData,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        // leading: Icon(Icons.translate),
                        title: Center(
                          child: Text(question,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 64.0,
                            ),
                          ),
                        ),
                        // subtitle: Text('A'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                                onSubmitted: (String s) {
                                  submit(answer, answerController.text);
                                },
                                textCapitalization: TextCapitalization.characters,
                                onChanged: (String s) {
                                  setState(() {
                                    currentText = answerController.text.toUpperCase();
                                  });
                                },
                                textAlign: TextAlign.center,
                                controller: answerController,
                                autofocus: true,
                                focusNode: focus,
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                      Visibility(
                        visible: hasAnswer,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(answer.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: (isCorrect == true) ? Colors.green : Colors.red,
                                fontSize: 32.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Visibility(
                            visible: !hasAnswer,
                            child: TextButton(
                              child: const Text('SKIP'),
                              onPressed: () {/* ... */},
                            ),
                          ),
                          const SizedBox(width: 8),
                          Visibility(
                            visible: !hasAnswer,
                            child: TextButton(
                              child: const Text('SUBMIT'),
                              onPressed: answerController.text == '' ? null : () {
                                submit(answer, answerController.text);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Visibility(
                            visible: hasAnswer,
                            child: TextButton(
                              child: const Text('NEXT'),
                              onPressed: () {
                                Random random = Random();
                                int nextInt = -1;
                                while (true) {
                                  nextInt = random.nextInt(data.length - 1);
                                  if (nextInt != currentIndex) {
                                    break;
                                  }
                                }
                                setState(() {
                                  hasAnswer = false;
                                  isCorrect = false;
                                  currentQuestion = data[nextInt]['kana'];
                                  currentAnswer = data[nextInt]['roumaji'];
                                  currentText = '';
                                  currentIndex = nextInt;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !hasData,
                child: const Padding(
                    padding: EdgeInsets.only(right: 20.0, top: 16),
                    child: SpinKitFadingCube(
                      color: Colors.black,
                      size: 20.0,
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


