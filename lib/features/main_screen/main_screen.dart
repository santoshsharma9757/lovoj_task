import 'package:flutter/material.dart';
import 'package:lovoj_task/core/constant/app_text_style.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        centerTitle: true,
      ),
      body: const Center(child: Text("WELCOME TO LOVOJ TECH",style: AppTextStyles.bodyText4,)),
    );
  }
}
