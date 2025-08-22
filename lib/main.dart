import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/auth/presentation/screens/login_screen.dart';
import 'package:student_app/home/presentation/home.dart';
import 'auth/presentation/cubit/auth_cubit.dart';
import 'auth/presentation/screens/auth_check_screen.dart';
import 'constants.dart';

void main() {
  runApp(const student());
}

class student extends StatelessWidget {
  const student({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Learning App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AuthCheckScreen(),
      ),
    );
  }
}
