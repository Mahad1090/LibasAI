import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class DiscoverLocalScreen extends StatelessWidget {
  const DiscoverLocalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Column(
      children: [
        const ScreenHeader('Discover Local'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
            children: [
              Text(
                'Small and emerging Pakistani labels, shown alongside the brands you already know.',
                style: body(13, color: AppColors.inkSecondary, height: 1.55),
              ),
              const SizedBox(height: 22),
              for (final b in kBrands.where((b) => b.emerging))
                GestureDetector(
                  onTap: () {
                    state.selectedBrandId = b.id;
                    go(context, '/brandProfile');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          BrandAvatar(b, size: 52, radius: 16, fontSize: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Flexible(child: Text(b.name, style: heading(17))),
                                  const SizedBox(width: 8),
                                  _EmergingPill(),
                                ]),
                                const SizedBox(height: 2),
                                Text(b.tagline, style: body(12, color: AppColors.inkSecondary)),
                              ],
                            ),
                          ),
                        ]),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 288,
                          child: HScroller(
                            [
                              for (final p in kProducts.where((p) => p.brandId == b.id).take(12))
                                ProductCard(p, compact: true)
                            ],
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmergingPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
            color: AppColors.sand, borderRadius: BorderRadius.circular(AppRadius.pill)),
        child: Text('EMERGING', style: overline(9, color: AppColors.accent)),
      );
}

class BrandProfileScreen extends StatelessWidget {
  const BrandProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final b = brandById(state.selectedBrandId);
        final products = kProducts.where((p) => p.brandId == b.id).toList();
        return Container(
          color: AppColors.surface,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 150,
                child: Stack(
                  children: [
                    const Positioned.fill(child: StripePlaceholder()),
                    Positioned(
                      top: kTopInset,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => goBack(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.9),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.chevron_left, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.surface, width: 4),
                        ),
                        child: BrandAvatar(b,
                            size: 72,
                            radius: 20,
                            background: AppColors.accent,
                            foreground: AppColors.surface,
                            fontSize: 26),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(b.name, style: heading(22)),
                            if (b.emerging) ...[const SizedBox(width: 8), _EmergingPill()],
                          ]),
                          const SizedBox(height: 6),
                          Text(b.tagline, style: body(13, color: AppColors.inkSecondary)),
                          const SizedBox(height: 6),
                          Text('${b.count} products on LibasAI',
                              style: body(12, weight: FontWeight.w600, color: AppColors.inkFaint)),
                          const SizedBox(height: 18),
                          Row(children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () {},
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  minimumSize: const Size.fromHeight(48),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                ),
                                child: Text('View Website',
                                    style: body(13, weight: FontWeight.w700, color: AppColors.surface)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => go(context, '/aiChat'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48),
                                  side: BorderSide(color: AppColors.border, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                ),
                                child: Text('Ask AI', style: body(13, weight: FontWeight.w700)),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 24),
                          Text('All Products', style: heading(17)),
                        ],
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.56,
                      children: [for (final p in products) ProductCard(p)],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
