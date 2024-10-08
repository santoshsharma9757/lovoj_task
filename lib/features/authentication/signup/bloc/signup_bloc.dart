import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovoj_task/data/repository/authentication_repository.dart';
import 'package:lovoj_task/features/authentication/signup/bloc/signup_event.dart';
import 'package:lovoj_task/features/authentication/signup/bloc/signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignupState> {
  final authenticationRepo = AuthenticationRepo();

  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpRequestEvent>(_onSignUpRequestEvent);
  }

  Future<void> _onSignUpRequestEvent(
      SignUpRequestEvent event, Emitter<SignupState> emit) async {
    emit(SignUpLoadingState());
    Map<String, dynamic> bodyToSend = {
      'name': event.userName,
      'email': event.userEmail,
      'otp_key': event.otpKey,
      'storeType': "Fabric", //just added dummy there is no input from UI
      'password': event.password,
      'mobileNumber': event.mobileNumber
    };

    log("bodyTosend $bodyToSend");

    try {
      final response = await authenticationRepo.signUp(bodyToSend);
      if (response['success']) {
        emit(SignUpSuccessState());
      }
    } catch (error) {
      String errorMessage =
          error.toString().replaceFirst('Exception:', '').trim();
      emit(SignUpFailureState(errorMessage.toString()));
    }
  }
}
