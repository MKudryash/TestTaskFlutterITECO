import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/services/api_service.dart';
import 'feed_view_model.dart';
import 'widgets/product_card.dart';
import 'widgets/shimmer_loading.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedViewModel(
        ProductRepository(ApiService()),
      )..loadInitialProducts(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Товары',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                centerTitle: true,
                background: Container(
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
                ),
              ),
            ),
            Consumer<FeedViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.error != null) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Ошибка загрузки',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            viewModel.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              viewModel.clearError();
                              viewModel.loadInitialProducts();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF53C2C3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (viewModel.isLoading && viewModel.products.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: ShimmerLoading(),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (index >= viewModel.products.length - 3) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            viewModel.loadMoreProducts();
                          });
                        }

                        return ProductCard(
                          product: viewModel.products[index],
                          index: index,
                        );
                      },
                      childCount: viewModel.products.length,
                    ),
                  ),
                );
              },
            ),

            Consumer<FeedViewModel>(
              builder: (context, viewModel, child) {
                if (!viewModel.isLoading || viewModel.products.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                return SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF53C2C3).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF53C2C3),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}