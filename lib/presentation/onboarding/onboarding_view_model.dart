import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  static const String _onboardingKey = 'onboarding_seen';

  final List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: 'Добро пожаловать!',
      description: 'Откройте для себя мир удобного шопинга с нашим приложением',
      imagePath: 'assets/icons/home.svg',
      backgroundColor: const Color(0xFF2C3646),
      accentColor: const Color(0xFF53C2C3),
    ),
    OnboardingPageData(
      title: 'Умный поиск',
      description: 'Находите нужные товары за секунды с умной системой фильтрации',
      imagePath: 'assets/icons/search.svg',
      backgroundColor: const Color(0xFF53C2C3),
      accentColor: const Color(0xFF2C3646),
    ),
    OnboardingPageData(
      title: 'Быстрая доставка',
      description: 'Получайте заказы в день оформления в любой точке города',
      imagePath: 'assets/icons/statisctic.svg',
      backgroundColor: const Color(0xFF2C3646),
      accentColor: const Color(0xFF53C2C3),
    ),
  ];

  void onPageChanged(int page) {
    currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> completeOnboarding(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/feed');
      }
    } catch (e) {
      debugPrint('$e');

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/feed');
      }
    }
  }

  Future<void> resetOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingKey);
    } catch (e) {
      debugPrint('$e');
    }
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final Color accentColor;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.accentColor,
  });
}