import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_state.dart';
import '../../data/comment_data_source.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentDataSource _dataSource = CommentDataSource();
  final int lessonId;

  CommentCubit(this.lessonId) : super(CommentInitial());

  Future<void> fetchComments() async {
    emit(CommentLoading());
    try {
      final comments = await _dataSource.getComments(lessonId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> postComment(String content, {int? parentId}) async {
    final currentState = state;
    try {
      if (currentState is CommentLoaded) {
        emit(CommentLoading());
      }

      await _dataSource.addComment(
        lessonId: lessonId,
        content: content,
        parentId: parentId,
      );

      await fetchComments();
    } catch (e) {
      emit(CommentError(e.toString()));
      if (currentState is CommentLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> fetchReplies(int commentId) async {
    final currentState = state;
    if (currentState is CommentLoaded) {
      try {
        final replies = await _dataSource.getReplies(commentId);

        final updatedComments = currentState.comments.map((comment) {
          if (comment.id == commentId) {
            return comment.copyWith(replies: replies);
          }
          return comment;
        }).toList();

        emit(
          CommentLoaded(
            updatedComments,
            version: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      } catch (e) {}
    }
  }
}
