import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class TailorsAdminScreen extends StatefulWidget {
  const TailorsAdminScreen({super.key});

  @override
  State<TailorsAdminScreen> createState() => _TailorsAdminScreenState();
}

class _TailorsAdminScreenState extends State<TailorsAdminScreen> {
  final _api = ApiClient();
  List<AdminTailor>? _tailors;
  String _selectedCity = 'All';
  String _searchQuery = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final tailors = await _api.listTailors();
    if (mounted) {
      setState(() {
        _tailors = tailors;
        _loading = false;
      });
    }
  }

  Future<void> _toggleStatus(AdminTailor tailor) async {
    final nextStatus = tailor.status == 'accepting'
        ? 'at_capacity'
        : tailor.status == 'at_capacity'
            ? 'suspended'
            : 'accepting';
    await _api.updateTailorStatus(tailor.id, nextStatus);
    if (!mounted) return;
    setState(() => tailor.status = nextStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updated ${tailor.name} status to "$nextStatus"'),
        backgroundColor: AppColors.accent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showRateCard(AdminTailor t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: AppColors.accent),
            const SizedBox(width: 8),
            Text('${t.name} · Rate Card', style: heading(18)),
          ],
        ),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Standard bespoke tailoring prices configured for doorstep clients:',
                  style: body(12, color: AppColors.inkSecondary)),
              const SizedBox(height: 16),
              ...t.rates.entries.map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.sand.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: body(12.5, weight: FontWeight.w600)),
                        Text('Rs. ${e.value}',
                            style: body(13, weight: FontWeight.w700, color: AppColors.accent)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: body(13, weight: FontWeight.w700, color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _tailors == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }

    final cities = ['All', 'Lahore', 'Karachi', 'Islamabad', 'Rawalpindi', 'Faisalabad'];
    final filtered = _tailors!.where((t) {
      if (_selectedCity != 'All' && t.city != _selectedCity) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matches = t.name.toLowerCase().contains(q) ||
            t.location.toLowerCase().contains(q) ||
            t.specialties.any((s) => s.toLowerCase().contains(q));
        if (!matches) return false;
      }
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Master Tailor (Darzi) Network Operations', style: heading(22)),
                const SizedBox(height: 4),
                Text('Supervise verified artisan ateliers, availability status, and rate card configurations.',
                    style: body(12.5, color: AppColors.inkSecondary)),
              ],
            ),
            PrimaryButton('Add Master Tailor', icon: Icons.add, onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Onboarding portal opens external verification modal')),
              );
            }),
          ],
        ),
        const SizedBox(height: 24),

        // Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search by tailor name, city, or specialty…',
                    hintStyle: body(12.5, color: AppColors.inkFaint),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    border: InputBorder.none,
                  ),
                  style: body(13),
                ),
              ),
              const SizedBox(width: 16),
              Wrap(
                spacing: 8,
                children: cities.map((c) {
                  final active = c == _selectedCity;
                  return ChoiceChip(
                    label: Text(c),
                    selected: active,
                    onSelected: (_) => setState(() => _selectedCity = c),
                    selectedColor: AppColors.accent,
                    labelStyle: TextStyle(
                      color: active ? AppColors.surface : AppColors.ink,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      fontSize: 11.5,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tailors Table
        ...filtered.map((t) {
          final isAccepting = t.status == 'accepting';
          final isCapacity = t.status == 'at_capacity';
          final statusColor = isAccepting
              ? const Color(0xFF15803D)
              : isCapacity
                  ? const Color(0xFFB45309)
                  : const Color(0xFFB91C1C);
          final statusLabel = isAccepting
              ? 'Accepting Orders'
              : isCapacity
                  ? 'At Full Capacity'
                  : 'Temporarily Paused';

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.soft,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.sand,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      t.name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join(),
                      style: heading(16, color: AppColors.accent),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(t.name, style: heading(16)),
                          const SizedBox(width: 8),
                          if (t.isVerified)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified, size: 12, color: AppColors.accent),
                                  const SizedBox(width: 3),
                                  Text('VERIFIED', style: overline(8.5, color: AppColors.accent)),
                                ],
                              ),
                            ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              statusLabel,
                              style: body(11, weight: FontWeight.w700, color: statusColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${t.location} · ${t.experienceYears} Years Master Experience · ${t.turnaroundDays} days delivery',
                        style: body(12, color: AppColors.inkSecondary),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: t.specialties.map((s) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.sand.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(s, style: body(10.5, weight: FontWeight.w600, color: AppColors.inkSecondary)),
                            )).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Starting from', style: overline(9, color: AppColors.inkFaint)),
                    Text('Rs. ${t.startingPrice}',
                        style: heading(16, color: AppColors.accent)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () => _showRateCard(t),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: const Size(0, 36),
                          ),
                          child: Text('Rate Card', style: body(11.5, weight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _toggleStatus(t),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            foregroundColor: statusColor,
                            side: BorderSide(color: statusColor.withValues(alpha: 0.4)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: const Size(0, 36),
                          ),
                          child: Text('Toggle Status', style: body(11.5, weight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
