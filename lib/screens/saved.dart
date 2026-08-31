import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Widget? action;
  const _EmptyState({required this.icon, required this.message, this.action});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
        child: Column(
          children: [
            Icon(icon, size: 34, color: AppColors.ink.withValues(alpha: 0.2)),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: body(14, weight: FontWeight.w600, color: AppColors.inkSecondary)),
            if (action != null) ...[const SizedBox(height: 14), action!],
          ],
        ),
      );
}

class _Grid extends StatelessWidget {
  final List<Product> products;
  const _Grid(this.products);
  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 14,
        childAspectRatio: 0.56,
        children: [for (final p in products) ProductCard(p)],
      );
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final items = state.wishedProducts;
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 24),
                children: [
                  Text('Wishlist', style: heading(22)),
                  const SizedBox(height: 18),
                  if (items.isEmpty)
                    _EmptyState(
                      icon: Icons.favorite_border,
                      message: 'Your future favorites will appear here.',
                      action: PrimaryButton('Explore Products', onTap: () => go(context, '/search')),
                    )
                  else
                    _Grid(items),
                ],
              ),
            ),
            const LibasBottomNav(active: 'wishlist'),
          ],
        );
      },
    );
  }
}

class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final items = state.recentProducts;
        return Column(
          children: [
            const ScreenHeader('Recently Viewed'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                children: [
                  if (items.isEmpty)
                    const _EmptyState(
                        icon: Icons.schedule, message: 'Products you view will show up here.')
                  else
                    _Grid(items),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SearchHistoryScreen extends StatelessWidget {
  const SearchHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Column(
          children: [
            ScreenHeader('Search History',
                trailingText: 'Clear', onTrailing: () => state.set(() => state.searchHistory.clear())),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 30),
                children: [
                  if (state.searchHistory.isEmpty)
                    const _EmptyState(icon: Icons.schedule, message: 'No search history yet.')
                  else
                    for (final h in List<String>.from(state.searchHistory))
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.hairline))),
                        child: Row(children: [
                          Icon(glyph('clock'), size: 15, color: AppColors.inkFaint),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                state.searchQuery = h;
                                go(context, '/searchResults');
                              },
                              child: Text(h, style: body(13.5)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => state.set(() => state.searchHistory.remove(h)),
                            child: Icon(glyph('close'), size: 14, color: AppColors.inkFaint),
                          ),
                        ]),
                      ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SavedLooksScreen extends StatelessWidget {
  const SavedLooksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Column(
          children: [
            const ScreenHeader('Saved Looks'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                children: [
                  for (final look in state.savedLooks)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(look.title, style: heading(15.5)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 133,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (final id in look.productIds)
                                  Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: StripePlaceholder(
                                      label: productById(id).title,
                                      radius: BorderRadius.circular(12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
