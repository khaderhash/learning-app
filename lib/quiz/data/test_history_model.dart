import 'package:equatable/equatable.dart';

class TestHistory extends Equatable {
  final int testId;
  final int subjectId;
  final bool isFavorite;

  const TestHistory({
    required this.testId,
    required this.subjectId,
    required this.isFavorite,
  });

  factory TestHistory.fromJson(Map<String, dynamic> json) {
    return TestHistory(
      testId: json['test_id'],
      subjectId: json['subject_id'],
      isFavorite: json['is_favorite'] == 1,
    );
  }

  @override
  List<Object?> get props => [testId];
}
