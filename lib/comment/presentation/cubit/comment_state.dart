import 'package:equatable/equatable.dart';
import '../../data/comment_model.dart';

abstract class CommentState extends Equatable {
  const CommentState();
  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Comment> comments;
  final int version;
  const CommentLoaded(this.comments, {this.version = 0});
  @override
  List<Object> get props => [comments, version];
}

class CommentError extends CommentState {
  final String message;
  const CommentError(this.message);
}
