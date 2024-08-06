import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovoj_task/core/constant/app_constant.dart';
import 'package:lovoj_task/core/constant/app_image.dart';
import 'package:lovoj_task/core/constant/app_string.dart';
import 'package:lovoj_task/core/constant/app_text_style.dart';
import 'package:lovoj_task/core/constant/screen_size.dart';
import 'package:lovoj_task/core/utils/utils.dart';
import 'package:lovoj_task/core/widgets/custim_text.dart';
import 'package:lovoj_task/features/authentication/otp_verification/bloc/otp_bloc.dart';
import 'package:lovoj_task/features/authentication/otp_verification/bloc/otp_event.dart';
import 'package:lovoj_task/features/authentication/otp_verification/bloc/otp_state.dart';
import 'package:lovoj_task/features/authentication/signup/bloc/signup_bloc.dart';
import 'package:lovoj_task/features/authentication/signup/bloc/signup_event.dart';
import 'package:lovoj_task/features/authentication/signup/bloc/signup_state.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OtpVerificationScreen extends StatefulWidget {
  String? username;
  String? useremail;
  String? usermobile;
  String? password;

  OtpVerificationScreen(
      {super.key,
      this.username,
      this.useremail,
      this.usermobile,
      this.password});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final OtpFieldController otpController = OtpFieldController();
  int timerInSec = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppSpacing.vertical(50),
            _buildBackIcon(context),
            AppSpacing.verticalMedium,
            _buildIconSection(),
            _buildTimerSection(),
            AppSpacing.verticalMedium,
            _buildTextMessageSection(),
            AppSpacing.verticalLarge,
            _buildOtpBoxSection(),
            AppSpacing.vertical(150),
            _buildSendText(),
            AppSpacing.verticalLarge,
          ],
        ),
      ),
    );
  }

  _buildBackIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          height: 50,
          width: 50,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  _buildIconSection() {
    return Image.asset(
      AppImages.chat,
    );
  }

  _buildTimerSection() {
    return Countdown(
      seconds: 10,
      build: (_, double time) {
        if (time.toInt() == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              timerInSec = time.toInt();
            });
          });
        }

        return Text(
          time.toInt() == 0
              ? "00:${time.toInt()}0".toString()
              : "00:${time.toInt()}".toString(),
          style: AppTextStyles.heading1,
        );
      },
      interval: const Duration(milliseconds: 100),
      onFinished: () {},
    );
  }

  _buildTextMessageSection() {
    return Column(
      children: const [
        ReusableText(
          text: AppString.typeVerication,
          style: AppTextStyles.bodyText3,
        ),
        AppSpacing.verticalSmall,
        ReusableText(
          text: AppString.code,
          style: AppTextStyles.bodyText3,
        ),
        AppSpacing.verticalSmall,
        ReusableText(
          text: AppString.sentMessage,
          style: AppTextStyles.bodyText3,
        ),
      ],
    );
  }

  _buildOtpBoxSection() {
    return BlocConsumer<SignUpBloc, SignupState>(listener: (context, state) {
      if (state is SignUpSuccessState) {
        Navigator.pushNamed(context, AppRouteString.singin);
      } else if (state is SignUpFailureState) {
        AppUtils.showMyDialog(state.error.toString(), context);
      }
    }, builder: (context, state) {
      if (state is SignUpLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }
      return SizedBox(
        width: ScreenSize.screenWidthPercentage(context, 0.8),
        child: PinCodeTextField(
          appContext: context,
          length: 6,
          obscureText: false,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 45,
            fieldWidth: 45,
            activeFillColor: AppColors.primary,
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.white,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.primary,
            selectedColor: AppColors.primary,
            borderWidth: 0.2,
          ),
          enableActiveFill: true,
          textStyle: AppTextStyles.otpText,
          onCompleted: (pin) {
            context.read<SignUpBloc>().add(SignUpRequestEvent(
                userName: widget.username,
                userEmail: widget.useremail,
                password: widget.password,
                mobileNumber: widget.usermobile,
                otpKey: pin));
          },
          onChanged: (value) {
            setState(() {});
          },
          beforeTextPaste: (text) {
            return true;
          },
        ),
      );
    });
  }

  _buildSendText() {
    return BlocConsumer<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is OtpSuccessState) {
          AppUtils.snackBarSuccess(AppString.otpSent, context);
        } else if (state is OtpFailureState) {
          AppUtils.showMyDialog(state.error.toString(), context);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (timerInSec == 0) {
              context.read<OtpBloc>().add(GetOtpEvent(widget.useremail));
            } else {
              AppUtils.snackBarSuccess(
                  AppString.pleaseWaitTimerMessage, context);
            }
          },
          child: const ReusableText(
            text: AppString.sendAgain,
            style: AppTextStyles.bodyText4,
          ),
        );
      },
    );
  }
}
