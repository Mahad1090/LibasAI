import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        Widget section(String title, String? sub, List<Product> products) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: heading(17)),
                      if (sub != null) ...[
                        const SizedBox(height: 2),
                        Text(sub, style: body(11.5, color: AppColors.inkSecondary)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 288,
                  child: HScroller([for (final p in products) ProductCard(p, compact: true)]),
                ),
                const SizedBox(height: 24),
              ],
            );

        return Column(
          children: [
            const ScreenHeader('For You'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 18),
                children: [
                  section('Based on your style', 'Because you liked embroidered kurtas',
                      [1, 3, 6, 9].map((i) => kProducts[i]).toList()),
                  if (state.wishedProducts.isNotEmpty)
                    section('Based on your wishlist', null, state.wishedProducts),
                  if (state.recentProducts.isNotEmpty)
                    section('Inspired by recent views', null, state.recentProducts),
                  section('Within your budget', null, kProducts.sublist(6, 10)),
                  section('Discover something new', null,
                      kProducts.where((p) => p.emerging).toList()),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OutfitBoard extends StatelessWidget {
  const _OutfitBoard();
  @override
  Widget build(BuildContext context) {
    final main = productById('p1');
    final pieces = ['p11', 'p13', 'p14'].map(productById).toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ProductCard(main),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.62,
            children: [for (final p in pieces) ProductCard(p)],
          ),
        ],
      ),
    );
  }
}

class OutfitBuilderScreen extends StatelessWidget {
  const OutfitBuilderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ScreenHeader('Build My Look'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
            children: [
              Text(
                '"Style this kurta for a wedding." LibasAI builds a complete look around your starting piece.',
                style: body(13, color: AppColors.inkSecondary, height: 1.55),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: PrimaryButton('From Product', onTap: () => go(context, '/outfitResult'))),
                const SizedBox(width: 10),
                Expanded(child: SecondaryButton('Occasion', onTap: () => go(context, '/outfitResult'))),
              ]),
              const SizedBox(height: 26),
              Text('Editorial Outfit Board', style: heading(17)),
              const SizedBox(height: 14),
              const _OutfitBoard(),
              const SizedBox(height: 20),
              PrimaryButton('See Full Outfit', onTap: () => go(context, '/outfitResult')),
            ],
          ),
        ),
      ],
    );
  }
}

class OutfitResultScreen extends StatelessWidget {
  const OutfitResultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Column(
      children: [
        const ScreenHeader('Your Outfit'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
            children: [
              Text('Wedding Guest, Maroon & Gold', style: heading(19)),
              const SizedBox(height: 4),
              Text(
                'The embroidered kurta anchors the look — dusty rose dupatta softens it, gold jhumkas and nude khussa keep it festive without overpowering.',
                style: body(12.5, color: AppColors.inkSecondary),
              ),
              const SizedBox(height: 16),
              const _OutfitBoard(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                    color: AppColors.sand, borderRadius: BorderRadius.circular(AppRadius.button)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Combined total', style: body(12.5, weight: FontWeight.w600)),
                    Text('Rs. 16,030', style: body(15, weight: FontWeight.w700, color: AppColors.accent)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: PrimaryButton('Save Look', onTap: () {
                    state.set(() => state.savedLooks.insert(
                        0,
                        SavedLook('look${DateTime.now().millisecondsSinceEpoch}',
                            'Wedding Guest, Maroon & Gold', ['p1', 'p11', 'p13', 'p14'])));
                    go(context, '/savedLooks');
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: SecondaryButton('Alternatives',
                        onTap: () => go(context, '/productComparison'))),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
