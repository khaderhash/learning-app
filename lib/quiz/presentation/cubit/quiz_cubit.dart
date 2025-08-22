import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/quiz_models.dart';
import 'quiz_state.dart';
import '../../data/quiz_data_source.dart';

class QuizCubit extends Cubit<QuizState> {
  final QuizDataSource _dataSource = QuizDataSource();

  QuizCubit() : super(QuizInitial());

  void startExistingTest(TestSession testSession) {
    emit(QuizReady(testSession));
  }

  Future<void> startTest({required int lessonId, int count = 10}) async {
    emit(QuizLoading());
    try {
      final testSession = await _dataSource.createTest(lessonId, count);
      if (testSession.questions.isEmpty) {
        emit(const QuizError('No questions found for this lesson.'));
      } else {
        emit(QuizReady(testSession));
      }
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  Future<void> submitTest({
    required int testId,
    required Map<int, int> answers,
  }) async {
    emit(QuizSubmitting());
    try {
      final result = await _dataSource.submitAnswers(testId, answers);
      emit(QuizFinished(result));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }
}
