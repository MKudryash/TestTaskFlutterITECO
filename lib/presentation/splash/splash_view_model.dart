import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class SplashViewModel extends ChangeNotifier {
  Future<void> navigateToNext(BuildContext context) async {
    await Future.delayed(Duration(seconds: AppConstants.splashDelay));

    if (!context.mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool(AppConstants.onboardingKey) ?? false;

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