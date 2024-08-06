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
import 'package:lovoj_task/features/authentication/signup/bloc/signup_state.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
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
            AppSpacing.verticalMedium,
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
          "00:${time.toInt()}".toString(),
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
      } else if (state is SignUpFailureState) {
        // AppUtils.showMyDialog(state.error.toString(), context);
        Navigator.pushNamed(context, AppRouteString.singin);
      }
    }, builder: (context, state) {
      return SizedBox(
        width: ScreenSize.screenWidthPercentage(context, 0.9),
        child: Center(
          child: OTPTextField(
              controller: otpController,
              length: 6,
              width: MediaQuery.of(context).size.width,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldWidth: 50,
              fieldStyle: FieldStyle.box,
              outlineBorderRadius: 10,
              otpFieldStyle: OtpFieldStyle(
                  backgroundColor: AppColors.white,
                  borderColor: AppColors.primary),
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              onChanged: (pin) {},
              onCompleted: (pin) {
                // context.read<SignUpBloc>().add(SignUpRequestEvent(
                //     userName: widget.username,
                //     userEmail: widget.useremail,
                //     password: widget.password,
                //     mobileNumber: widget.usermobile,
                //     otpKey: pin));
              }),
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
            context.read<OtpBloc>().add(GetOtpEvent(widget.useremail));
          },
          child: ReusableText(
            text: AppString.sendAgain,
            style: timerInSec == 0
                ? AppTextStyles.bodyText4
                : AppTextStyles.bodyText3,
          ),
        );
      },
    );
  }
}
