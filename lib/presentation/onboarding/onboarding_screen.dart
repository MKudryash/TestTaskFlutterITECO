import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_constants.dart';
import 'onboarding_view_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Stack(
              children: [
                PageView.builder(
                  controller: viewModel.pageController,
                  onPageChanged: viewModel.onPageChanged,
                  itemCount: viewModel.pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(viewModel.pages[index], index);
                  },
                ),
                _buildBottomNavigation(viewModel),
                if (viewModel.currentPage == 0)
                  _buildBackButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(OnboardingPageData page, int index) {
    final colors = [
      AppConstants.primaryDark,
      AppConstants.primaryLight,
      AppConstants.primaryDark,
    ];

    final accentColors = [
      AppConstants.primaryLight,
      AppConstants.primaryDark,
      AppConstants.primaryLight,
    ];

    return Container(
      color: colors[index % colors.length],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColors[index % accentColors.length].withOpacity(0.2),
                      ),
                      child: SvgPicture.asset(
                        page.imagePath,
                        width: 150,
                        height: 150,
                        color: accentColors[index % accentColors.length],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutQuad,
                builder: (context, opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: Text(
                      page.title,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: accentColors[index % accentColors.length],
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutQuad,
                builder: (context, opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: Text(
                      page.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(OnboardingViewModel viewModel) {
    final accentColor = viewModel.currentPage == 0
        ? AppConstants.primaryLight
        : viewModel.currentPage == 1
        ? AppConstants.primaryDark
        : AppConstants.primaryLight;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              viewModel.currentPage == 0
                  ? AppConstants.primaryDark.withOpacity(0.9)
                  : viewModel.currentPage == 1
                  ? AppConstants.primaryLight.withOpacity(0.9)
                  : AppConstants.primaryDark.withOpacity(0.9),
            ],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmoothPageIndicator(
              controller: viewModel.pageController,
              count: viewModel.pages.length,
              effect: WormEffect(
                dotColor: Colors.white.withOpacity(0.3),
                activeDotColor: accentColor,
                dotHeight: 8,
                dotWidth: 16,
                spacing: 8,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                if (viewModel.currentPage < viewModel.pages.length - 1)
                  Expanded(
                    child: TextButton(
                      onPressed: () => viewModel.completeOnboarding(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Пропустить',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                if (viewModel.currentPage < viewModel.pages.length - 1)
                  const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: viewModel.currentPage == viewModel.pages.length - 1
                        ? () => viewModel.completeOnboarding(context)
                        : viewModel.nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: viewModel.currentPage == 1
                          ? AppConstants.primaryLight
                          : AppConstants.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      viewModel.currentPage == viewModel.pages.length - 1
                          ? 'Начать'
                          : 'Далее',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 40,
      left: 16,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}