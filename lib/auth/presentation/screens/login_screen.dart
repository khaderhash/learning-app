import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/home/presentation/home.dart';
import '../../../constants.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(color: kPpccolor, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login Successful!')),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            } else if (state is AuthFailure) {
              print(state.message);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("wrong password or email")),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * .3,
                horizontal: MediaQuery.of(context).size.width * .07,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  _buildTextField(
                    phoneController,
                    'Phone number',
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),

                  _buildTextField(
                    passwordController,
                    'Password',
                    isPassword: true,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),

                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff29a4d9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<AuthCubit>().loginUser(
                          phone: phoneController.text,
                          password: passwordController.text,
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * .02),

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: " Don't have an account? ",
                        style: TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: 'Sign up',
                            style: TextStyle(
                              color: Color(0xff29a4d9),
                              fontWeight: FontWeight.bold,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}
