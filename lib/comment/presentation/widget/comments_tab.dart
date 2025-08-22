import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/comment_model.dart';
import '../cubit/comment_cubit.dart';
import '../cubit/comment_state.dart';

class CommentsTab extends StatefulWidget {
  final int lessonId;
  const CommentsTab({Key? key, required this.lessonId}) : super(key: key);

  @override
  _CommentsTabState createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? _replyingToCommentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentCubit(widget.lessonId)..fetchComments(),
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<CommentCubit, CommentState>(
              listener: (context, state) {
                if (state is CommentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CommentLoading && state is! CommentLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CommentLoaded) {
                  if (state.comments.isEmpty) {
                    return const Center(
                      child: Text('Be the first to comment!'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) {
                      final comment = state.comments[index];
                      return _buildCommentItem(context, comment);
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          _buildCommentInputField(),
        ],
      ),
    );
  }

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: _replyingToCommentId == null
                    ? 'Add a public comment...'
                    : 'Replying...',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          BlocBuilder<CommentCubit, CommentState>(
            builder: (context, state) {
              return IconButton(
                icon: state is CommentLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                onPressed: () {
                  final content = _commentController.text.trim();
                  if (content.isNotEmpty) {
                    context.read<CommentCubit>().postComment(
                      content,
                      parentId: _replyingToCommentId,
                    );
                    _commentController.clear();
                    _focusNode.unfocus();
                    setState(() {
                      _replyingToCommentId = null;
                    });
                  }
                },
              );
            },
          ),
          if (_replyingToCommentId != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _replyingToCommentId = null;
                  _focusNode.unfocus();
                  _commentController.clear();
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    Comment comment, {
    bool isReply = false,
  }) {
    return Card(
      margin: EdgeInsets.only(left: isReply ? 40.0 : 0, top: 8, right: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(comment.user.name.substring(0, 1).toUpperCase()),
                ),
                const SizedBox(width: 10),
                Text(
                  comment.user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.content),
            Row(
              children: [
                if (!isReply)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _replyingToCommentId = comment.id;
                        _focusNode.requestFocus();
                      });
                    },
                    child: const Text('Reply'),
                  ),
                if (!isReply &&
                    (comment.replies == null || comment.replies!.isEmpty))
                  TextButton(
                    onPressed: () {
                      context.read<CommentCubit>().fetchReplies(comment.id);
                    },
                    child: const Text('View replies'),
                  ),
              ],
            ),
            if (comment.replies != null && comment.replies!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: comment.replies!
                      .map(
                        (reply) =>
                            _buildCommentItem(context, reply, isReply: true),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
