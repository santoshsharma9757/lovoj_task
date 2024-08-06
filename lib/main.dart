import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovoj_task/core/constant/app_constant.dart';
import 'package:lovoj_task/core/constant/app_string.dart';
import 'package:lovoj_task/features/authentication/otp_verification/bloc/otp_bloc.dart';
import 'package:lovoj_task/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:lovoj_task/features/authentication/signup/bloc/signup_bloc.dart';
import 'package:lovoj_task/route/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OtpBloc()),
        BlocProvider(create: (context) => SignUpBloc()),
        BlocProvider(create: (context) => SignInBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: AppColors.customColor),
        onGenerateRoute: AppRoutes.onGeneratedRoute,
        initialRoute: AppRouteString.signup,
      ),
    );
  }
}
