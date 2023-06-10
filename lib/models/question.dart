class TriviaResponse {
  final int responseCode;
  final List<TriviaQuestion> results;

  TriviaResponse({
    required this.responseCode,
    required this.results,
  });

  factory TriviaResponse.fromJson(Map<String, dynamic> json) {
    return TriviaResponse(
      responseCode: json['response_code'],
      results: List<TriviaQuestion>.from(
          json['results'].map((result) => TriviaQuestion.fromJson(result))),
    );
  }
}

class TriviaQuestion {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  bool isAnsweredCorrectly;

  TriviaQuestion({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    this.isAnsweredCorrectly = false,
  });

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
      category: json['category'],
      type: json['type'],
      difficulty: json['difficulty'],
      question: json['question'],
      correctAnswer: json['correct_answer'],
      incorrectAnswers: List<String>.from(json['incorrect_answers']),
    );
  }
}
