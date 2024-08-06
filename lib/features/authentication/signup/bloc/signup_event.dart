import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {}

class SignUpRequestEvent extends SignUpEvent {
  String? userName;
  String? userEmail;
  String? storeType;
  String? password;
  String? mobileNumber;
  String? otpKey;
  SignUpRequestEvent(
      {this.userName,
      this.userEmail,
      this.storeType,
      this.password,
      this.mobileNumber,
      this.otpKey});
  @override
  List<Object?> get props => [];
}
