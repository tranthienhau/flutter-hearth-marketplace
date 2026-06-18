import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/hearth_theme.dart';
import 'features/onboarding/welcome_screen.dart';

void main() {
  runApp(const ProviderScope(child: HearthApp()));
}

class HearthApp extends StatelessWidget {
  const HearthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hearth',
      debugShowCheckedModeBanner: false,
      theme: HearthTheme.build(),
      home: const WelcomeScreen(),
    );
  }
}
