import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;

  int get currentPage => _currentPage;

  final List<OnboardingPageData> pages = const [
    OnboardingPageData(
      title: 'Добро пожаловать!',
      description: 'Откройте для себя мир удобного шопинга с нашим приложением',
      imagePath: 'assets/icons/home.svg',
    ),
    OnboardingPageData(
      title: 'Умный поиск',
      description: 'Находите нужные товары за секунды с умной системой фильтрации',
      imagePath: 'assets/icons/search.svg',
    ),
    OnboardingPageData(
      title: 'Быстрая доставка',
      description: 'Получайте заказы в день оформления в любой точке города',
      imagePath: 'assets/icons/statisctic.svg',
    ),
  ];

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> completeOnboarding(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.onboardingKey, true);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/feed');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/feed');
      }
    }
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}