import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Bottom sheet: add a brand by URL, auto-detect its platform, let the human
/// confirm/override the guess before it's scraped. Pops `true` if a brand
/// was added (caller should refresh its list).
Future<bool?> showAddBrandSheet(BuildContext context, ApiClient api) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddBrandSheet(api: api),
  );
}

class _AddBrandSheet extends StatefulWidget {
  final ApiClient api;
  const _AddBrandSheet({required this.api});
  @override
  State<_AddBrandSheet> createState() => _AddBrandSheetState();
}

class _AddBrandSheetState extends State<_AddBrandSheet> {
  final _name = TextEditingController();
  final _url = TextEditingController();
  final _currency = TextEditingController(text: 'PKR');
  String _tier = 'emerging';
  Brand? _created;
  bool _busy = false;
  String? _error;

  static const _types = ['shopify', 'woocommerce', 'generic', 'unknown'];

  Future<void> _createAndDetect() async {
    if (_name.text.trim().isEmpty || _url.text.trim().isEmpty) {
      setState(() => _error = 'Name and URL are required.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      var brand = await widget.api.createBrand(
        name: _name.text.trim(),
        baseUrl: _url.text.trim(),
        tier: _tier,
        currency: _currency.text.trim().isEmpty ? 'PKR' : _currency.text.trim(),
      );
      brand = await widget.api.detectBrand(brand.id);
      setState(() => _created = brand);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _setType(String type) async {
    if (_created == null) return;
    setState(() => _busy = true);
    try {
      final b = await widget.api.updateBrand(_created!.id, {'type': type});
      setState(() => _created = b);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final created = _created;
    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text('Add brand', style: heading(20)),
            const SizedBox(height: 4),
            Text('Paste a storefront URL - the scraper figures out the platform.',
                style: body(12.5, color: AppColors.inkSecondary)),
            const SizedBox(height: 20),
            LabeledField(label: 'Brand name', controller: _name, hint: 'e.g. Khaadi', enabled: created == null),
            const SizedBox(height: 14),
            LabeledField(
                label: 'Website URL', controller: _url, hint: 'https://example.com', enabled: created == null),
            const SizedBox(height: 14),
            LabeledField(label: 'Currency', controller: _currency, hint: 'PKR', enabled: created == null),
            const SizedBox(height: 14),
            Text('Tier', style: body(12.5, weight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(children: [
              SelectChip('Established', active: _tier == 'established', onTap: () => setState(() => _tier = 'established')),
              const SizedBox(width: 10),
              SelectChip('Emerging', active: _tier == 'emerging', onTap: () => setState(() => _tier = 'emerging')),
            ]),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(_error!, style: body(12.5, color: AppColors.accent)),
            ],
            const SizedBox(height: 22),
            if (created == null)
              PrimaryButton('Add & detect platform', onTap: _busy ? null : _createAndDetect, loading: _busy)
            else ...[
              SectionHeader('Detected platform',
                  subtitle: created.detectNote ?? 'Pick the right platform below if this looks wrong.'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _types
                    .map((t) => SelectChip(t, active: created.type == t, onTap: _busy ? () {} : () => _setType(t)))
                    .toList(),
              ),
              const SizedBox(height: 22),
              PrimaryButton('Done', onTap: () => Navigator.of(context).pop(true)),
            ],
          ],
        ),
      ),
    );
  }
}
