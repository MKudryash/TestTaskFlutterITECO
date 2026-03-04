import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'feed_view_model.dart';
import 'widgets/product_card.dart';
import 'widgets/shimmer_loading.dart';
import '../../core/constants/app_constants.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;
  static const double _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_isLoadingMore) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (maxScroll - currentScroll <= _scrollThreshold) {
        _isLoadingMore = true;

        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            final viewModel = context.read<FeedViewModel>();
            if (!viewModel.isLoadingMore && !viewModel.isLoading) {
              viewModel.loadMoreProducts();
            }
            _isLoadingMore = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<FeedViewModel>().refreshProducts();
        },
        color: AppConstants.primaryLight,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Товары'),
                background: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConstants.primaryDark,
                        AppConstants.primaryLight,
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
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
                            ElevatedButton.icon(
                              onPressed: () {
                                viewModel.clearError();
                                viewModel.loadInitialProducts();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Повторить'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryLight,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        ),
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

                        return Column(
                          children: [
                            ProductCard(
                              product: viewModel.products[index % viewModel.products.length],
                              index: index,
                            ),

                          ],
                        );
                      },

                      childCount: viewModel.products.isEmpty
                          ? 0
                          : 10000,
                      addAutomaticKeepAlives: true,
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

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}