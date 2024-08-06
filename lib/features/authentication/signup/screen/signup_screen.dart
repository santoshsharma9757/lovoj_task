import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lovoj_task/core/constant/app_constant.dart';
import 'package:lovoj_task/core/constant/app_image.dart';
import 'package:lovoj_task/core/constant/app_string.dart';
import 'package:lovoj_task/core/constant/app_text_style.dart';
import 'package:lovoj_task/core/constant/screen_size.dart';
import 'package:lovoj_task/core/utils/utils.dart';
import 'package:lovoj_task/core/widgets/reusable_container_button.dart';
import 'package:lovoj_task/core/widgets/reusable_text.dart';
import 'package:lovoj_task/core/widgets/reusable_text_filed.dart';
import 'package:lovoj_task/features/authentication/otp_verification/bloc/otp_bloc.dart';
import 'package:lovoj_task/features/authentication/otp_verification/bloc/otp_event.dart';
import 'package:lovoj_task/features/authentication/otp_verification/bloc/otp_state.dart';
import 'package:lovoj_task/features/authentication/signin/screen/signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  FocusNode focusNode = FocusNode();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _buildBackground(context),
            _buildLogoSection(context),
            _buildFormSection(context),
            _buildNeedHelpSection(),
          ],
        ),
      ),
    );
  }

  _buildBackground(BuildContext context) {
    return Image.asset(
      AppImages.background,
      height: ScreenSize.screenHeight(context),
      width: ScreenSize.screenWidth(context),
      fit: BoxFit.cover,
    );
  }

  _buildLogoSection(BuildContext context) {
    return Positioned(
      top: ScreenSize.screenHeightPercentage(context, 0.1),
      left: 0,
      right: 0,
      child: Image.asset(
        AppImages.logo,
        height: ScreenSize.screenHeightPercentage(context, 0.08),
        width: ScreenSize.screenHeightPercentage(context, 0.08),
      ),
    );
  }

  _buildFormSection(BuildContext context) {
    return Positioned(
      top: ScreenSize.screenHeightPercentage(context, 0.18),
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: ScreenSize.screenHeightPercentage(context, 0.72),
        width: ScreenSize.screenHeightPercentage(context, 0.8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderGrey, width: 1.2)),
        child: _buildForm(),
      ),
    );
  }

  _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.medium),
      child: Column(
        children: [
          const ReusableText(
            text: AppString.designer,
            style: AppTextStyles.heading1,
          ),
          AppSpacing.verticalExtraSmall,
          const ReusableText(
            text: AppString.welcomeHere,
            style: AppTextStyles.heading2,
          ),
          AppSpacing.verticalMedium,
          ReusableTextField(
            hintText: AppString.fullName,
            controller: _userNameController,
          ),
          AppSpacing.verticalMedium,
          ReusableTextField(
            hintText: AppString.enterEmail,
            controller: _userEmailController,
          ),
          AppSpacing.verticalMedium,
          SizedBox(
            height: 65,
            child: IntlPhoneField(
              focusNode: focusNode,
              dropdownIconPosition: IconPosition.trailing,
              decoration: const InputDecoration(
                labelText: '',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderGrey),
                ),
              ),
              initialCountryCode: 'IN',
              controller: _mobileNumberController,
              onChanged: (phone) {},
              onCountryChanged: (country) {},
            ),
          ),
          AppSpacing.verticalMedium,
          ReusableTextField(
            hintText: AppString.enterPassword,
            controller: _passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
          ),
          AppSpacing.verticalSmall,
          Row(
            children: [
              AppSpacing.horizontalExtraSmall,
              Image.asset(
                AppImages.info,
              ),
              AppSpacing.horizontalSmall,
              const Text(AppString.paswordErrorMessage)
            ],
          ),
          AppSpacing.verticalSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
                activeColor: AppColors.primary,
                focusColor: AppColors.white,
              ),
              const Text(AppString.termCondition)
            ],
          ),
          BlocConsumer<OtpBloc, OtpState>(listener: (context, state) {
            if (state is OtpSuccessState) {
              if (state.isSuccess!) {
                Navigator.pushNamed(context, AppRouteString.otpVerification,
                    arguments: {
                      "username": _userNameController.text,
                      "useremail": _userEmailController.text,
                      "usermobile": _mobileNumberController.text,
                      "password": _passwordController.text
                    });
              }
            } else if (state is OtpFailureState) {
              AppUtils.showMyDialog(state.error.toString(), context);
            }
          }, builder: (context, state) {
            return ReusableButton(
              onPressed: () {
                if (_userNameController.text.isEmpty) {
                  AppUtils.snackBarError(AppString.userCannotEmpty, context);
                  return;
                }
                if (_userEmailController.text.isEmpty ||
                    !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(_userEmailController.text)) {
                  AppUtils.snackBarError(AppString.emailError, context);
                  return;
                }
                if (_passwordController.text.isEmpty) {
                  AppUtils.snackBarError(AppString.passwordError, context);
                  return;
                }
                if (_mobileNumberController.text.isEmpty ||
                    !RegExp(r'^\d{10}$')
                        .hasMatch(_mobileNumberController.text)) {
                  AppUtils.snackBarError(AppString.mobileNumberError, context);
                  return;
                }

                if (!isChecked) {
                  AppUtils.snackBarError(
                      AppString.pleaseChecktermConditaion, context);
                  return;
                }

                context
                    .read<OtpBloc>()
                    .add(GetOtpEvent(_userEmailController.text));
              },
              label: AppString.singUp,
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
              borderRadius: 12.0,
              padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.medium, horizontal: AppPadding.large),
              isLoading: state is OtpLoadingState ? true : false,
            );
          }),
          AppSpacing.verticalSmall,
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SignInScreen();
              }));
            },
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: AppString.haveAnAccount,
                      style: AppTextStyles.bodyText),
                  TextSpan(
                      text: AppString.singInNow,
                      style: AppTextStyles.bodyText2),
                ],
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: AppString.privacyPolicy1,
                      style: AppTextStyles.bodyText),
                  TextSpan(
                      text: AppString.privacyPolicy2,
                      style: AppTextStyles.bodyText2),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildNeedHelpSection() {
    return Positioned(
        bottom: 20,
        left: 12,
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.medium),
          child: Row(
            children: [
              Image.asset(
                AppImages.forwardArrow,
              ),
              AppSpacing.horizontalSmall,
              const ReusableText(
                text: AppString.needHelp,
                style: AppTextStyles.heading3,
              )
            ],
          ),
        ));
  }
}
