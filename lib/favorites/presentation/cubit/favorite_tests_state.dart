import 'package:equatable/equatable.dart';
import '../../../quiz/data/quiz_models.dart';

abstract class FavoriteTestsState extends Equatable {
  const FavoriteTestsState();
  @override
  List<Object> get props => [];
}

class FavoriteTestsInitial extends FavoriteTestsState {}

class FavoriteTestsLoading extends FavoriteTestsState {}

class FavoriteTestsLoaded extends FavoriteTestsState {
  final List<TestSession> tests;
  const FavoriteTestsLoaded(this.tests);
}

class FavoriteTestsError extends FavoriteTestsState {
  final String message;
  const FavoriteTestsError(this.message);
}
