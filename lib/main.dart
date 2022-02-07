import 'package:flutter/material.dart';
import 'package:flashcards/pages/flashcard.dart';
import 'package:flashcards/pages/menu.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  onGenerateRoute: (settings) {

  },
  routes: {
    '/': (context) => Menu(),
    '/flashcard': (context) => Flashcard()
  },
));