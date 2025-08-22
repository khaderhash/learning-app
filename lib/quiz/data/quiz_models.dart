import 'package:equatable/equatable.dart';

class Option extends Equatable {
  final int id;
  final String optionText;
  final bool isCorrect;
  const Option({
    required this.id,
    required this.optionText,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      optionText: json['option_text'],
      isCorrect: json['is_correct'] == 1,
    );
  }

  @override
  List<Object?> get props => [id, isCorrect];
}

class Question extends Equatable {
  final int id;
  final String questionText;
  final List<Option> options;

  const Question({
    required this.id,
    required this.questionText,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var optionsList = json['options'] as List;
    List<Option> parsedOptions = optionsList
        .map((i) => Option.fromJson(i))
        .toList();

    return Question(
      id: json['id'],
      questionText: json['question_text'],
      options: parsedOptions,
    );
  }

  @override
  List<Object?> get props => [id];
}

class TestSession extends Equatable {
  final int testId;
  final List<Question> questions;

  const TestSession({required this.testId, required this.questions});

  @override
  List<Object?> get props => [testId];
}
