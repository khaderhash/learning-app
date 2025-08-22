import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final int id;
  final String title;
  final String? videoUrl;
  final String? summaryUrl;

  const Lesson({
    required this.id,
    required this.title,
    this.videoUrl,
    this.summaryUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      videoUrl: json['video_path'],
      summaryUrl: json['summary_path'],
    );
  }

  @override
  List<Object?> get props => [id, title, videoUrl, summaryUrl];
}
