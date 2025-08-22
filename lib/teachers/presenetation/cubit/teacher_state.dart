import 'package:equatable/equatable.dart';
import '../../data/teacher_model.dart';

abstract class TeacherState extends Equatable {
  const TeacherState();
  @override
  List<Object> get props => [];
}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherLoaded extends TeacherState {
  final List<Teacher> teachers;
  const TeacherLoaded(this.teachers);
  @override
  List<Object> get props => [teachers];
}

class TeacherError extends TeacherState {
  final String message;
  const TeacherError(this.message);
  @override
  List<Object> get props => [message];
}
