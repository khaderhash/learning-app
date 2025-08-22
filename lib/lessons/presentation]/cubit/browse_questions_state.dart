import 'package:equatable/equatable.dart';
import '../../../quiz/data/quiz_models.dart';

abstract class BrowseQuestionsState extends Equatable {
  const BrowseQuestionsState();
  @override
  List<Object> get props => [];
}

class BrowseQuestionsInitial extends BrowseQuestionsState {}

class BrowseQuestionsLoading extends BrowseQuestionsState {}

class BrowseQuestionsLoaded extends BrowseQuestionsState {
  final List<Question> questions;
  const BrowseQuestionsLoaded(this.questions);
}

class BrowseQuestionsError extends BrowseQuestionsState {
  final String message;
  const BrowseQuestionsError(this.message);
}
