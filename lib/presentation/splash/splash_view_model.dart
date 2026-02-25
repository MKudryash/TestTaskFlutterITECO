import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel extends ChangeNotifier {
  static const String _onboardingKey = 'onboarding_seen';

  Future<void> navigateToNext(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool(_onboardingKey) ?? false;

      if (hasSeenOnboarding) {
        Navigator.pushReplacementNamed(context, '/feed');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }
}