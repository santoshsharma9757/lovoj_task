import 'package:flutter/material.dart';
import 'package:lovoj_task/core/constant/app_string.dart';
import 'package:lovoj_task/features/authentication/otp_verification/screen/otp_verification_screen.dart';
import 'package:lovoj_task/features/authentication/signin/screen/signin_screen.dart';
import 'package:lovoj_task/features/authentication/signup/screen/signup_screen.dart';
import 'package:lovoj_task/features/main_screen/main_screen.dart';

class AppRoutes {
  static Route<dynamic>? onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRouteString.signup:
        return MaterialPageRoute(builder: (context) => const SignupScreen());
      case AppRouteString.otpVerification:
        Map<String, dynamic> args =
            routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
                  username: args['username'],
                  useremail: args['useremail'],
                  usermobile: args['usermobile'],
                  password: args['password'],
                ));

      case AppRouteString.singin:
        return MaterialPageRoute(builder: (context) => const SignInScreen());

      case AppRouteString.home:
        return MaterialPageRoute(builder: (context) => const MainScreen());

      default:
        return null;
    }
  }
}
