import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../quiz/presentation/screens/quiz_screen.dart';
import '../cubit/lesson_cubit.dart';
import '../cubit/lesson_state.dart';
import 'browse_questions_screen.dart';
import 'lesson_details_screen.dart';

class LessonsScreen extends StatelessWidget {
  final int teacherId;
  final String teacherName;
  final int subjectId;
  final String subjectTitle;

  const LessonsScreen({
    Key? key,
    required this.teacherId,
    required this.teacherName,
    required this.subjectId,
    required this.subjectTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons by $teacherName'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              subjectTitle,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => LessonCubit()..fetchLessons(teacherId, subjectId),
        child: BlocBuilder<LessonCubit, LessonState>(
          builder: (context, state) {
            if (state is LessonLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LessonLoaded) {
              if (state.lessons.isEmpty) {
                return const Center(
                  child: Text(
                    'This teacher has not added any lessons for this subject yet.',
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.lessons.length,
                itemBuilder: (context, index) {
                  final lesson = state.lessons[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.play_circle_outline, size: 40),
                      title: Text(lesson.title),
                      subtitle: const Text('Tap to view lesson details'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: Text(lesson.title),
                            content: const Text('What would you like to do?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Browse Questions',
                                  style: TextStyle(color: Color(0xff29a4d9)),
                                ),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BrowseQuestionsScreen(
                                        lessonId: lesson.id,
                                        lessonTitle: lesson.title,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  'Watch Video',
                                  style: TextStyle(color: Color(0xff29a4d9)),
                                ),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          LessonDetailsScreen(lesson: lesson),
                                    ),
                                  );
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  'Start Test',
                                  style: TextStyle(color: Color(0xff29a4d9)),
                                ),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          QuizScreen(lessonId: lesson.id),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            if (state is LessonError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
