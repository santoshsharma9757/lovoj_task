import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {}

class SignInInitialState extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInLoadingState extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInSuccessState extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInFailureState extends SignInState {
  String? error;
  SignInFailureState(this.error);
  @override
  List<Object?> get props => [];
}
