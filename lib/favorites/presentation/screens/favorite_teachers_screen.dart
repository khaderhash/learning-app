import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

class FavoriteTeachersScreen extends StatelessWidget {
  const FavoriteTeachersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorite Teachers')),
      body: BlocProvider(
        create: (context) => FavoritesCubit()..fetchFavoriteTeachers(),
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FavoritesLoaded) {
              if (state.teachers.isEmpty) {
                return const Center(
                  child: Text(
                    'No teachers have added you to their favorites yet.',
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.teachers.length,
                itemBuilder: (context, index) {
                  final teacher = state.teachers[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(teacher.name.substring(0, 1)),
                      ),
                      title: Text(teacher.name),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigator.of(context).push(...);
                      },
                    ),
                  );
                },
              );
            }
            if (state is FavoritesError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
