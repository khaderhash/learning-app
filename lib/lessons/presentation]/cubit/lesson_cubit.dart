import 'package:flutter_bloc/flutter_bloc.dart';
import 'lesson_state.dart';
import '../../data/lesson_data_source.dart';

class LessonCubit extends Cubit<LessonState> {
  final LessonDataSource _dataSource = LessonDataSource();

  LessonCubit() : super(LessonInitial());

  Future<void> fetchLessons(int teacherId, int subjectId) async {
    emit(LessonLoading());
    try {
      final lessons = await _dataSource.getLessons(teacherId, subjectId);
      emit(LessonLoaded(lessons));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }
}
