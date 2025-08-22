import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../quiz/data/quiz_models.dart';
import '../cubit/browse_questions_cubit.dart';
import '../cubit/browse_questions_state.dart';

class BrowseQuestionsScreen extends StatelessWidget {
  final int lessonId;
  final String lessonTitle;

  const BrowseQuestionsScreen({
    Key? key,
    required this.lessonId,
    required this.lessonTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Questions'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              lessonTitle,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => BrowseQuestionsCubit()..fetchQuestions(lessonId),
        child: BlocBuilder<BrowseQuestionsCubit, BrowseQuestionsState>(
          builder: (context, state) {
            if (state is BrowseQuestionsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BrowseQuestionsLoaded) {
              if (state.questions.isEmpty) {
                return const Center(
                  child: Text(
                    'No questions available for browsing in this lesson.',
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionCard(
                    context,
                    state.questions[index],
                    index + 1,
                  );
                },
              );
            }
            if (state is BrowseQuestionsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    Question question,
    int questionNumber,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q$questionNumber: ${question.questionText}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            ...question.options.map((option) => _buildOptionTile(option)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(Option option) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: option.isCorrect
            ? Colors.green.withOpacity(0.2)
            : Colors.grey.withOpacity(0.1),
        border: Border.all(
          color: option.isCorrect ? Colors.green : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            option.isCorrect
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: option.isCorrect ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(option.optionText)),
        ],
      ),
    );
  }
}
