import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const menu = [
      ('My Preferences', 'sparkle', '/myPreferences'),
      ('Wishlist', 'heart', '/wishlist'),
      ('Saved Looks', 'star', '/savedLooks'),
      ('Search History', 'clock', '/searchHistory'),
      ('Recently Viewed', 'grid', '/recentlyViewed'),
      ('Settings', 'filter', '/settings'),
    ];
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 24),
            children: [
              Column(children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('A', style: heading(28, color: AppColors.surface)),
                ),
                const SizedBox(height: 12),
                Text('Ayesha Khan', style: heading(19)),
                const SizedBox(height: 2),
                Text('ayesha.khan@email.com',
                    style: body(12.5, color: AppColors.inkSecondary)),
              ]),
              const SizedBox(height: 26),
              for (final m in menu)
                GestureDetector(
                  onTap: () => go(context, m.$3),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
                    decoration: BoxDecoration(
                        color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.button)),
                    child: Row(children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: AppColors.sand, borderRadius: BorderRadius.circular(11)),
                        child: Icon(glyph(m.$2), size: 16, color: AppColors.accent),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Text(m.$1, style: body(13.5, weight: FontWeight.w600))),
                      Icon(glyph('chevronRight'), size: 15, color: AppColors.inkFaint),
                    ]),
                  ),
                ),
            ],
          ),
        ),
        const LibasBottomNav(active: 'profile'),
      ],
    );
  }
}

class MyPreferencesScreen extends StatelessWidget {
  const MyPreferencesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        Widget group(String title, List<Widget> chips) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: body(12.5, weight: FontWeight.w700)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: chips),
                const SizedBox(height: 22),
              ],
            );

        return Column(
          children: [
            const ScreenHeader('My Preferences'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                children: [
                  Text('These preferences help LibasAI personalize recommendations.',
                      style: body(12.5, color: AppColors.inkSecondary)),
                  const SizedBox(height: 20),
                  group('Categories', [
                    for (final c in kCategoryOptions)
                      SelectChip(c,
                          active: state.prefCategories.contains(c),
                          onTap: () => state.toggleSetMember(state.prefCategories, c)),
                  ]),
                  group('Styles', [
                    for (final c in kStyleOptions)
                      SelectChip(c,
                          active: state.prefStyles.contains(c),
                          onTap: () => state.toggleSetMember(state.prefStyles, c)),
                  ]),
                  group('Preferred Brands', [
                    for (final b in kBrands)
                      SelectChip(b.name,
                          active: state.prefBrands.contains(b.name),
                          onTap: () => state.toggleSetMember(state.prefBrands, b.name)),
                  ]),
                  group('Budget', [
                    for (final b in kBudgetOptions)
                      SelectChip(b,
                          active: state.prefBudget.contains(b),
                          onTap: () => state.toggleSetMember(state.prefBudget, b)),
                  ]),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 26),
              decoration:
                  BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
              child: PrimaryButton('Save Preferences', onTap: () => goBack(context)),
            ),
          ],
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Column(
          children: [
            const ScreenHeader('Settings'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.hairline))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Notifications', style: body(13.5, weight: FontWeight.w600)),
                        Toggle(
                            value: state.settingsNotif,
                            onTap: () =>
                                state.set(() => state.settingsNotif = !state.settingsNotif)),
                      ],
                    ),
                  ),
                  for (final row in const [
                    ('Account', false),
                    ('Privacy', false),
                    ('Appearance', false),
                    ('Help', false),
                    ('About LibasAI', false),
                    ('Logout', true),
                  ])
                    GestureDetector(
                      onTap: () {
                        if (row.$2) goAndReset(context, '/welcome');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.hairline))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(row.$1,
                                style: body(13.5,
                                    weight: FontWeight.w600,
                                    color: row.$2 ? AppColors.accent : AppColors.ink)),
                            Icon(glyph('chevronRight'), size: 15, color: AppColors.inkFaint),
                          ],
                        ),
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
