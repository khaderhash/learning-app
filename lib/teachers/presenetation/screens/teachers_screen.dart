import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../lessons/presentation]/screens/lessons_screen.dart';
import '../cubit/teacher_cubit.dart';
import '../cubit/teacher_state.dart';

class TeachersScreen extends StatelessWidget {
  final int subjectId;
  final String subjectTitle;

  const TeachersScreen({
    Key? key,
    required this.subjectId,
    required this.subjectTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subjectTitle)),
      body: BlocProvider(
        create: (context) => TeacherCubit()..fetchTeachers(subjectId),
        child: BlocBuilder<TeacherCubit, TeacherState>(
          builder: (context, state) {
            if (state is TeacherLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TeacherLoaded) {
              if (state.teachers.isEmpty) {
                return const Center(
                  child: Text('No teachers found for this subject.'),
                );
              }
              return ListView.builder(
                itemCount: state.teachers.length,
                itemBuilder: (context, index) {
                  final teacher = state.teachers[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        // <-- 1. غلفنا كل شيء بـ Column
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Color(0xff29a4d9),
                              backgroundImage: teacher.profileImageUrl != null
                                  ? NetworkImage(teacher.profileImageUrl!)
                                  : null,
                              child: teacher.profileImageUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            title: Text(teacher.name),
                            subtitle: const Text(
                              'Tap to view lessons (after approval)',
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LessonsScreen(
                                    teacherId: teacher.id,
                                    teacherName: teacher.name,
                                    subjectId: subjectId,
                                    subjectTitle: subjectTitle,
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40),
                              ),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Color(0xff29a4d9),
                              ),
                              label: const Text(
                                'Request to Join',
                                style: TextStyle(color: Color(0xff29a4d9)),
                              ),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (c) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                try {
                                  final message = await context
                                      .read<TeacherCubit>()
                                      .requestToJoin(subjectId, teacher.id);
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            if (state is TeacherError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
