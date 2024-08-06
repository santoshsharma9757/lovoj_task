import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {}

class SignInRequestEvent extends SignInEvent {
  String? userEmail;
  String? password;
  String? role;
  String? deviceToken;
  SignInRequestEvent({this.userEmail,this.password, this.role, this.deviceToken});
  @override
  List<Object?> get props => [];


}
