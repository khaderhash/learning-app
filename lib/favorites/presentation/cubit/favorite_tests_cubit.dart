import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorite_tests_state.dart';
import '../../data/favorites_data_source.dart';

class FavoriteTestsCubit extends Cubit<FavoriteTestsState> {
  final FavoritesDataSource _dataSource = FavoritesDataSource();

  FavoriteTestsCubit() : super(FavoriteTestsInitial());

  Future<void> fetchFavoriteTests(int teacherId) async {
    emit(FavoriteTestsLoading());
    try {
      final tests = await _dataSource.getFavoriteTests(teacherId);
      emit(FavoriteTestsLoaded(tests));
    } catch (e) {
      emit(FavoriteTestsError(e.toString()));
    }
  }
}
