import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovoj_task/core/constant/app_constant.dart';
import 'package:lovoj_task/core/constant/app_image.dart';
import 'package:lovoj_task/core/constant/app_string.dart';
import 'package:lovoj_task/core/constant/app_text_style.dart';
import 'package:lovoj_task/core/constant/screen_size.dart';
import 'package:lovoj_task/core/utils/utils.dart';
import 'package:lovoj_task/core/widgets/custim_text.dart';
import 'package:lovoj_task/core/widgets/cutom_tect.dart';
import 'package:lovoj_task/core/widgets/reusable_container_button.dart';
import 'package:lovoj_task/core/widgets/reusable_dropdown.dart';
import 'package:lovoj_task/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:lovoj_task/features/authentication/signin/bloc/signin_event.dart';
import 'package:lovoj_task/features/authentication/signin/bloc/signin_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  List<String> userRoles = ["Admin", "User", "Guest"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _buildBackground(context),
            _buildLogo(context),
            _buildFormSection(context),
            _buildNeedhelpSection(),
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

  _buildLogo(BuildContext context) {
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
        margin: const EdgeInsets.symmetric(
            horizontal: 20), // Margin for left and right
        height: ScreenSize.screenHeightPercentage(context, 0.6),
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
            text: AppString.welcomeBack,
            style: AppTextStyles.heading2,
          ),
          AppSpacing.verticalMedium,
          ReusableDropdown(
            items: userRoles,
            selectedValue: _selectedRole,
            hintText: "Select Role",
            onChanged: (String? newValue) {
              setState(() {
                _selectedRole = newValue;
              });
            },
          ),
          AppSpacing.verticalMedium,
          ReusableTextField(
              hintText: AppString.enterEmail,
              suffixIcon: const Icon(Icons.mail),
              controller: _userEmailController),
          AppSpacing.verticalMedium,
          ReusableTextField(
            hintText: AppString.enterPassword,
            controller: _passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
          ),
          AppSpacing.verticalMedium,
          const Align(
              alignment: Alignment.centerRight,
              child: ReusableText(
                  text: AppString.forgetPassword,
                  style: AppTextStyles.bodyText2)),
          AppSpacing.verticalMedium,
          BlocConsumer<SignInBloc, SignInState>(
            listener: (context, state) {
              if (state is SignInSuccessState) {
                AppUtils.snackBarSuccess(
                    "Login Successfull!!!".toString(), context);
                Navigator.pushNamed(context, AppRouteString.home);
              } else if (state is SignInFailureState) {
                AppUtils.showMyDialog(state.error.toString(), context);
              }
            },
            builder: (context, state) {
              return ReusableButton(
                onPressed: () {
                  if (_selectedRole == null) {
                    AppUtils.snackBarError(AppString.selectRole, context);
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
                  context.read<SignInBloc>().add(SignInRequestEvent(
                      userEmail: _userEmailController.text,
                      password: _passwordController.text,
                      deviceToken: "",
                      role: _selectedRole!.toLowerCase()));
                },
                label: AppString.signIn,
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
                borderRadius: 12.0,
                padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.medium, horizontal:AppPadding.large),
                isLoading: state is SignInSuccessState ? true : false,
              );
            },
          ),
          AppSpacing.verticalSmall,
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRouteString.signup);
            },
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: AppString.haveAnAccount,
                      style: AppTextStyles.bodyText),
                  TextSpan(
                      text: AppString.singUpNow,
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

  _buildNeedhelpSection() {
    return Positioned(
        bottom: 20,
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.medium),
          child: Row(
            children: [
              Image.asset(
                AppImages.forwardArrow,
              ),
              AppSpacing.horizontalSmall,
              const Text(
                AppString.needHelp,
                style: AppTextStyles.heading3,
              )
            ],
          ),
        ));
  }
}
