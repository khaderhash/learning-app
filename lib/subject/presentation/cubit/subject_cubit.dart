import 'package:flutter_bloc/flutter_bloc.dart';
import 'subject_state.dart';
import '../../data/subject_data_source.dart';

class SubjectCubit extends Cubit<SubjectState> {
  final SubjectDataSource _dataSource = SubjectDataSource();

  SubjectCubit() : super(SubjectInitial());

  Future<void> fetchSubjects() async {
    emit(SubjectLoading());
    try {
      final subjects = await _dataSource.getSubjects();
      emit(SubjectLoaded(subjects));
    } catch (e) {
      emit(SubjectError(e.toString()));
    }
  }
}
