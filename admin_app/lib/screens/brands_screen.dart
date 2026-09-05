import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'add_brand_sheet.dart';
import 'job_log_sheet.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});
  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final _api = ApiClient();
  List<Brand>? _brands;
  Map<String, ScrapeJob> _latestJobByBrand = {};
  String? _error;
  bool _publishing = false;
  bool _scrapingAll = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final brands = await _api.listBrands();
      final jobs = await _api.listJobs();
      final latest = <String, ScrapeJob>{};
      for (final j in jobs) {
        if (j.brandId != null && !latest.containsKey(j.brandId)) latest[j.brandId!] = j;
      }
      if (!mounted) return;
      setState(() {
        _brands = brands;
        _latestJobByBrand = latest;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  Future<void> _addBrand() async {
    final added = await showAddBrandSheet(context, _api);
    if (added == true) _refresh();
  }

  Future<void> _scrape(Brand b) async {
    try {
      final jobId = await _api.scrapeBrand(b.id);
      if (!mounted) return;
      showJobLogSheet(context, _api, jobId, title: 'Scraping ${b.name}');
      await Future.delayed(const Duration(seconds: 1));
      _refresh();
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _scrapeAll() async {
    setState(() => _scrapingAll = true);
    try {
      final jobId = await _api.scrapeAll();
      if (!mounted) return;
      showJobLogSheet(context, _api, jobId, title: 'Scraping all enabled brands');
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _scrapingAll = false);
    }
  }

  Future<void> _publish() async {
    setState(() => _publishing = true);
    try {
      await _api.publish();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Published to lib/data.dart', style: body(13, color: AppColors.surface)),
            backgroundColor: AppColors.accent),
      );
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  Future<void> _detect(Brand b) async {
    try {
      await _api.detectBrand(b.id);
      _refresh();
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _toggleEnabled(Brand b) async {
    try {
      await _api.updateBrand(b.id, {'enabled': !b.enabled});
      _refresh();
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _delete(Brand b) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Remove ${b.name}?', style: heading(17)),
        content: Text('This only removes it from the registry - already-scraped products stay in products.jsonl.',
            style: body(13, color: AppColors.inkSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel', style: body(13))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Remove', style: body(13, weight: FontWeight.w700, color: AppColors.accent))),
        ],
      ),
    );
    if (ok == true) {
      try {
        await _api.deleteBrand(b.id);
        _refresh();
      } catch (e) {
        _showError(e);
      }
    }
  }

  void _showError(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString(), style: body(13, color: AppColors.surface)), backgroundColor: AppColors.accent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brands = _brands;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              'Brand registry',
              subtitle: brands == null ? null : '${brands.length} brands · ${brands.where((b) => b.enabled).length} enabled',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GhostIconButton(icon: Icons.refresh, tooltip: 'Refresh', onTap: _refresh),
                  const SizedBox(width: 8),
                  SecondaryButton('Scrape all', icon: Icons.play_arrow, onTap: _scrapingAll ? null : _scrapeAll),
                  const SizedBox(width: 8),
                  PrimaryButton('Publish to app', icon: Icons.upload_rounded, onTap: _publishing ? null : _publish, loading: _publishing),
                ],
              ),
            ),
            Expanded(
              child: brands == null
                  ? Center(
                      child: _error == null
                          ? const CircularProgressIndicator(color: AppColors.accent)
                          : _ErrorState(message: _error!, onRetry: _refresh),
                    )
                  : RefreshIndicator(
                      color: AppColors.accent,
                      onRefresh: _refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
                        itemCount: brands.length,
                        itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _BrandCard(
                            brand: brands[i],
                            job: _latestJobByBrand[brands[i].id],
                            onDetect: () => _detect(brands[i]),
                            onScrape: () => _scrape(brands[i]),
                            onToggle: () => _toggleEnabled(brands[i]),
                            onDelete: () => _delete(brands[i]),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addBrand,
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add, color: AppColors.surface),
        label: Text('Add brand', style: body(13.5, weight: FontWeight.w700, color: AppColors.surface)),
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  final Brand brand;
  final ScrapeJob? job;
  final VoidCallback onDetect;
  final VoidCallback onScrape;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  const _BrandCard({
    required this.brand,
    required this.job,
    required this.onDetect,
    required this.onScrape,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  brand.name.isEmpty ? '?' : brand.name[0].toUpperCase(),
                  style: heading(17, color: AppColors.accent),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(child: Text(brand.name, style: body(15, weight: FontWeight.w700))),
                      const SizedBox(width: 8),
                      TypeBadge(brand.type),
                    ]),
                    const SizedBox(height: 3),
                    Text(brand.baseUrl,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: body(12, color: AppColors.inkSecondary)),
                    const SizedBox(height: 6),
                    Row(children: [
                      Text(brand.tier == 'established' ? 'Established' : 'Emerging',
                          style: overline(9.5, color: AppColors.mutedRose)),
                      const SizedBox(width: 10),
                      StatusPill(job?.status ?? 'none'),
                      if (job != null) ...[
                        const SizedBox(width: 8),
                        Text('· ${job!.productsCount} products', style: body(11.5, color: AppColors.inkFaint)),
                      ],
                    ]),
                  ],
                ),
              ),
              Toggle(value: brand.enabled, onTap: onToggle),
            ],
          ),
          if (brand.detectNote != null) ...[
            const SizedBox(height: 10),
            Text(brand.detectNote!, style: body(11, color: AppColors.inkFaint)),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              GhostIconButton(icon: Icons.search, tooltip: 'Detect platform', onTap: onDetect),
              const SizedBox(width: 8),
              GhostIconButton(icon: Icons.play_arrow, tooltip: 'Scrape now', onTap: onScrape),
              const Spacer(),
              GhostIconButton(icon: Icons.delete_outline, tooltip: 'Remove', color: AppColors.accent, onTap: onDelete),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off, size: 32, color: AppColors.inkFaint),
          const SizedBox(height: 12),
          Text('Could not reach the admin server', style: body(14, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center, style: body(12, color: AppColors.inkSecondary)),
          const SizedBox(height: 16),
          SecondaryButton('Retry', icon: Icons.refresh, onTap: onRetry),
        ],
      ),
    );
  }
}
