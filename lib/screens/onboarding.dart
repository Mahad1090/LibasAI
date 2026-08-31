import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../theme.dart';
import '../widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => go(context, '/onboard1'),
      child: Container(
        color: AppColors.splash,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.82,
              child: Image.asset('assets/libasai-logo.png'),
            ),
            Positioned(
              bottom: 56,
              child: Row(
                children: List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.5),
                    child: FadeTransition(
                      opacity: Tween(begin: 0.3, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _c,
                          curve: Interval(i * 0.15, 1.0, curve: Curves.easeInOut),
                        ),
                      ),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Color(0xFFF7EDDF), shape: BoxShape.circle),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  final int step;
  const OnboardingScreen({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final data = [
      (
        'EDITORIAL COLLAGE — mixed brand products',
        'Discover Fashion Across Brands',
        'Explore Pakistani apparel brands — big and small — from one unified place.',
        null,
      ),
      (
        'CONVERSATIONAL SEARCH — UI moment',
        'Ask. Compare. Discover.',
        'Talk to LibasAI like you would a stylist friend.',
        '"Find me an embroidered black kurta under Rs. 8,000 for Eid."',
      ),
      (
        'STYLE PROFILE — UI moment',
        'Style Made Personal',
        null,
        null,
      ),
    ][step - 1];

    return Column(
      children: [
        Expanded(
          flex: step == 3 ? 36 : 44,
          child: Stack(
            children: [
              Positioned.fill(child: StripePlaceholder(label: data.$1)),
              if (step != 3)
                Positioned(
                  top: kTopInset,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => go(context, '/welcome'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text('Skip', style: body(12, weight: FontWeight.w600)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          flex: step == 3 ? 64 : 56,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(3, (i) {
                    final active = i == step - 1;
                    return Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: active ? 22 : 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: active ? AppColors.accent : AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Text(data.$2, style: heading(26)),
                const SizedBox(height: 10),
                if (data.$3 != null)
                  Text(data.$3!, style: body(14, color: AppColors.inkSecondary, height: 1.55)),
                if (data.$4 != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Text(data.$4!,
                        style: body(13, weight: FontWeight.w600, color: AppColors.accentPressed)),
                  ),
                ],
                if (step == 3) ...[
                  const SizedBox(height: 14),
                  for (final f in const [
                    ('sparkle', 'Personalized recommendations'),
                    ('camera', 'Search fashion by image'),
                    ('grid', 'AI-built outfit suggestions'),
                    ('tag', 'Local & emerging brand discovery'),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColors.sand, borderRadius: BorderRadius.circular(10)),
                          child: Icon(glyph(f.$1), size: 16, color: AppColors.accent),
                        ),
                        const SizedBox(width: 12),
                        Text(f.$2, style: body(13.5, weight: FontWeight.w600)),
                      ]),
                    ),
                ],
                const Spacer(),
                Row(
                  mainAxisAlignment:
                      step == 1 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                  children: [
                    if (step != 1)
                      GestureDetector(
                        onTap: () => goBack(context),
                        child: Text('Back',
                            style: body(13.5,
                                weight: FontWeight.w600,
                                color: AppColors.ink.withValues(alpha: 0.5))),
                      ),
                    if (step == 3)
                      PrimaryButton('Get Started', onTap: () => go(context, '/welcome'))
                    else
                      GestureDetector(
                        onTap: () => go(context, '/onboard${step + 1}'),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: AppShadows.button,
                          ),
                          child: const Icon(Icons.chevron_right, color: AppColors.surface),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
