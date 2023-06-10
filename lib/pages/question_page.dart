import 'package:flutter/material.dart';

import '../models/question.dart';

class QuestionScreen extends StatefulWidget {
  final TriviaQuestion question;
  final int questionIndex;
  final int totalQuestions;
  final VoidCallback onNextQuestion;

  QuestionScreen({
    required this.question,
    required this.questionIndex,
    required this.totalQuestions,
    required this.onNextQuestion,
  });

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  String? selectedAnswer;
  bool showCorrectAnswer = false;
  bool answered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Question ${widget.questionIndex}/${widget.totalQuestions}',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 20.0),
          Text(
            widget.question.question,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.0),
          ..._buildAnswerButtons(),
          SizedBox(height: 40.0),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showCorrectAnswer = true;
                answered = true;
              });
            },
            child: Text(
              'Check Answer',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: answered ? widget.onNextQuestion : null,
            child: Text(
              'Next',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnswerButtons() {
    final answers = [
      ...widget.question.incorrectAnswers,
      widget.question.correctAnswer
    ];
    return answers.map((answer) {
      final isSelected = selectedAnswer == answer;
      final isCorrect =
          showCorrectAnswer && answer == widget.question.correctAnswer;

      return Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              if (!answered) {
                selectedAnswer = answer;
              }
            });
          },
          style: ElevatedButton.styleFrom(
            primary:
                isSelected ? const Color.fromARGB(255, 66, 157, 231) : null,
          ),
          child: Text(
            answer,
            style: TextStyle(
              color: isSelected && showCorrectAnswer
                  ? (isCorrect ? Colors.green : Colors.red)
                  : Colors.black,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    resetState();
  }

  void resetState() {
    selectedAnswer = null;
    showCorrectAnswer = false;
    answered = false;
  }

  @override
  void didUpdateWidget(QuestionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    resetState();
  }
}
