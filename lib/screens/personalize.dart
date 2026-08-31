import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class PreferenceStep extends StatelessWidget {
  final int step;
  const PreferenceStep({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, kTopInset, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: step / 3,
                      minHeight: 4,
                      backgroundColor: AppColors.border,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('STEP $step / 3',
                      style: body(11.5, weight: FontWeight.w600, color: AppColors.inkFaint)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
                child: switch (step) {
                  1 => _stepOne(state),
                  2 => _stepTwo(state),
                  _ => _stepThree(state),
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 26),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
              child: Row(
                children: [
                  if (step == 2) ...[
                    SecondaryButtonSmall('Back', onTap: () => goBack(context)),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: PrimaryButton(
                      step == 3 ? 'Personalize My Experience' : 'Continue',
                      onTap: () => go(context, step == 3 ? '/home' : '/pref${step + 1}'),
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

  Widget _wrap(List<Widget> chips) =>
      Wrap(spacing: 9, runSpacing: 9, children: chips);

  Widget _stepOne(AppState s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What do you usually shop for?', style: heading(25)),
          const SizedBox(height: 8),
          Text('Pick as many as you like.', style: body(13.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 22),
          _wrap([
            for (final c in kCategoryOptions)
              SelectChip(c,
                  active: s.prefCategories.contains(c),
                  onTap: () => s.toggleSetMember(s.prefCategories, c)),
          ]),
        ],
      );

  Widget _stepTwo(AppState s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tell us your style', style: heading(25)),
          const SizedBox(height: 8),
          Text('This shapes what LibasAI shows you first.',
              style: body(13.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 22),
          _wrap([
            for (final c in kStyleOptions)
              SelectChip(c,
                  active: s.prefStyles.contains(c), onTap: () => s.toggleSetMember(s.prefStyles, c)),
          ]),
        ],
      );

  Widget _stepThree(AppState s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Make recommendations yours', style: heading(25)),
          const SizedBox(height: 20),
          _label('Preferred Brands'),
          _wrap([
            for (final b in kBrands)
              SelectChip(b.name,
                  active: s.prefBrands.contains(b.name),
                  onTap: () => s.toggleSetMember(s.prefBrands, b.name)),
          ]),
          const SizedBox(height: 22),
          _label('Typical Budget'),
          _wrap([
            for (final b in kBudgetOptions)
              SelectChip(b,
                  active: s.prefBudget.contains(b), onTap: () => s.toggleSetMember(s.prefBudget, b)),
          ]),
          const SizedBox(height: 22),
          _label('Favourite Colors'),
          Wrap(spacing: 12, runSpacing: 12, children: [
            for (final c in kColorSwatches)
              ColorSwatch2(c.value,
                  active: s.prefColors.contains(c.key),
                  onTap: () => s.toggleSetMember(s.prefColors, c.key)),
          ]),
          const SizedBox(height: 22),
          _label('Sizes'),
          _wrap([
            for (final sz in kSizeOptions)
              SelectChip(sz,
                  active: s.prefSizes.contains(sz), onTap: () => s.toggleSetMember(s.prefSizes, sz)),
          ]),
        ],
      );

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(t, style: body(12.5, weight: FontWeight.w700)),
      );
}

class SecondaryButtonSmall extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const SecondaryButtonSmall(this.label, {super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 54),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        side: BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
      ),
      child: Text(label, style: body(14.5, weight: FontWeight.w700, color: AppColors.ink)),
    );
  }
}
