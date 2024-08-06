import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {}

class SignUpInitialState extends SignupState {
  @override
  List<Object?> get props => [];
}

class SignUpLoadingState extends SignupState {
  @override
  List<Object?> get props => [];
}

class SignUpSuccessState extends SignupState {
  @override
  List<Object?> get props => [];
}

class SignUpFailureState extends SignupState {
  String? error;
  SignUpFailureState(this.error);
  @override
  List<Object?> get props => [];
}
