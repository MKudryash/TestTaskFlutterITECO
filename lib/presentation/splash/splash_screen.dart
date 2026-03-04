import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashViewModel(),
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {

          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.navigateToNext(context);
          });


          return const Scaffold(
            body: SizedBox.shrink(),
          );
        },
      ),
    );
  }
}