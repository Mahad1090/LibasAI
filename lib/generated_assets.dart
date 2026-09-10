import 'package:flutter/material.dart';

/// Thin helpers over the bundled image assets.
///
/// These images used to be inlined into this file as ~4.7 MB of base64 string
/// literals, which bloated `main.dart.js` and ran `base64Decode` on startup.
/// They are declared as normal assets in `pubspec.yaml`, decoded lazily, and
/// downsampled at decode time so a 1 MB photo never rasterises at full size
/// into a small banner.
class AppAssets {
  static Widget onboardingImage(int step, {BoxFit fit = BoxFit.cover, Widget? fallback}) {
    if (step < 1 || step > 3) return fallback ?? const SizedBox.shrink();
    return Image.asset(
      'assets/onboarding_$step.jpg',
      fit: fit,
      gaplessPlayback: true,
      cacheWidth: 900,
      errorBuilder: (context, error, stackTrace) => fallback ?? const SizedBox.shrink(),
    );
  }

  static Widget brandCoverImage({BoxFit fit = BoxFit.cover, Widget? fallback}) {
    return Image.asset(
      'assets/brand_cover.jpg',
      fit: fit,
      gaplessPlayback: true,
      cacheWidth: 900,
      errorBuilder: (context, error, stackTrace) => fallback ?? const SizedBox.shrink(),
    );
  }
}
