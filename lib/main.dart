import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/splash/splash_screen.dart';
import 'presentation/onboarding/onboarding_screen.dart';
import 'presentation/feed/feed_screen.dart';
import 'data/datasources/remote/product_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/services/api_service.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'presentation/feed/feed_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme(
          primary: Color(0xFF53C2C3),
          secondary: Color(0xFF2C3646),
          surface: Colors.white,
          background: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/feed': (context) => ChangeNotifierProvider(
          create: (_) {
            final apiService = ApiService();
            final remoteDataSource = ProductRemoteDataSource(apiService);
            final repository = ProductRepositoryImpl(remoteDataSource);
            final useCase = GetProductsUseCase(repository);
            return FeedViewModel(useCase)..loadInitialProducts();
          },
          child: const FeedScreen(),
        ),
      },
    );
  }
}