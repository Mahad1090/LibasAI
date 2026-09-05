import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'ai.dart' show CompareBar, ProductGridToolbar;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();

  void _run(String q) {
    final state = AppScope.of(context);
    state.searchQuery = q;
    state.addSearch(q);
    go(context, '/searchResults');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Row(children: [
                  Icon(glyph('search'), size: 17, color: AppColors.inkFaint),
                  const SizedBox(width: 9),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Search brands, styles, products…',
                          hintStyle: body(14, color: AppColors.inkFaint)),
                      onSubmitted: (v) => v.trim().isEmpty ? null : _run(v.trim()),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => go(context, '/imageSearchIntro'),
                    child: Icon(glyph('camera'), size: 17),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                children: [
                  Text('Trending Searches', style: body(12.5, weight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final t in const [
                      'Lawn suits',
                      'Wedding kurta',
                      'Formal shirts',
                      'Eid collection',
                      'Waistcoats',
                      'Unstitched'
                    ])
                      _pill(t, () => _run(t)),
                  ]),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Searches', style: body(12.5, weight: FontWeight.w700)),
                      GestureDetector(
                        onTap: () => go(context, '/searchHistory'),
                        child: Text('See all',
                            style: body(11.5, weight: FontWeight.w600, color: AppColors.accent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (final h in state.searchHistory)
                    GestureDetector(
                      onTap: () => _run(h),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(children: [
                          Icon(glyph('clock'), size: 14, color: AppColors.inkFaint),
                          const SizedBox(width: 10),
                          Text(h, style: body(13)),
                        ]),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text('Categories', style: body(12.5, weight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final c in kCategoryOptions) _pill(c, () => _run(c)),
                  ]),
                ],
              ),
            ),
            const LibasBottomNav(active: 'search'),
          ],
        );
      },
    );
  }

  Widget _pill(String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(label, style: body(12.5, weight: FontWeight.w600)),
        ),
      );
}

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final label = state.searchQuery.trim().isEmpty
            ? 'All Products'
            : 'Results for "${state.searchQuery.trim()}"';
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 24),
                children: [
                  Row(children: [
                    GestureDetector(
                      onTap: () => goBack(context),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.chevron_left, size: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: body(15, weight: FontWeight.w700)),
                          Text('86 results', style: body(11.5, color: AppColors.inkSecondary)),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  const ProductGridToolbar(),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.56,
                    // cap the eager (shrink-wrapped) grid - rendering all 160
                    // cards + images at once is the main source of scroll jank
                    children: [for (final p in kProducts.take(30)) ProductCard(p)],
                  ),
                ],
              ),
            ),
            if (state.compareIds.isNotEmpty) const CompareBar(),
            const LibasBottomNav(active: 'search'),
          ],
        );
      },
    );
  }
}

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Container(
          color: AppColors.surface,
          child: Column(
            children: [
              ScreenHeader('Filters',
                  trailingText: 'Clear All',
                  onTrailing: () => state.set(() {
                        state.filterCategories.clear();
                        state.filterColors.clear();
                        state.filterSizes.clear();
                        state.filterEmergingOnly = false;
                      })),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                  children: [
                    _h('Category'),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final c in kCategoryOptions)
                        SelectChip(c,
                            active: state.filterCategories.contains(c),
                            onTap: () => state.toggleSetMember(state.filterCategories, c)),
                    ]),
                    const SizedBox(height: 24),
                    _h('Price Range'),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final b in kBudgetOptions)
                        SelectChip(b,
                            active: state.filterCategories.contains(b),
                            onTap: () => state.toggleSetMember(state.filterCategories, b)),
                    ]),
                    const SizedBox(height: 24),
                    _h('Color'),
                    Wrap(spacing: 12, runSpacing: 12, children: [
                      for (final c in kColorSwatches)
                        ColorSwatch2(c.value,
                            active: state.filterColors.contains(c.key),
                            onTap: () => state.toggleSetMember(state.filterColors, c.key),
                            size: 36),
                    ]),
                    const SizedBox(height: 24),
                    _h('Size'),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final sz in kSizeOptions)
                        SelectChip(sz,
                            active: state.filterSizes.contains(sz),
                            onTap: () => state.toggleSetMember(state.filterSizes, sz)),
                    ]),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => state.set(
                          () => state.filterEmergingOnly = !state.filterEmergingOnly),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                            color: AppColors.bg, borderRadius: BorderRadius.circular(AppRadius.button)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Emerging & Local Brands Only',
                                style: body(13, weight: FontWeight.w600)),
                            Toggle(
                                value: state.filterEmergingOnly,
                                onTap: () => state.set(() =>
                                    state.filterEmergingOnly = !state.filterEmergingOnly)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                decoration:
                    BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
                child: PrimaryButton('Show Results', onTap: () => goBack(context)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _h(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: Text(t, style: body(13, weight: FontWeight.w700)),
      );
}

class SortSheetScreen extends StatelessWidget {
  const SortSheetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          const ScreenHeader('Sort By'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              children: [
                for (final o in kSortOptions)
                  GestureDetector(
                    onTap: () {
                      state.set(() => state.sortOption = o);
                      goBack(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.hairline))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(o,
                              style: body(14,
                                  weight: o == state.sortOption ? FontWeight.w700 : FontWeight.w500,
                                  color: o == state.sortOption ? AppColors.accent : AppColors.ink)),
                          if (o == state.sortOption)
                            const Icon(Icons.check, size: 17, color: AppColors.accent),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
