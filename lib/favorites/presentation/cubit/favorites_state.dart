import 'package:equatable/equatable.dart';
import '../../../teachers/data/teacher_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Teacher> teachers;
  const FavoritesLoaded(this.teachers);
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
}
