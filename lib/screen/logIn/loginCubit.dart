import 'package:flutter_bloc/flutter_bloc.dart';
import '../../networking/logInAPI.dart';
import 'loginState.dart';
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());


  Future<void> login(String email,String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginError('Please fill all fields'));
      emit(LoginInitial());
      return;
    }

    emit(LoginLoading());


    final loginData = await loginUser( email:email, password: password);

    if (loginData == 200) {
      emit(LoginSuccess());
    }else if(loginData == 400){
      emit(LoginError('Invalid credentials'));
    } else if(loginData == 401){
      emit(LoginError('Token expired'));
    } else {
      emit(LoginError('Error in login please try again!'));
      emit(LoginInitial());
    }
  }

  void forgotPassword() {
    // Handle forgot password logic
    print('Forgot password clicked');
  }


}