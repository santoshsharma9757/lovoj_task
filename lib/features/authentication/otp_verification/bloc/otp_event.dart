import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {}

class GetOtpEvent extends OtpEvent {
  String? userEmail;
  GetOtpEvent(this.userEmail);
  @override
  List<Object?> get props => [];
}
