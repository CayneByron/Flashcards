import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  bool hasMeaning = false;
  String currentText = '';
  String currentQuestion = '?';
  String questionKey = '';
  String currentAnswer = '?';
  String answerKey = '';
  String currentMeaning = '';
  int currentIndex = 0;
  String assetName = '';
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
    if (menuItem.isNotEmpty) {
      assetName = menuItem.toLowerCase();
      assetName = assetName.replaceAll(' ', '_');
      String loadedData = await DefaultAssetBundle.of(context).loadString("assets/$assetName.json");
      final jsonData = jsonDecode(loadedData);

      if (assetName == 'hiragana' || assetName == 'katakana') {
        questionKey = 'kana';
      } else if (assetName.contains('common_words')) {
        hasMeaning = true;
        questionKey = 'word';
      } else if (assetName == 'kanji') {
        hasMeaning = true;
        questionKey = 'kanji';
      }

      answerKey = 'roumaji';
      Random random = Random();
      int nextInt = random.nextInt(jsonData.length - 1);
      setState(() {
        data = jsonData;
        currentQuestion = jsonData[nextInt][questionKey];
        currentAnswer = jsonData[nextInt][answerKey];
        currentMeaning = hasMeaning ? jsonData[nextInt]['meaning'] : '';
        hasData = true;
        hasAnswer = false;
        isCorrect = false;
        currentIndex = nextInt;
      });
    }
  }

  void submit(String answer, String submittedAnswer) {
      String submittedAnswerUpper = submittedAnswer.toUpperCase();
      if (submittedAnswerUpper == answer.toUpperCase()) {
        isCorrect = true;
      }
      setState(() {
        hasAnswer = true;
        currentText = submittedAnswer;
      });
  }

  void next() {
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
      currentQuestion = data[nextInt][questionKey];
      currentAnswer = data[nextInt]['roumaji'];
      currentMeaning = hasMeaning ? data[nextInt]['meaning'] : '';
      currentText = '';
      currentIndex = nextInt;
    });
  }

  @override
  Widget build(BuildContext context) {
    widgetData = widgetData.isNotEmpty ? widgetData : ModalRoute.of(context)?.settings.arguments as Map;
    menuItem = widgetData['menuItem'];
    TextEditingController answerController = TextEditingController();
    String question = currentQuestion;
    String answer = currentAnswer;
    String meaning = currentMeaning;
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
                                  // setState(() {
                                  //   currentText = answerController.text.toUpperCase();
                                  // });
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
                        child: Column(
                          children: [
                            Row(
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
                            Visibility(
                              visible: hasMeaning,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Meaning: $meaning',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blue,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
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
                              onPressed: () {
                                next();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Visibility(
                            visible: !hasAnswer,
                            child: TextButton(
                              child: const Text('SUBMIT'),
                              onPressed: () {
                                if (answerController.text.isEmpty) return;
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
                                next();
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


