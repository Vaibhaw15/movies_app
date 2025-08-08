import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/util/splashScreen.dart';

import 'logIn/logInUI.dart';
import 'logIn/loginCubit.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (_) => BlocProvider(
            create: (_) => LoginCubit(),
        child: const LoginScreen()),
      },
    );
  }
}
