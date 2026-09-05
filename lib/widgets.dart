import 'package:flutter/material.dart';
import 'app_scope.dart';
import 'data.dart';
import 'theme.dart';

/// Status-bar clearance used across screens (design spec: 58px top padding).
const double kTopInset = 54;

/// Maps the handoff's custom glyph names to the nearest Material icon.
IconData glyph(String name) {
  switch (name) {
    case 'chevronLeft':
      return Icons.chevron_left;
    case 'chevronRight':
      return Icons.chevron_right;
    case 'chevronDown':
      return Icons.keyboard_arrow_down;
    case 'search':
      return Icons.search;
    case 'heart':
      return Icons.favorite_border;
    case 'heartFilled':
      return Icons.favorite;
    case 'camera':
      return Icons.photo_camera_outlined;
    case 'mic':
      return Icons.mic_none;
    case 'send':
      return Icons.arrow_upward;
    case 'star':
      return Icons.star_border;
    case 'filter':
      return Icons.tune;
    case 'check':
      return Icons.check;
    case 'share':
      return Icons.ios_share;
    case 'trash':
      return Icons.delete_outline;
    case 'edit':
      return Icons.edit_outlined;
    case 'clock':
      return Icons.schedule;
    case 'bell':
      return Icons.notifications_none;
    case 'user':
      return Icons.person_outline;
    case 'sparkle':
      return Icons.auto_awesome;
    case 'upload':
      return Icons.file_upload_outlined;
    case 'crop':
      return Icons.crop;
    case 'rotate':
      return Icons.rotate_right;
    case 'refresh':
      return Icons.refresh;
    case 'close':
      return Icons.close;
    case 'grid':
      return Icons.grid_view;
    case 'tag':
      return Icons.sell_outlined;
    case 'home':
      return Icons.home_outlined;
    default:
      return Icons.circle_outlined;
  }
}

/// Brand mark: scraped logo on a light tile, falling back to the initial.
class BrandAvatar extends StatelessWidget {
  final Brand brand;
  final double size;
  final double radius; // 0 or negative => full circle
  final Color background;
  final Color foreground;
  final double fontSize;
  const BrandAvatar(
    this.brand, {
    super.key,
    this.size = 60,
    this.radius = -1,
    this.background = AppColors.sand,
    this.foreground = AppColors.accent,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final shape = radius <= 0
        ? BoxShape.circle
        : BoxShape.rectangle;
    final br = radius <= 0 ? null : BorderRadius.circular(radius);
    final initial = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: shape, borderRadius: br),
      child: Text(brand.initial, style: heading(fontSize, color: foreground)),
    );
    if (brand.logoUrl.isEmpty) return initial;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Colors.white, shape: shape, borderRadius: br),
      padding: EdgeInsets.all(size * 0.16),
      child: Image.network(
        brand.logoUrl,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.low,
        gaplessPlayback: true,
        // decode small - these are tiny on screen
        cacheWidth: (size * 2.5).round(),
        errorBuilder: (context, error, stackTrace) => initial,
      ),
    );
  }
}

class StripePlaceholder extends StatelessWidget {
  final String? label;
  final BorderRadius? radius;
  final bool dark;
  final String? imageUrl;

  /// Target decode width in logical px; the image is downsampled at decode
  /// time to ~2x this, which is the single biggest scroll-perf win.
  final int decodeWidth;
  const StripePlaceholder(
      {super.key,
      this.label,
      this.radius,
      this.dark = false,
      this.imageUrl,
      this.decodeWidth = 300});

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return RepaintBoundary(
        child: ClipRRect(
          borderRadius: radius ?? BorderRadius.zero,
          child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            filterQuality: FilterQuality.low,
            gaplessPlayback: true,
            cacheWidth: decodeWidth * 2,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : _stripe(context),
            errorBuilder: (context, error, stackTrace) => _stripe(context),
          ),
        ),
      );
    }
    return _stripe(context);
  }

  Widget _stripe(BuildContext context) {
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.zero,
      child: CustomPaint(
        painter: _StripePainter(dark: dark),
        child: Center(
          child: label == null
              ? null
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    label!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10.5,
                      color: (dark ? Colors.white : AppColors.ink).withValues(alpha: 0.4),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  final bool dark;
  _StripePainter({required this.dark});
  @override
  void paint(Canvas canvas, Size size) {
    final base = dark ? const Color(0xFF201D1C) : const Color(0xFFF2E4D2);
    final stripe = dark ? const Color(0xFF2B2827) : const Color(0xFFEADFCB);
    canvas.drawRect(Offset.zero & size, Paint()..color = base);
    final p = Paint()
      ..color = stripe
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    const gap = 24.0;
    for (double d = -size.height; d < size.width + size.height; d += gap) {
      canvas.drawLine(Offset(d, 0), Offset(d + size.height, size.height), p);
    }
  }

  @override
  bool shouldRepaint(covariant _StripePainter old) => old.dark != dark;
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  const PrimaryButton(this.label, {super.key, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.button),
        boxShadow: AppShadows.button,
      ),
      child: Material(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.button),
          onTap: onTap,
          child: Container(
            height: 54,
            alignment: Alignment.center,
            constraints: const BoxConstraints(minWidth: 150),
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[Icon(icon, size: 18, color: AppColors.surface), const SizedBox(width: 8)],
                Text(label, style: body(15, weight: FontWeight.w700, color: AppColors.surface)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const SecondaryButton(this.label, {super.key, this.onTap});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        side: BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
      ),
      child: Text(label, style: body(15, weight: FontWeight.w700, color: AppColors.ink)),
    );
  }
}

class SelectChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const SelectChip(this.label, {super.key, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: active ? AppColors.accent : AppColors.border, width: 1.5),
        ),
        child: Text(label,
            style: body(12.5, weight: FontWeight.w600, color: active ? AppColors.surface : AppColors.ink)),
      ),
    );
  }
}

class ScreenHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final String? trailingText;
  final VoidCallback? onTrailing;
  const ScreenHeader(this.title, {super.key, this.showBack = true, this.trailingText, this.onTrailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, kTopInset + 6, 20, 14),
      color: AppColors.surface,
      child: Row(
        children: [
          if (showBack)
            _SquareIconButton(icon: glyph('chevronLeft'), onTap: () => goBack(context))
          else
            const SizedBox(width: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: body(17, weight: FontWeight.w700)),
          ),
          if (trailingText != null)
            GestureDetector(
              onTap: onTrailing,
              child: Text(trailingText!, style: body(13, weight: FontWeight.w700, color: AppColors.accent)),
            ),
        ],
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SquareIconButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 18, color: AppColors.ink),
      ),
    );
  }
}

class LibasBottomNav extends StatelessWidget {
  final String active;
  const LibasBottomNav({super.key, required this.active});

  void _tap(BuildContext context, String key) {
    if (key == active) return;
    final state = AppScope.of(context);
    final target = key == 'ai' ? (state.chatMessages.isNotEmpty ? '/aiChat' : '/aiEmpty') : '/$key';
    Navigator.of(context).pushNamedAndRemoveUntil(target, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    Widget item(String key, IconData icon, String label) {
      final on = key == active;
      return Expanded(
        child: InkWell(
          onTap: () => _tap(context, key),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 21, color: on ? AppColors.accent : AppColors.inkFaint),
              const SizedBox(height: 5),
              Text(label,
                  style: body(10.5,
                      weight: FontWeight.w700, color: on ? AppColors.accent : AppColors.inkFaint)),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.97),
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            child: Row(
              children: [
                item('home', glyph('home'), 'Home'),
                item('search', glyph('search'), 'Search'),
                const Expanded(child: SizedBox()),
                item('wishlist', glyph('heart'), 'Wishlist'),
                item('profile', glyph('user'), 'Profile'),
              ],
            ),
          ),
          Positioned(
            top: -14,
            child: GestureDetector(
              onTap: () => _tap(context, 'ai'),
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.accentPressed.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 10)),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.surface, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool compact;
  const ProductCard(this.product, {super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final wished = state.isWished(product.id);
    final selected = state.compareIds.contains(product.id);
    final imageStack = Stack(
            children: [
              Positioned.fill(
                child: StripePlaceholder(
                  label: product.imgLabel,
                  imageUrl: product.imageUrl,
                  radius: BorderRadius.circular(AppRadius.card),
                ),
              ),
              if (product.emerging)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.sand, borderRadius: BorderRadius.circular(AppRadius.pill)),
                    child: Text('EMERGING',
                        style: overline(9, color: AppColors.accent)),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => state.compareMode
                      ? state.toggleCompareSelect(product.id)
                      : state.toggleWish(product.id),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: state.compareMode
                          ? (selected ? AppColors.accent : AppColors.surface)
                          : AppColors.surface.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      state.compareMode
                          ? (selected ? Icons.check : Icons.add)
                          : (wished ? Icons.favorite : Icons.favorite_border),
                      size: 15,
                      color: state.compareMode && selected ? AppColors.surface : AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          );

    final card = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (compact)
          SizedBox(height: 188, child: imageStack)
        else
          Expanded(child: AspectRatio(aspectRatio: 3 / 4, child: imageStack)),
        const SizedBox(height: 8),
        Text(product.brand.toUpperCase(),
            maxLines: 1, overflow: TextOverflow.ellipsis, style: overline(10.5, color: AppColors.mutedRose)),
        const SizedBox(height: 3),
        Text(product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: body(13.5, weight: FontWeight.w600, height: 1.3)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(product.price, style: body(13.5, weight: FontWeight.w700)),
            if (product.hasOldPrice) ...[
              const SizedBox(width: 6),
              Flexible(
                child: Text(product.oldPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: body(11.5,
                            color: AppColors.ink.withValues(alpha: 0.35), weight: FontWeight.w500)
                        .copyWith(decoration: TextDecoration.lineThrough)),
              ),
            ],
          ],
        ),
      ],
    );

    final tappable = GestureDetector(
      onTap: () {
        state.selectedProductId = product.id;
        state.pushRecent(product.id);
        go(context, '/productDetail');
      },
      child: card,
    );

    return compact ? SizedBox(width: 150, height: 278, child: tappable) : tappable;
  }
}

class HScroller extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  const HScroller(this.children, {super.key, this.padding = const EdgeInsets.symmetric(horizontal: 20)});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 14),
            children[i],
          ],
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  const SectionHeader(this.title, {super.key, this.subtitle, this.onSeeAll});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: heading(18)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: body(11.5, color: AppColors.inkSecondary)),
                ],
              ],
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text('See all', style: body(12, weight: FontWeight.w600, color: AppColors.accent)),
            ),
        ],
      ),
    );
  }
}

class Toggle extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  const Toggle({super.key, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 42,
        height: 25,
        decoration: BoxDecoration(
          color: value ? AppColors.accent : AppColors.border,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 150),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(2.5),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class ColorSwatch2 extends StatelessWidget {
  final int color;
  final bool active;
  final VoidCallback onTap;
  final double size;
  const ColorSwatch2(this.color, {super.key, required this.active, required this.onTap, this.size = 38});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(color),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: active ? const Icon(Icons.check, size: 15, color: Colors.white) : null,
      ),
    );
  }
}
