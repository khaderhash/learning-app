import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../subject/data/subject_data_source.dart';
import '../../../subject/data/subject_model.dart';

abstract class CustomTestBuilderState extends Equatable {
  @override
  List<Object> get props => [];
}

class CustomTestBuilderInitial extends CustomTestBuilderState {}

class CustomTestBuilderLoading extends CustomTestBuilderState {}

class CustomTestBuilderLoaded extends CustomTestBuilderState {
  final List<Subject> subjects;
  CustomTestBuilderLoaded(this.subjects);
  @override
  List<Object> get props => [subjects];
}

class CustomTestBuilderError extends CustomTestBuilderState {
  final String message;
  CustomTestBuilderError(this.message);
}

class CustomTestBuilderCubit extends Cubit<CustomTestBuilderState> {
  final SubjectDataSource _subjectDataSource = SubjectDataSource();

  CustomTestBuilderCubit() : super(CustomTestBuilderInitial());

  Future<void> loadSubjects() async {
    emit(CustomTestBuilderLoading());
    try {
      final subjects = await _subjectDataSource.getSubjects();
      emit(CustomTestBuilderLoaded(subjects));
    } catch (e) {
      emit(CustomTestBuilderError(e.toString()));
    }
  }
}
