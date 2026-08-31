import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class _BackBtn extends StatelessWidget {
  final VoidCallback? onTap;
  const _BackBtn({this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap ?? () => goBack(context),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.chevron_left, size: 17),
        ),
      );
}

class ImageSearchIntroScreen extends StatelessWidget {
  const ImageSearchIntroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, kTopInset, 20, 0),
          child: _BackBtn(),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 22, 26, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('See it. Find it.', style: heading(26)),
                const SizedBox(height: 8),
                Text(
                  'Upload an outfit or clothing image and LibasAI will find visually similar products across every brand.',
                  style: body(13.5, color: AppColors.inkSecondary, height: 1.55),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => go(context, '/imagePreview'),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.35),
                          width: 1.5,
                          style: BorderStyle.solid),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(glyph('upload'), size: 30, color: AppColors.accent),
                        const SizedBox(height: 10),
                        Text('Drop an image, or choose below',
                            style: body(13, weight: FontWeight.w600, color: AppColors.inkFaint)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: PrimaryButton('Take Photo',
                        icon: glyph('camera'), onTap: () => go(context, '/imagePreview')),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: SecondaryButton('Gallery', onTap: () => go(context, '/imagePreview'))),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BackBtn(onTap: () => go(context, '/imageSearchIntro')),
              Text('Preview', style: body(14.5, weight: FontWeight.w700)),
              const SizedBox(width: 36),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            child: Column(
              children: [
                Expanded(
                  child: StripePlaceholder(
                    label: 'UPLOADED PHOTO — your reference image',
                    radius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tool(glyph('crop'), 'Crop'),
                    const SizedBox(width: 22),
                    _tool(glyph('rotate'), 'Rotate'),
                    const SizedBox(width: 22),
                    _tool(glyph('refresh'), 'Retake'),
                  ],
                ),
                const SizedBox(height: 22),
                PrimaryButton('Find Similar Styles', onTap: () => go(context, '/imageScanning')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tool(IconData icon, String label) => Column(children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 18),
        ),
        const SizedBox(height: 6),
        Text(label, style: body(10.5, weight: FontWeight.w600, color: AppColors.inkSecondary)),
      ]);
}

class ImageScanningScreen extends StatefulWidget {
  const ImageScanningScreen({super.key});
  @override
  State<ImageScanningScreen> createState() => _ImageScanningScreenState();
}

class _ImageScanningScreenState extends State<ImageScanningScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2100))..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/imageResults');
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFF7EDDF);
    return Container(
      color: AppColors.ink,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 240,
            height: 320,
            child: Stack(
              children: [
                Positioned.fill(
                  child: StripePlaceholder(dark: true, radius: BorderRadius.circular(20)),
                ),
                AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => Positioned(
                    top: 6 + _c.value * 280,
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Colors.transparent, cream, Colors.transparent]),
                        boxShadow: [BoxShadow(color: cream.withValues(alpha: 0.5), blurRadius: 12)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text('Finding similar pieces…',
              style: body(13.5, weight: FontWeight.w600, color: cream.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

class ImageResultsScreen extends StatelessWidget {
  const ImageResultsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = [2, 4, 7, 0, 9, 11].map((i) => kProducts[i]).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 30),
      children: [
        Row(children: [
          _BackBtn(onTap: () => go(context, '/imageSearchIntro')),
          const SizedBox(width: 10),
          SizedBox(
            width: 44,
            height: 44,
            child: StripePlaceholder(radius: BorderRadius.circular(12)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text('Styles similar to your image', style: heading(17))),
        ]),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 14,
          childAspectRatio: 0.56,
          children: [for (final p in items) ProductCard(p)],
        ),
      ],
    );
  }
}
