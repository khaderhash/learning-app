import 'package:flutter_bloc/flutter_bloc.dart';
import 'test_history_state.dart';
import '../../data/quiz_data_source.dart';

class TestHistoryCubit extends Cubit<TestHistoryState> {
  final QuizDataSource _dataSource = QuizDataSource();

  TestHistoryCubit() : super(TestHistoryInitial());

  Future<void> fetchTestHistory() async {
    emit(TestHistoryLoading());
    try {
      final tests = await _dataSource.getUserTests();
      emit(TestHistoryLoaded(tests));
    } catch (e) {
      emit(TestHistoryError(e.toString()));
    }
  }
}
