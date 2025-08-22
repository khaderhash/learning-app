import 'package:equatable/equatable.dart';

class CommentUser extends Equatable {
  final String name;
  final String? imageUrl;
  const CommentUser({required this.name, this.imageUrl});

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(name: json['name'], imageUrl: json['user_image']);
  }
  @override
  List<Object?> get props => [name, imageUrl];
}

class Comment extends Equatable {
  final int id;
  final String content;
  final CommentUser user;
  final String createdAt;
  final List<Comment>? replies;

  const Comment({
    required this.id,
    required this.content,
    required this.user,
    required this.createdAt,
    this.replies,
  });

  Comment copyWith({List<Comment>? replies}) {
    return Comment(
      id: id,
      content: content,
      user: user,
      createdAt: createdAt,
      replies: replies ?? this.replies,
    );
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      user: CommentUser.fromJson(json['user']),
      createdAt: json['created_at'],
    );
  }

  @override
  List<Object?> get props => [id];
}
