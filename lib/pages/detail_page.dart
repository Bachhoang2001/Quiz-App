import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizz_app/pages/home_page.dart';
import 'package:quizz_app/pages/question_page.dart';
import 'dart:convert';

import '../models/question.dart';

class TriviaApp extends StatefulWidget {
  @override
  _TriviaAppState createState() => _TriviaAppState();
}

class _TriviaAppState extends State<TriviaApp> {
  late Future<TriviaResponse> futureTriviaResponse;
  int currentQuestionIndex = 0;
  DateTime startTime = DateTime.now();
  DateTime? endTime;
  List<TriviaQuestion> questions = [];
  int correctAnswers = 0;
  Duration totalTime = Duration();

  @override
  void initState() {
    super.initState();
    futureTriviaResponse = fetchTriviaData();
  }

  Future<TriviaResponse> fetchTriviaData() async {
    final response =
        await http.get(Uri.parse('https://opentdb.com/api.php?amount=5'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final triviaResponse = TriviaResponse.fromJson(jsonData);
      questions = triviaResponse.results;
      return triviaResponse;
    } else {
      throw Exception('Failed to fetch trivia data');
    }
  }

  Duration getQuizDuration() {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return Duration.zero;
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      startTime = DateTime.now();
      endTime = null;
      correctAnswers = 0;
    });
  }

  void goToNextQuestion() {
    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(66, 33, 124, 243),
      body: FutureBuilder<TriviaResponse>(
        future: futureTriviaResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (currentQuestionIndex >= questions.length) {
              endTime = DateTime.now();
              totalTime = endTime!.difference(startTime);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 100,
                      color: Color.fromARGB(255, 235, 135, 77),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Quiz Completed',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Time taken: ${totalTime.inSeconds} seconds',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Correct Answers: $correctAnswers/${questions.length}',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return (MyHomePage(title: ''));
                        }));
                      },
                      child: Text(
                        'Play Again',
                        style: TextStyle(
                            color: Color.fromARGB(255, 243, 187, 104)),
                      ),
                    ),
                  ],
                ),
              );
            }

            final currentQuestion = questions[currentQuestionIndex];

            return QuestionScreen(
              question: currentQuestion,
              questionIndex: currentQuestionIndex + 1,
              totalQuestions: questions.length,
              onNextQuestion: goToNextQuestion,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return Center(
            child: CircularProgressIndicator(
                color: Color.fromARGB(255, 243, 187, 104)),
          );
        },
      ),
    );
  }
}
