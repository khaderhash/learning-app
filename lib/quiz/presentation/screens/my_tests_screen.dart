import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/quiz/presentation/screens/quiz_result_screen.dart';
import '../../data/quiz_data_source.dart';
import '../cubit/test_history_cubit.dart';
import '../cubit/test_history_state.dart';

class MyTestsScreen extends StatelessWidget {
  const MyTestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tests')),
      body: BlocProvider(
        create: (context) => TestHistoryCubit()..fetchTestHistory(),
        child: BlocBuilder<TestHistoryCubit, TestHistoryState>(
          builder: (context, state) {
            if (state is TestHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TestHistoryLoaded) {
              if (state.tests.isEmpty) {
                return const Center(
                  child: Text('You have not taken any tests yet.'),
                );
              }
              return ListView.builder(
                itemCount: state.tests.length,
                itemBuilder: (context, index) {
                  final test = state.tests[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.history_edu),
                      title: Text('Test #${test.testId}'),
                      subtitle: Text('Subject ID: ${test.subjectId}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (c) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          final result = await QuizDataSource().getTestResult(
                            test.testId,
                          );
                          Navigator.pop(context);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => QuizResultScreen(result: result),
                            ),
                          );
                        } catch (e) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            }
            if (state is TestHistoryError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
