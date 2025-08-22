import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/presentation/cubit/profile_cubit.dart';
import '../../profile/presentation/cubit/profile_state.dart';
import '../../quiz/presentation/screens/create_custom_test_screen.dart';
import '../../quiz/presentation/screens/my_tests_screen.dart';
import '../../favorites/presentation/screens/favorite_teachers_screen.dart';
import '../../subject/presentation/screens/subject_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..fetchUserProfile(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProfileLoaded) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(state.user.name),
                      const SizedBox(height: 30),
                      const Text(
                        "Explore your learning journey",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDashboardCard(
                        context,
                        icon: Icons.library_books_outlined,
                        title: 'All Subjects',
                        subtitle: 'Find and join your next course',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SubjectsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.history_edu_outlined,
                        title: 'My Tests',
                        subtitle: 'Review your past test results',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MyTestsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.star_outline,
                        title: 'Favorites',
                        subtitle: 'See your favorite teachers & tests',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const FavoriteTeachersScreen(),
                            ),
                          );
                        },
                      ),
                      // _buildDashboardCard(
                      //   context,
                      //   icon: Icons.add_task,
                      //   title: 'Create Custom Test',
                      //   subtitle: 'Build your own quiz from any lesson',
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (_) => const CreateCustomTestScreen(),
                      //     ));
                      //   },
                      // ),
                    ],
                  ),
                );
              }
              if (state is ProfileError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome back,", style: TextStyle(fontSize: 16)),
            Text(
              "$userName!",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // IconButton(
        // icon: const Icon(Icons.notifications_none, size: 28),
        // onPressed: () {},
        // ),
      ],
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        leading: Icon(icon, size: 40, color: Color(0xff29a4d9)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
