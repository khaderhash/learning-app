import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_state.dart';
import '../../data/favorites_data_source.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesDataSource _dataSource = FavoritesDataSource();

  FavoritesCubit() : super(FavoritesInitial());

  Future<void> fetchFavoriteTeachers() async {
    emit(FavoritesLoading());
    try {
      final teachers = await _dataSource.getFavoriteTeachers();
      emit(FavoritesLoaded(teachers));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
