import 'package:equatable/equatable.dart';

import '../../data/test_history_model.dart';

abstract class TestHistoryState extends Equatable {
  const TestHistoryState();
  @override
  List<Object> get props => [];
}

class TestHistoryInitial extends TestHistoryState {}

class TestHistoryLoading extends TestHistoryState {}

class TestHistoryLoaded extends TestHistoryState {
  final List<TestHistory> tests;
  const TestHistoryLoaded(this.tests);
}

class TestHistoryError extends TestHistoryState {
  final String message;
  const TestHistoryError(this.message);
}
