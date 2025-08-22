import 'package:flutter_bloc/flutter_bloc.dart';
import 'browse_questions_state.dart';
import '../../data/question_data_source.dart';

class BrowseQuestionsCubit extends Cubit<BrowseQuestionsState> {
  final QuestionDataSource _dataSource = QuestionDataSource();

  BrowseQuestionsCubit() : super(BrowseQuestionsInitial());

  Future<void> fetchQuestions(int lessonId) async {
    emit(BrowseQuestionsLoading());
    try {
      final questions = await _dataSource.getBrowseableQuestions(lessonId);
      emit(BrowseQuestionsLoaded(questions));
    } catch (e) {
      emit(BrowseQuestionsError(e.toString()));
    }
  }
}
