import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/quiz_models.dart';
import '../cubit/quiz_cubit.dart';
import '../cubit/quiz_state.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int? lessonId;
  final TestSession? testSession;

  const QuizScreen({Key? key, this.lessonId, this.testSession})
    : assert(lessonId != null || testSession != null),
      super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  final Map<int, int> _answers = {};
  int? _testId;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = QuizCubit();
        if (widget.lessonId != null) {
          cubit.startTest(lessonId: widget.lessonId!);
        } else if (widget.testSession != null) {
          cubit.startExistingTest(widget.testSession!);
        }
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              if (state is QuizReady) {
                return Text(
                  'Question ${_currentPage + 1} of ${state.testSession.questions.length}',
                );
              }
              return const Text('Loading Test...');
            },
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: BlocConsumer<QuizCubit, QuizState>(
          listener: (context, state) {
            if (state is QuizFinished) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => QuizResultScreen(result: state.result),
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
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state is QuizLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is QuizReady) {
              _testId = state.testSession.testId;
              final questions = state.testSession.questions;
              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        return _buildQuestionPage(questions[index]);
                      },
                    ),
                  ),
                  _buildBottomButton(context, state),
                ],
              );
            }
            return const Center(child: Text("Preparing your test..."));
          },
        ),
      ),
    );
  }

  Widget _buildQuestionPage(Question question) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text(
          question.questionText,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        ...question.options.map(
          (option) => Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: RadioListTile<int>(
              title: Text(
                option.optionText,
                style: const TextStyle(fontSize: 16),
              ),
              value: option.id,
              groupValue: _answers[question.id],
              onChanged: (value) {
                setState(() {
                  _answers[question.id] = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, QuizReady state) {
    final bool isLastQuestion =
        _currentPage == state.testSession.questions.length - 1;
    final bool isAnswered = _answers.containsKey(
      state.testSession.questions[_currentPage].id,
    );

    if (context.watch<QuizCubit>().state is QuizSubmitting) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isAnswered
            ? () {
                if (isLastQuestion) {
                  if (_testId != null) {
                    context.read<QuizCubit>().submitTest(
                      testId: _testId!,
                      answers: _answers,
                    );
                  }
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              }
            : null, // null = disabled
        child: Text(isLastQuestion ? 'Submit Answers' : 'Next Question'),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
