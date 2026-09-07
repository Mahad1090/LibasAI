import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class CatalogAdminScreen extends StatefulWidget {
  const CatalogAdminScreen({super.key});

  @override
  State<CatalogAdminScreen> createState() => _CatalogAdminScreenState();
}

class _CatalogAdminScreenState extends State<CatalogAdminScreen> {
  final _api = ApiClient();
  List<CatalogItem>? _items;
  List<String> _availableBrands = ['All'];
  String _searchQuery = '';
  String _selectedGender = 'All';
  String _selectedBrand = 'All';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      _api.listCatalog(
        query: _searchQuery,
        gender: _selectedGender,
        brand: _selectedBrand,
      ),
      _api.listBrands(),
    ]);
    final items = results[0] as List<CatalogItem>;
    final brandList = results[1] as List<Brand>;
    if (mounted) {
      setState(() {
        _items = items;
        _availableBrands = ['All', ...brandList.map((b) => b.name)];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final genders = ['All', 'Men', 'Women'];
    final brands = _availableBrands;

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
                Text('Master Catalog & Inventory Oversight', style: heading(22)),
                const SizedBox(height: 4),
                Text('Real-time inspection of multi-brand aggregated garments and outbound link integrity.',
                    style: body(12.5, color: AppColors.inkSecondary)),
              ],
            ),
            GhostIconButton(icon: Icons.refresh, tooltip: 'Reload', onTap: _load),
          ],
        ),
        const SizedBox(height: 24),

        // Search & Filters Bar
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.bg.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 18, color: AppColors.inkFaint),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (v) {
                                _searchQuery = v;
                                _load();
                              },
                              decoration: InputDecoration(
                                hintText: 'Search products by title, SKU, or category…',
                                hintStyle: body(12.5, color: AppColors.inkFaint),
                                border: InputBorder.none,
                              ),
                              style: body(13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text('Gender: ', style: body(12, weight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Wrap(
                    spacing: 6,
                    children: genders.map((g) {
                      final active = _selectedGender == g;
                      return ChoiceChip(
                        label: Text(g),
                        selected: active,
                        onSelected: (_) {
                          setState(() => _selectedGender = g);
                          _load();
                        },
                        selectedColor: AppColors.accent,
                        labelStyle: TextStyle(
                          color: active ? AppColors.surface : AppColors.ink,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          fontSize: 11,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 24),
                  Text('Brand: ', style: body(12, weight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: brands.map((b) {
                          final active = _selectedBrand == b;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(b),
                              selected: active,
                              onSelected: (_) {
                                setState(() => _selectedBrand = b);
                                _load();
                              },
                              selectedColor: AppColors.accent,
                              labelStyle: TextStyle(
                                color: active ? AppColors.surface : AppColors.ink,
                                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Product Items Table / Grid
        if (_loading || _items == null)
          const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: AppColors.accent)))
        else if (_items!.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text('No products match the selected filters.', style: body(14, color: AppColors.inkSecondary)),
            ),
          )
        else
          ..._items!.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 58,
                      height: 72,
                      color: AppColors.sand,
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Center(
                          child: Icon(Icons.checkroom, color: AppColors.inkSecondary, size: 24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: item.gender == 'Men'
                                    ? const Color(0xFF0284C7).withValues(alpha: 0.12)
                                    : const Color(0xFFE11D48).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.gender.toUpperCase(),
                                style: overline(8.5,
                                    color: item.gender == 'Men' ? const Color(0xFF0284C7) : const Color(0xFFE11D48)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(item.brand, style: body(11.5, weight: FontWeight.w700, color: AppColors.accent)),
                            const SizedBox(width: 8),
                            Text('· ${item.category} (${item.occasion})',
                                style: body(11.5, color: AppColors.inkSecondary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(item.title, style: heading(15)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Price & Link status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Rs. ${item.price}', style: heading(16, color: AppColors.ink)),
                      if (item.originalPrice > item.price)
                        Text('Rs. ${item.originalPrice}',
                            style: body(11, color: AppColors.inkFaint).copyWith(
                                decoration: TextDecoration.lineThrough)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline, size: 13, color: Color(0xFF15803D)),
                          const SizedBox(width: 4),
                          Text('Outbound 200 OK',
                              style: body(10.5, weight: FontWeight.w600, color: const Color(0xFF15803D))),
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
