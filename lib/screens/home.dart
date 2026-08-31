import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Good afternoon',
                                  style: body(11.5, weight: FontWeight.w600, color: AppColors.inkSecondary)),
                              const SizedBox(height: 2),
                              Text('Ayesha', style: heading(21)),
                            ],
                          ),
                        ),
                        _circleBtn(glyph('bell'), AppColors.surface, AppColors.ink, () {}),
                        const SizedBox(width: 10),
                        _circleBtn(glyph('user'), AppColors.accent, AppColors.surface,
                            () => go(context, '/profile')),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Find your next look with AI.', style: heading(25).copyWith(height: 1.25)),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () => go(context, '/aiEmpty'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.accent.withValues(alpha: 0.18), width: 1.5),
                              boxShadow: AppShadows.soft,
                            ),
                            child: Row(children: [
                              const Icon(Icons.auto_awesome, size: 18, color: AppColors.accent),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text('What are you looking for today?',
                                    style: body(13.5, color: AppColors.inkFaint)),
                              ),
                              GestureDetector(
                                onTap: () => go(context, '/imageSearchIntro'),
                                child: Icon(glyph('camera'), size: 18),
                              ),
                              const SizedBox(width: 12),
                              Icon(glyph('mic'), size: 18),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _row(context, 'For You', () => go(context, '/recommendations'),
                      [1, 3, 6, 9].map((i) => kProducts[i]).toList()),
                  const SizedBox(height: 28),
                  _row(context, 'Trending Now', () => go(context, '/search'), kProducts.take(6).toList()),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFE4C5BA).withValues(alpha: 0.35),
                          const Color(0xFFE4C5BA).withValues(alpha: 0),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        SectionHeader('Discover Local',
                            subtitle: "Fresh finds from Pakistan's emerging labels",
                            onSeeAll: () => go(context, '/discoverLocal')),
                        SizedBox(
                          height: 288,
                          child: HScroller([
                            for (final p in kProducts.where((p) => p.emerging))
                              ProductCard(p, compact: true),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _chipRow(context, 'Shop by Occasion',
                      ['Eid', 'Wedding', 'Office', 'Casual', 'Festive', 'Dinner']),
                  const SizedBox(height: 28),
                  _chipRow(context, 'Shop by Category', kCategoryOptions),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Text('Popular Brands', style: heading(18)),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      for (final b in kBrands)
                        Padding(
                          padding: const EdgeInsets.only(right: 18),
                          child: GestureDetector(
                            onTap: () {
                              state.selectedBrandId = b.id;
                              go(context, '/brandProfile');
                            },
                            child: SizedBox(
                              width: 68,
                              child: Column(children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(color: AppColors.sand, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Text(b.initial, style: heading(18, color: AppColors.accent)),
                                ),
                                const SizedBox(height: 7),
                                Text(b.name,
                                    textAlign: TextAlign.center,
                                    style: body(10.5, weight: FontWeight.w600, height: 1.25)),
                              ]),
                            ),
                          ),
                        ),
                    ]),
                  ),
                  if (state.recentlyViewed.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    _row(context, 'Recently Viewed', null, state.recentProducts),
                  ],
                ],
              ),
            ),
            const LibasBottomNav(active: 'home'),
          ],
        );
      },
    );
  }

  Widget _circleBtn(IconData icon, Color bg, Color fg, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: bg == AppColors.surface ? Border.all(color: AppColors.hairline) : null,
          ),
          child: Icon(icon, size: 17, color: fg),
        ),
      );

  Widget _row(BuildContext context, String title, VoidCallback? seeAll, List<Product> products) => Column(
        children: [
          SectionHeader(title, onSeeAll: seeAll),
          SizedBox(
            height: 288,
            child: HScroller([for (final p in products) ProductCard(p, compact: true)]),
          ),
        ],
      );

  Widget _chipRow(BuildContext context, String title, List<String> labels) {
    final state = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(title, style: heading(18)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            for (final l in labels)
              Padding(
                padding: const EdgeInsets.only(right: 9),
                child: GestureDetector(
                  onTap: () {
                    state.searchQuery = l;
                    go(context, '/searchResults');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(l, style: body(12.5, weight: FontWeight.w600)),
                  ),
                ),
              ),
          ]),
        ),
      ],
    );
  }
}
