import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class DashboardScreen extends StatefulWidget {
  final Function(String tab) onNavigate;
  const DashboardScreen({super.key, required this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _api = ApiClient();
  AdminStats? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final s = await _api.fetchStats();
    if (mounted) {
      setState(() {
        _stats = s;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _stats == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }
    final s = _stats!;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        // Welcome Banner & Quick Intro
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        'ENTERPRISE OPERATIONS · LIVE PLATFORM CONTROL',
                        style: overline(9.5, color: AppColors.surface),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Executive Operations & Discovery Dashboard',
                      style: heading(22, color: AppColors.surface),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Real-time control over multi-brand scrapers, verified master darzi logistics, AI prompt governance, and discovery-to-redirect traffic.',
                      style: body(12.5, color: AppColors.surface.withValues(alpha: 0.85)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              PrimaryButton(
                'Scrape All Brands',
                icon: Icons.refresh_rounded,
                onTap: () => widget.onNavigate('brands'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Key Metrics Grid
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatCard(
              title: 'Total Products Indexed',
              value: '${s.totalProducts}',
              subtitle: 'From 15+ live brand stores',
              icon: Icons.inventory_2_outlined,
              color: AppColors.accent,
              onTap: () => widget.onNavigate('catalog'),
            ),
            _buildStatCard(
              title: 'Active Brand Partners',
              value: '${s.totalBrands}',
              subtitle: '${s.luxuryBrands} Flagship · ${s.emergingBrands} Emerging',
              icon: Icons.storefront_outlined,
              color: const Color(0xFF2E7D32),
              onTap: () => widget.onNavigate('brands'),
            ),
            _buildStatCard(
              title: 'Verified Master Darzis',
              value: '${s.activeTailors}',
              subtitle: 'Lahore, KHI, ISB, RWP',
              icon: Icons.content_cut_outlined,
              color: const Color(0xFFD97706),
              onTap: () => widget.onNavigate('tailors'),
            ),
            _buildStatCard(
              title: 'Active Stitching Requests',
              value: '${s.activeOrders}',
              subtitle: 'Real-time 5-stage tracking',
              icon: Icons.local_shipping_outlined,
              color: const Color(0xFF7C3AED),
              onTap: () => widget.onNavigate('orders'),
            ),
            _buildStatCard(
              title: 'Outbound Brand Redirects',
              value: '${s.outboundClicks}',
              subtitle: 'Discovery leads generated',
              icon: Icons.open_in_new_rounded,
              color: const Color(0xFF0284C7),
              onTap: null,
            ),
            _buildStatCard(
              title: 'Emerging Brand Fair Share',
              value: '${s.emergingSharePercent}%',
              subtitle: 'CCP Fair Market Compliance',
              icon: Icons.balance_outlined,
              color: const Color(0xFFE11D48),
              onTap: null,
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Middle Section: Outbound Traffic & Trending Queries
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Outbound Brand Traffic
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Outbound Traffic per Brand', style: heading(16)),
                            const SizedBox(height: 2),
                            Text('Customer click-throughs to official e-commerce checkouts',
                                style: body(11.5, color: AppColors.inkSecondary)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.sand,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Live Metrics', style: body(10.5, weight: FontWeight.w700, color: AppColors.accent)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ...s.brandClicks.entries.map((e) {
                      final maxClick = 350;
                      final ratio = (e.value / maxClick).clamp(0.05, 1.0);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.key, style: body(12, weight: FontWeight.w600)),
                                Text('${e.value} redirects', style: body(11.5, weight: FontWeight.w700, color: AppColors.accent)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 8,
                                backgroundColor: AppColors.hairline,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  e.key == 'Vanya' || e.key == 'Beechtree' ? const Color(0xFFE11D48) : AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Trending Searches & AI Topics
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Trending Customer Queries', style: heading(16)),
                            const SizedBox(height: 2),
                            Text('Top search terms analyzed by AI', style: body(11.5, color: AppColors.inkSecondary)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.tune, size: 18),
                          tooltip: 'Tune AI & Taxonomy',
                          onPressed: () => widget.onNavigate('ai_tuning'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...s.trendingQueries.map((q) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.sand.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.hairline),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.trending_up, size: 16, color: AppColors.accent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(q['query'].toString(), style: body(12, weight: FontWeight.w600)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.hairline),
                              ),
                              child: Text('${q['count']} hits',
                                  style: body(10.5, weight: FontWeight.w700, color: AppColors.inkSecondary)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                if (onTap != null)
                  Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.inkFaint),
              ],
            ),
            const SizedBox(height: 14),
            Text(value, style: heading(26).copyWith(color: AppColors.ink)),
            const SizedBox(height: 4),
            Text(title, style: body(12, weight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 2),
            Text(subtitle, style: body(11, color: AppColors.inkSecondary)),
          ],
        ),
      ),
    );
  }
}
