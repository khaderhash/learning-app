import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../subject/data/subject_data_source.dart';
import 'teacher_state.dart';
import '../../data/teacher_data_source.dart';

class TeacherCubit extends Cubit<TeacherState> {
  final TeacherDataSource _dataSource = TeacherDataSource();
  final SubjectDataSource _subjectDataSource = SubjectDataSource();

  TeacherCubit() : super(TeacherInitial());

  Future<void> fetchTeachers(int subjectId) async {
    emit(TeacherLoading());
    try {
      final teachers = await _dataSource.getTeachersForSubject(subjectId);
      emit(TeacherLoaded(teachers));
    } catch (e) {
      emit(TeacherError(e.toString()));
    }
  }

  Future<String> requestToJoin(int subjectId, int teacherId) async {
    try {
      final message = await _subjectDataSource.requestToJoinSubject(
        subjectId,
        teacherId,
      );
      return message;
    } catch (e) {
      rethrow;
    }
  }
}
