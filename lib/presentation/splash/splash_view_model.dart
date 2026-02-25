import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  void navigateToNext(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          final hasSeenOnboarding = false;

          if (hasSeenOnboarding) {

          } else {
            Navigator.pushReplacementNamed(context, '/onboarding');
          }
        }
      });
    });
  }
}