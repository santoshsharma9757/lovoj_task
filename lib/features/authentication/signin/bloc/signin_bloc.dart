import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovoj_task/data/repository/authentication_repository.dart';
import 'package:lovoj_task/features/authentication/signin/bloc/signin_event.dart';
import 'package:lovoj_task/features/authentication/signin/bloc/signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final authenticationRepo = AuthenticationRepo();
  SignInBloc() : super(SignInInitialState()) {
    on<SignInRequestEvent>(_onSignInRequestEvent);
  }
  _onSignInRequestEvent(
      SignInRequestEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoadingState());

    Map<String, dynamic> bodyToSend = {
      'email': event.userEmail,
      'password': event.password,
      'role': event.role,
      'deviceToken': "",
      'storeType': "Fabric" //just added dummy there is no input from UI
    };
    try {
      final response = await authenticationRepo.signIn(bodyToSend);

      if (response['success']) {
        emit(SignInSuccessState());
      }
    } catch (error) {
      String errorMessage =
          error.toString().replaceFirst('Exception:', '').trim();
      emit(SignInFailureState(errorMessage.toString()));
    }
  }
}
