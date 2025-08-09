import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../util/customeTextField.dart';
import '../../util/logo.dart';
import '../home/MainScreen.dart';
import '../signUp/signUpCubit.dart';
import '../signUp/signUpUI.dart';
import 'loginCubit.dart';
import 'loginState.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar style

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successful!')),
            );
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(),
                    ),
            );
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  ImboxoLogo(),
                  const Spacer(flex: 1),
                  Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        placeholder: 'Email ID',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 25),

                      CustomTextField(
                        controller: _passwordController,
                        placeholder: 'Password',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 24),
                      // Forgot password
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: cubit.forgotPassword,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Login button
                      SizedBox(
                        width: 130,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: state is LoginLoading
                              ? null
                              : () => cubit.login(_emailController.text,_passwordController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF9575CD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: state is LoginLoading
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),


                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider<RegistrationCubit>(
                                            create: (BuildContext context) => RegistrationCubit(),
                                          ),
                                        ],
                                        child: RegistrationScreen(),
                                      )));
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Color(0xFF9575CD),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}