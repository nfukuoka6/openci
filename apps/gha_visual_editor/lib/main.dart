import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/workflow/presentation/action_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const Scaffold(
        backgroundColor: AppColors.grayBackground,
        body: ActionCard(),
      ),
    );
  }
}
