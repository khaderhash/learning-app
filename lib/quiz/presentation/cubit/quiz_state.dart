import 'package:equatable/equatable.dart';
import '../../data/quiz_models.dart';

abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizReady extends QuizState {
  final TestSession testSession;
  const QuizReady(this.testSession);
}

class QuizSubmitting extends QuizState {}

class QuizFinished extends QuizState {
  final Map<String, int> result;
  const QuizFinished(this.result);
}

class QuizError extends QuizState {
  final String message;
  const QuizError(this.message);
}
