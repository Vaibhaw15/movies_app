import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/signUp/signUpCubit.dart';
import 'package:movies_app/signUp/signUpState.dart';

import '../logIn/logInUI.dart';
import '../logIn/loginCubit.dart';
import '../util/customeTextField.dart';
import '../util/logo.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration successful!.Please log in to continue!')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<LoginCubit>(
                      create: (_) => LoginCubit(),
                    ),
                  ],
                  child: LoginScreen(),
                ),
              ),
            );
          } else if (state is RegistrationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
          builder: (context, state) {
            final cubit = context.read<RegistrationCubit>();

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      ImboxoLogo(),
                      SizedBox(height: 50),

                      CustomTextField(
                        controller: cubit.nameController,
                        placeholder: 'Name',
                        enabled: !(cubit.otpSent || state is RegistrationOtpSent),
                      ),

                      SizedBox(height: 32),
                      CustomTextField(
                        controller: cubit.phoneController,
                        placeholder: 'Phone',
                        keyboardType: TextInputType.phone,
                        enabled: !(cubit.otpSent || state is RegistrationOtpSent),
                      ),

                      SizedBox(height: 32),
                      CustomTextField(
                        controller: cubit.emailController,
                        placeholder: 'Email ID',
                        keyboardType: TextInputType.emailAddress,
                        enabled: !(cubit.otpSent || state is RegistrationOtpSent),
                      ),

                      SizedBox(height: 32),
                      CustomTextField(
                        controller: cubit.passwordController,
                        placeholder: 'Password',
                        isPassword: true,
                        enabled: !(cubit.otpSent || state is RegistrationOtpSent),
                      ),

                      SizedBox(height: 32),
                      CustomTextField(
                        controller: cubit.confirmPasswordController,
                        placeholder: 'Confirm Password',
                        isPassword: true,
                        enabled: !(cubit.otpSent || state is RegistrationOtpSent),
                      ),

                      if (cubit.otpSent || state is RegistrationOtpSent) ...[
                        SizedBox(height: 32),
                        CustomTextField(
                          controller: cubit.otpController,
                          placeholder: 'OTP',
                          keyboardType: TextInputType.number,
                        ),
                      ],

                      SizedBox(height: 32),

                      SizedBox(
                        width: 130,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: state is RegistrationLoading
                              ? null
                              : () {
                            if (cubit.otpSent || state is RegistrationOtpSent) {
                              cubit.verifyOtpAndRegister();
                            } else {
                              cubit.register();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF9575CD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: state is RegistrationLoading
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text(
                            cubit.otpSent || state is RegistrationOtpSent
                                ? 'Verify OTP'
                                : 'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<LoginCubit>(
                                        create: (_) => LoginCubit(),
                                      ),
                                    ],
                                    child: LoginScreen(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
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
                ),
              ),
            );
          }
      ),
    );
  }
}


