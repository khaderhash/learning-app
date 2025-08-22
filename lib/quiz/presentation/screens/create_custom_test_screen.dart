import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/custom_test_builder_cubit.dart';
import '../cubit/quiz_cubit.dart';
import '../cubit/quiz_state.dart';
import 'quiz_screen.dart';

class CreateCustomTestScreen extends StatefulWidget {
  const CreateCustomTestScreen({Key? key}) : super(key: key);

  @override
  _CreateCustomTestScreenState createState() => _CreateCustomTestScreenState();
}

class _CreateCustomTestScreenState extends State<CreateCustomTestScreen> {
  final Set<int> _selectedLessonIds = {};
  final _questionsCountController = TextEditingController(text: '10');

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CustomTestBuilderCubit()..loadSubjects(),
        ),
        BlocProvider(create: (context) => QuizCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Custom Test')),
        body: BlocBuilder<CustomTestBuilderCubit, CustomTestBuilderState>(
          builder: (context, state) {
            if (state is CustomTestBuilderLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CustomTestBuilderLoaded) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    '1. Select Lessons',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Note: This feature is not fully implemented. We'll create a test from ALL lessons of the first subject for now.",
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    '2. Enter Number of Questions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _questionsCountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Number of Questions',
                    ),
                  ),
                ],
              );
            }
            if (state is CustomTestBuilderError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<QuizCubit, QuizState>(
            listener: (context, state) {
              if (state is QuizReady) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(testSession: state.testSession),
                  ),
                );
              }
              if (state is QuizError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is QuizLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                onPressed: () {
                  final count =
                      int.tryParse(_questionsCountController.text) ?? 0;
                  final lessonIds = [5];

                  if (lessonIds.isEmpty || count <= 0) {
                    return;
                  }

                  context.read<QuizCubit>().startCustomTest(
                    lessonIds: lessonIds,
                    count: count,
                  );
                },
                child: const Text('Generate Test'),
              );
            },
          ),
        ),
      ),
    );
  }
}
