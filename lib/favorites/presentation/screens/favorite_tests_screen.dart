import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../quiz/presentation/screens/quiz_screen.dart';
import '../cubit/favorite_tests_cubit.dart';
import '../cubit/favorite_tests_state.dart';

class FavoriteTestsScreen extends StatelessWidget {
  final int teacherId;
  final String teacherName;

  const FavoriteTestsScreen({
    Key? key,
    required this.teacherId,
    required this.teacherName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tests by $teacherName')),
      body: BlocProvider(
        create: (context) =>
            FavoriteTestsCubit()..fetchFavoriteTests(teacherId),
        child: BlocBuilder<FavoriteTestsCubit, FavoriteTestsState>(
          builder: (context, state) {
            if (state is FavoriteTestsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FavoriteTestsLoaded) {
              if (state.tests.isEmpty) {
                return const Center(
                  child: Text(
                    'This teacher has not added any favorite tests yet.',
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.tests.length,
                itemBuilder: (context, index) {
                  final test = state.tests[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: const Icon(Icons.quiz_outlined),
                      title: Text('Test #${test.testId}'),
                      subtitle: Text('${test.questions.length} Questions'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(testSession: test),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            if (state is FavoriteTestsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
