import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

void _showExitModal(BuildContext context, String brandName) {
  showDialog(
    context: context,
    barrierColor: AppColors.ink.withValues(alpha: 0.5),
    builder: (context) => Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("You're leaving LibasAI", style: heading(18), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text("You'll continue your purchase on $brandName's official website.",
                textAlign: TextAlign.center, style: body(12.5, color: AppColors.inkSecondary)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Continue to Brand',
                    style: body(13.5, weight: FontWeight.w700, color: AppColors.surface)),
              ),
            ),
            const SizedBox(height: 9),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: body(13.5, weight: FontWeight.w600, color: AppColors.inkSecondary)),
            ),
          ],
        ),
      ),
    ),
  );
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final p = productById(state.selectedProductId);
        return Container(
          color: AppColors.surface,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 1,
                      child: StripePlaceholder(
                          label: p.imgLabel,
                          imageUrl: p.imageUrl,
                          decodeWidth: 460)),
                  Positioned(
                    top: kTopInset,
                    left: 16,
                    child: _round(Icons.chevron_left, () => goBack(context)),
                  ),
                  Positioned(
                    top: kTopInset,
                    right: 16,
                    child: Row(children: [
                      _round(state.isWished(p.id) ? Icons.favorite : Icons.favorite_border,
                          () => state.toggleWish(p.id),
                          fg: AppColors.accent),
                      const SizedBox(width: 8),
                      _round(glyph('share'), () {}),
                    ]),
                  ),
                  Positioned(
                    bottom: 14,
                    right: 14,
                    child: GestureDetector(
                      onTap: () => go(context, '/imageGallery'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                        decoration: BoxDecoration(
                            color: AppColors.ink.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(AppRadius.pill)),
                        child: Text('View Gallery',
                            style: body(11, weight: FontWeight.w600, color: AppColors.surface)),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.brand.toUpperCase(), style: overline(11.5, color: AppColors.mutedRose)),
                    const SizedBox(height: 5),
                    Text(p.title, style: heading(22).copyWith(height: 1.3)),
                    const SizedBox(height: 10),
                    Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                      Text(p.price, style: body(19, weight: FontWeight.w700)),
                      if (p.hasOldPrice) ...[
                        const SizedBox(width: 9),
                        Text(p.oldPrice,
                            style: body(14, color: AppColors.ink.withValues(alpha: 0.35))
                                .copyWith(decoration: TextDecoration.lineThrough)),
                      ],
                    ]),
                    if (p.colors.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Text('Color', style: body(12.5, weight: FontWeight.w700)),
                      const SizedBox(height: 9),
                      Row(children: [
                        for (final c in p.colors)
                          Padding(
                            padding: const EdgeInsets.only(right: 9),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(c),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border, width: 2),
                              ),
                            ),
                          ),
                      ]),
                    ],
                    const SizedBox(height: 20),
                    Text('Size', style: body(12.5, weight: FontWeight.w700)),
                    const SizedBox(height: 9),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final s in p.sizes)
                        Builder(builder: (context) {
                          final available = p.sizeAvailable(s);
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: available ? null : AppColors.sand,
                              border: Border.all(color: AppColors.border, width: 1.5),
                            ),
                            child: Text(s,
                                style: body(12.5,
                                        weight: FontWeight.w700,
                                        color: available
                                            ? AppColors.ink
                                            : AppColors.ink.withValues(alpha: 0.35))
                                    .copyWith(
                                        decoration: available
                                            ? null
                                            : TextDecoration.lineThrough)),
                          );
                        }),
                    ]),
                    if (p.sizes.any((s) => !p.sizeAvailable(s))) ...[
                      const SizedBox(height: 7),
                      Text('Struck-through sizes are sold out on the brand site',
                          style: body(11, color: AppColors.inkSecondary)),
                    ],
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                          color: AppColors.sand, borderRadius: BorderRadius.circular(AppRadius.button)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.auto_awesome, size: 14, color: AppColors.accent),
                            const SizedBox(width: 7),
                            Text('Why LibasAI recommends this',
                                style: body(12, weight: FontWeight.w700, color: AppColors.accent)),
                          ]),
                          const SizedBox(height: 5),
                          Text(
                              'Matches your preferred maroon tones, formal style and wedding-guest budget.',
                              style: body(12.5, color: AppColors.inkSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => state.toggleCompareSelect(p.id),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            side: BorderSide(color: AppColors.border, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          ),
                          child: Text('Compare', style: body(13, weight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => go(context, '/aiChat'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.ink,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          ),
                          child: Text('Ask AI',
                              style: body(13, weight: FontWeight.w700, color: AppColors.bg)),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    PrimaryButton('Visit Brand Website',
                        onTap: () => _showExitModal(context, p.brand)),
                    const SizedBox(height: 30),
                    Text('Similar Products', style: heading(17)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 288,
                      child: HScroller(
                        [for (final sp in kProducts.take(4)) ProductCard(sp, compact: true)],
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text('More From ${p.brand}', style: heading(17)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 288,
                      child: HScroller(
                        [
                          for (final sp in kProducts.where((x) => x.brandId == p.brandId && x.id != p.id))
                            ProductCard(sp, compact: true)
                        ],
                        padding: EdgeInsets.zero,
                      ),
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

  Widget _round(IconData icon, VoidCallback onTap, {Color fg = AppColors.ink}) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.9), shape: BoxShape.circle),
          child: Icon(icon, size: 17, color: fg),
        ),
      );
}

class ImageGalleryScreen extends StatelessWidget {
  const ImageGalleryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = productById(AppScope.of(context).selectedProductId);
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('${p.imgLabel} — full screen view',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'monospace', fontSize: 11, color: Color(0x80F7EDDF))),
            ),
          ),
          Positioned(
            top: kTopInset,
            right: 16,
            child: GestureDetector(
              onTap: () => goBack(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 18, color: Color(0xFFF7EDDF)),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 20,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7EDDF).withValues(alpha: i == 0 ? 1 : 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductComparisonScreen extends StatelessWidget {
  const ProductComparisonScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final ids = state.compareIds.isNotEmpty ? state.compareIds : ['p1', 'p2', 'p6'];
        final items = ids.map(productById).toList();
        return Container(
          color: AppColors.surface,
          child: Column(
            children: [
              const ScreenHeader('Compare'),
              Expanded(
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 96),
                            for (final p in items)
                              SizedBox(
                                width: 120,
                                child: Column(children: [
                                  SizedBox(
                                    width: 110,
                                    child: AspectRatio(
                                      aspectRatio: 3 / 4,
                                      child: StripePlaceholder(
                                          radius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(p.title,
                                      textAlign: TextAlign.center,
                                      style: body(11, weight: FontWeight.w700, height: 1.3)),
                                ]),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _r('Brand', items, (p) => p.brand),
                        _r('Price', items, (p) => p.price, accent: true),
                        _r('Sizes', items, (p) => p.sizes.join(', ')),
                        _r('Availability', items, (p) => 'In Stock'),
                        _r('LibasAI Take', items,
                            (p) => items.first == p ? 'Best match for your style & budget' : 'Great alternative in range'),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
                decoration:
                    BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
                child: Row(children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => go(context, '/aiChat'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.ink,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      ),
                      child: Text('Ask AI Which Is Better',
                          style: body(13, weight: FontWeight.w700, color: AppColors.bg)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _showExitModal(context, items.first.brand),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      ),
                      child: Text('Visit Brand',
                          style: body(13, weight: FontWeight.w700, color: AppColors.surface)),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _r(String label, List<Product> items, String Function(Product) val, {bool accent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(label,
                style: body(11.5, weight: FontWeight.w700, color: AppColors.inkSecondary)),
          ),
          for (final p in items)
            SizedBox(
              width: 120,
              child: Text(val(p),
                  textAlign: TextAlign.center,
                  style: body(accent ? 13 : 11,
                      weight: accent ? FontWeight.w700 : FontWeight.w500,
                      color: accent ? AppColors.accent : AppColors.ink)),
            ),
        ],
      ),
    );
  }
}
