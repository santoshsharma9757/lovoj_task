import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovoj_task/data/repository/authentication_repository.dart';
import 'package:lovoj_task/features/authentication/otp_verification/bloc/otp_event.dart';
import 'package:lovoj_task/features/authentication/otp_verification/bloc/otp_state.dart';

// Bloc Class
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final authenticationRepo = AuthenticationRepo();

  OtpBloc() : super(OtpInitialState()) {
    on<GetOtpEvent>(_onGetotpEvent);
  }

  _onGetotpEvent(GetOtpEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    Map<String, dynamic> bodyToSend = {
      'email': event.userEmail,
    };
    try {
      final response = await authenticationRepo.getOtp(bodyToSend);
      if (response['success']) {
        emit(OtpSuccessState(true));
      }
    } catch (error) {
      String errorMessage =
          error.toString().replaceFirst('Exception:', '').trim();
      emit(OtpFailureState(errorMessage.toString()));
    }
  }
}
