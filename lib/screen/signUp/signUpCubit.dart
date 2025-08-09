import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/screen/signUp/signUpState.dart';

import '../../networking/signUpAPI.dart';
import '../../networking/verifyOtp.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();
  bool otpSent = false;

  Future<void> register() async {
    emit(RegistrationLoading());

    // Validation
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      emit(RegistrationError('Please fill all fields'));
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      emit(RegistrationError('Passwords do not match'));
      return;
    }

    final loginData = await SignUpService.signUpUser(name: nameController.text, username: nameController.text + phoneController.text, email:  emailController.text, password: passwordController.text, role: "0");

    if(loginData == 200){
      otpSent = true;
      emit(RegistrationOtpSent());
    }else if(loginData == 422){
      emit(RegistrationError('Email already exists'));
    }else{
      emit(RegistrationError(loginData));
    }


  }

  Future<void> verifyOtpAndRegister() async {
    emit(RegistrationLoading());

    if (otpController.text.isEmpty) {
      emit(RegistrationError("Please enter OTP"));
      return;
    }

    try {
      final verifyResult = await verifyEmailOtp(
        email: emailController.text.trim(),
        otp: otpController.text.trim(),
      );
      if (verifyResult == 200) {
        emit(RegistrationSuccess());
      } else {
        emit(RegistrationError("Invalid OTP"));
      }
    } catch (e) {
      emit(RegistrationError('Verification Error: ${e.toString()}'));
    }
  }


  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}