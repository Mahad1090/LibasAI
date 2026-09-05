import 'package:flutter/material.dart';
import 'theme.dart';

/// Shared chrome pieces, trimmed down from the customer app's `lib/widgets.dart`
/// (ScreenHeader, PrimaryButton, SecondaryButton, Toggle, SelectChip,
/// SectionHeader) so the admin panel reads as the same product, not a
/// separate tool bolted on. Pieces tied to the customer app's own data model
/// (ProductCard, BrandAvatar, LibasBottomNav, ...) aren't needed here.
const double kTopInset = 24;

class ScreenHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const ScreenHeader(this.title, {super.key, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, kTopInset + 20, 24, 20),
      color: AppColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: heading(24)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: body(13, color: AppColors.inkSecondary)),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool loading;
  const PrimaryButton(this.label, {super.key, this.onTap, this.icon, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.button),
        boxShadow: onTap == null ? null : AppShadows.button,
      ),
      child: Material(
        color: onTap == null ? AppColors.border : AppColors.accent,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.button),
          onTap: loading ? null : onTap,
          child: Container(
            height: 46,
            alignment: Alignment.center,
            constraints: const BoxConstraints(minWidth: 120),
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.surface),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[Icon(icon, size: 16, color: AppColors.surface), const SizedBox(width: 8)],
                      Text(label, style: body(13.5, weight: FontWeight.w700, color: AppColors.surface)),
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
  final IconData? icon;
  const SecondaryButton(this.label, {super.key, this.onTap, this.icon});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 46),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        side: BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 15, color: AppColors.ink), const SizedBox(width: 7)],
          Text(label, style: body(13, weight: FontWeight.w700, color: AppColors.ink)),
        ],
      ),
    );
  }
}

class GhostIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final Color? color;
  const GhostIconButton({super.key, required this.icon, this.onTap, this.tooltip, this.color});
  @override
  Widget build(BuildContext context) {
    final btn = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 16, color: color ?? AppColors.ink),
      ),
    );
    return tooltip == null ? btn : Tooltip(message: tooltip!, child: btn);
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: active ? AppColors.accent : AppColors.border, width: 1.5),
        ),
        child: Text(label,
            style: body(12, weight: FontWeight.w600, color: active ? AppColors.surface : AppColors.ink)),
      ),
    );
  }
}

/// A colored pill badge for a brand's detected platform type.
class TypeBadge extends StatelessWidget {
  final String type;
  const TypeBadge(this.type, {super.key});

  Color get _color => switch (type) {
        'shopify' => const Color(0xFF2F6E4E),
        'woocommerce' => const Color(0xFF7A1FB0),
        'generic' => AppColors.accent,
        _ => AppColors.inkFaint,
      };

  @override
  Widget build(BuildContext context) {
    final c = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(type.toUpperCase(), style: overline(9.5, color: c)),
    );
  }
}

/// Status dot + label for a brand's most recent job.
class StatusPill extends StatelessWidget {
  final String status; // running | success | failed | none
  const StatusPill(this.status, {super.key});

  (Color, String) get _spec => switch (status) {
        'running' => (const Color(0xFFC99A2E), 'Running'),
        'success' => (const Color(0xFF2F6E4E), 'Success'),
        'failed' => (const Color(0xFF9F1733), 'Failed'),
        _ => (AppColors.inkFaint, 'Never run'),
      };

  @override
  Widget build(BuildContext context) {
    final (c, label) = _spec;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: body(12, weight: FontWeight.w600, color: c)),
      ],
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

/// Text field styled like the customer app's auth screens (`lib/screens/auth.dart`).
class LabeledField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool enabled;
  const LabeledField({super.key, required this.label, required this.controller, this.hint, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: body(12.5, weight: FontWeight.w600)),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          enabled: enabled,
          style: body(14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: body(14, color: AppColors.inkFaint),
            filled: true,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: BorderSide(color: AppColors.border, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionHeader(this.title, {super.key, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: heading(17)),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: body(11.5, color: AppColors.inkSecondary)),
          ],
        ],
      ),
    );
  }
}
