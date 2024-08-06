import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {}

class OtpInitialState extends OtpState {
  @override
  List<Object?> get props => [];
}

class OtpLoadingState extends OtpState {
  @override
  List<Object?> get props => [];
}

class OtpSuccessState extends OtpState {
  bool? isSuccess;
  OtpSuccessState(this.isSuccess);
  @override
  List<Object?> get props => [];
}

class OtpFailureState extends OtpState {
  String? error;
  OtpFailureState(this.error);
  @override
  List<Object?> get props => [];
}
