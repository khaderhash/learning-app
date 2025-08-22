import 'package:equatable/equatable.dart';

class Teacher extends Equatable {
  final int id;
  final String name;
  final String? profileImageUrl;

  const Teacher({required this.id, required this.name, this.profileImageUrl});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      profileImageUrl: json['teacher_image'],
    );
  }

  @override
  List<Object?> get props => [id, name, profileImageUrl];
}
