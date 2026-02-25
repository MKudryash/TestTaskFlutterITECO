import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashViewModel()..navigateToNext(context),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2C3646),
                Color(0xFF53C2C3),
              ],
            ),
          ),
          child: Center(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(value * 0.5),
                            blurRadius: 20 * value,
                            spreadRadius: 5 * value,
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/man.svg',
                        width: 100 * value,
                        height: 100 * value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeIn,
                      builder: (context, opacity, child) {
                        return Opacity(
                          opacity: opacity,
                          child: Text(
                            'Test Task',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF0F4F8),
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 10 * opacity,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}