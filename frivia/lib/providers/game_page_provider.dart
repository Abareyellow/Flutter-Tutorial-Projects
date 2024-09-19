import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GamePageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final int _maxQuestions = 10;
  final String difficultyLevel;
  int _correct = 0;
  int _incorrect = 0;

  List? questions;
  int _currentQuestionCount = 0;

  BuildContext context;
  GamePageProvider({required this.context, required this.difficultyLevel}) {
    _dio.options.baseUrl = 'https://opentdb.com/api.php';
    getQuestionsFromAPI();
  }

  Future<void> getQuestionsFromAPI() async {
    print(difficultyLevel);
    var _response = await _dio.get(
      '',
      queryParameters: {
        'amount': _maxQuestions,
        'type': 'boolean',
        'difficulty': difficultyLevel,
      },
    );

    var _data = jsonDecode(
      _response.toString(),
    );
    //print(_data);

    questions = _data["results"];
    notifyListeners();
  }

  String getCurrentQuestionText() {
    return questions![_currentQuestionCount]["question"];
  }

  void answerQuestion(String _answer) async {
    bool isCorrect =
        questions![_currentQuestionCount]["correct_answer"] == _answer;
    isCorrect ? _correct += 1 : _incorrect += 1;
    _currentQuestionCount += 1;
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          backgroundColor: isCorrect ? Colors.green : Colors.red,
          title: Icon(
            isCorrect ? Icons.check_circle : Icons.cancel_sharp,
            color: Colors.white,
          ),
        );
      },
    );
    await Future.delayed(
      const Duration(seconds: 1),
    );
    Navigator.pop(context);
    if (_currentQuestionCount == _maxQuestions) {
      endGame();
    } else {
      notifyListeners();
    }
  }

  Future<void> endGame() async {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: const Text(
            "End Game!",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          content: Text(
            "Score: $_correct/$_maxQuestions ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        );
      },
    );

    await Future.delayed(
      const Duration(seconds: 3),
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
