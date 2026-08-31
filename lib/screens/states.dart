import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class StatesGalleryScreen extends StatelessWidget {
  const StatesGalleryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Widget card(String label, IconData icon, String title, String sub) => Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.card)),
          child: Column(children: [
            Text(label.toUpperCase(), style: overline(11, color: AppColors.mutedRose)),
            const SizedBox(height: 10),
            Icon(icon, size: 24, color: AppColors.ink.withValues(alpha: 0.2)),
            const SizedBox(height: 10),
            Text(title, style: body(13, weight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(sub, textAlign: TextAlign.center, style: body(11.5, color: AppColors.inkSecondary)),
          ]),
        );

    return Column(
      children: [
        const ScreenHeader('Empty & Loading States'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
            children: [
              card('No Search Results', Icons.search, "We couldn't find an exact match.",
                  'Try changing your budget, color or category.'),
              card('No Internet', Icons.refresh, "You're offline.",
                  'Check your connection and try again.'),
              card('AI Temporarily Unavailable', Icons.auto_awesome,
                  'LibasAI Assistant is taking a break.', 'Try standard search in the meantime.'),
              card('Image Upload Failed', Icons.photo_camera_outlined,
                  "We couldn't process that image.", 'Try a clearer photo with good lighting.'),
              Text('PRODUCT CARD SKELETON', style: overline(11, color: AppColors.mutedRose)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.62,
                children: List.generate(2, (_) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.sand,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(height: 9, width: 60, color: const Color(0xFFEADFCB)),
                      const SizedBox(height: 6),
                      Container(height: 11, width: 110, color: const Color(0xFFEADFCB)),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
