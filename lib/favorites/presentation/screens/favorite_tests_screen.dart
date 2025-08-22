import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorite_tests_cubit.dart';
import '../cubit/favorite_tests_state.dart';
import '../../../quiz/presentation/screens/quiz_screen.dart';

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
      appBar: AppBar(title: Text('Favorite Tests by $teacherName')),
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
                      leading: const Icon(
                        Icons.quiz_outlined,
                        color: Colors.amber,
                      ),
                      title: Text('Favorite Test #${test.testId}'),
                      subtitle: Text('${test.questions.length} Questions'),
                      trailing: const Icon(Icons.arrow_forward_ios),
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
