import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  String _selectedFilter = 'all'; // 'all' | 'stitched' | 'unstitched' | 'with_tailor'

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AddWardrobePieceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final allItems = state.wardrobeItems;
        final readyCount = state.readyWardrobeItems.length;
        final unstitchedCount = state.unstitchedWardrobeItems.length;
        final withTailorCount = state.withTailorWardrobeItems.length;

        final displayedItems = allItems.where((i) {
          if (_selectedFilter == 'stitched') return i.isStitched;
          if (_selectedFilter == 'unstitched') return i.isUnstitched;
          if (_selectedFilter == 'with_tailor') return i.isWithTailor;
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: Column(
              children: [
                ScreenHeader(
                  'My Wardrobe',
                  trailingText: '+ Add Piece',
                  onTrailing: () => _showAddSheet(context),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                    children: [
                      // Editorial "Wear What You Own" banner
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.hairline),
                          boxShadow: AppShadows.soft,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(glyph('hanger'), size: 18, color: AppColors.accent),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'WEAR WHAT YOU OWN',
                                        style: overline(9.5, color: AppColors.accent),
                                      ),
                                      Text(
                                        'Feeds Subah Edit & Styling',
                                        style: heading(15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Catalog what you already own — stitched and ready, still fabric, or out with a master tailor. Subah Edit checks your closet before suggesting anything new.',
                              style: body(12, color: AppColors.inkSecondary, height: 1.45),
                            ),
                            const SizedBox(height: 14),
                            // Quick stats pill row
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _StatPill(
                                  label: 'Ready',
                                  count: readyCount,
                                  color: const Color(0xFF1A7A38),
                                  onTap: () => setState(() => _selectedFilter = 'stitched'),
                                ),
                                _StatPill(
                                  label: 'Needs Tailor',
                                  count: unstitchedCount,
                                  color: const Color(0xFFA11F37),
                                  onTap: () => setState(() => _selectedFilter = 'unstitched'),
                                ),
                                _StatPill(
                                  label: 'With Tailor',
                                  count: withTailorCount,
                                  color: const Color(0xFF8A6A1E),
                                  onTap: () => setState(() => _selectedFilter = 'with_tailor'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: () => go(context, '/subahEdit'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.sand,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.wb_sunny_outlined, size: 14, color: AppColors.accent),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Ask Subah Edit what to wear today',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: body(11.5, weight: FontWeight.w700, color: AppColors.accent),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.accent),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Filter chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _filterChip('All (${allItems.length})', 'all'),
                            const SizedBox(width: 8),
                            _filterChip('Ready ($readyCount)', 'stitched'),
                            const SizedBox(width: 8),
                            _filterChip('Needs Tailor ($unstitchedCount)', 'unstitched'),
                            const SizedBox(width: 8),
                            _filterChip('With Tailor ($withTailorCount)', 'with_tailor'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Items count label
                      Text(
                        '${displayedItems.length} piece${displayedItems.length == 1 ? '' : 's'} in closet',
                        style: body(12, weight: FontWeight.w600, color: AppColors.inkSecondary),
                      ),
                      const SizedBox(height: 14),

                      // Grid or Empty State
                      if (displayedItems.isEmpty)
                        _buildEmptyState(context)
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.60,
                          ),
                          itemCount: displayedItems.length,
                          itemBuilder: (context, index) {
                            return _WardrobeCard(
                              item: displayedItems[index],
                              onSendToTailor: () => go(context, '/getStitched'),
                              onCheckStatus: () => go(context, '/myRequests'),
                              onMarkReady: () {
                                state.markWardrobeItemReady(displayedItems[index].id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${displayedItems[index].name} marked as ready to wear!'),
                                    backgroundColor: const Color(0xFF1A7A38),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              onDelete: () {
                                state.removeWardrobeItem(displayedItems[index].id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Removed ${displayedItems[index].name} from wardrobe.'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterChip(String title, String value) {
    final active = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: active ? AppColors.accent : AppColors.hairline,
          ),
        ),
        child: Text(
          title,
          style: body(
            12,
            weight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? AppColors.surface : AppColors.ink,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        children: [
          Icon(glyph('hanger'), size: 40, color: AppColors.inkFaint),
          const SizedBox(height: 12),
          Text(
            _selectedFilter == 'all'
                ? 'Your wardrobe is empty'
                : 'No pieces matching this filter',
            style: body(15, weight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Add your own stitched or unstitched Pakistani outfits so Subah Edit reaches for them first.',
            textAlign: TextAlign.center,
            style: body(12, color: AppColors.inkSecondary),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            '+ Add First Piece',
            onTap: () => _showAddSheet(context),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _StatPill({
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              '$label: $count',
              style: body(11, weight: FontWeight.w700, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _WardrobeCard extends StatelessWidget {
  final WardrobeItem item;
  final VoidCallback onSendToTailor;
  final VoidCallback onCheckStatus;
  final VoidCallback onMarkReady;
  final VoidCallback onDelete;

  const _WardrobeCard({
    required this.item,
    required this.onSendToTailor,
    required this.onCheckStatus,
    required this.onMarkReady,
    required this.onDelete,
  });

  static const _green = Color(0xFF1A7A38);
  static const _amber = Color(0xFF8A6A1E);

  Color get _badgeColor {
    if (item.isStitched) return _green;
    if (item.isUnstitched) return AppColors.accent;
    return _amber;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with status badge and delete control
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.12,
                child: StripePlaceholder(
                  label: item.name,
                  imageUrl: item.imageUrl,
                  radius: BorderRadius.zero,
                  decodeWidth: 320,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _badgeColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.circle, size: 5, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        item.statusBadge.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(glyph('close'), size: 12, color: AppColors.inkFaint),
                  ),
                ),
              ),
            ],
          ),

          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: body(12.5, weight: FontWeight.w700, height: 1.2),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.isWithTailor && item.tailorName != null
                        ? 'At ${item.tailorName}'
                        : item.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: body(10.5,
                        weight: item.isWithTailor ? FontWeight.w600 : FontWeight.w500,
                        color: item.isWithTailor ? _amber : AppColors.inkSecondary),
                  ),
                  const Spacer(),
                  _actionPill(),
                  if (!item.isStitched) ...[
                    const SizedBox(height: 7),
                    GestureDetector(
                      onTap: onMarkReady,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_rounded, size: 12, color: AppColors.inkFaint),
                          const SizedBox(width: 4),
                          Text('Mark as ready',
                              style: body(9.5, weight: FontWeight.w600, color: AppColors.inkFaint)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionPill() {
    late final Color fg;
    late final Color bg;
    late final String label;
    late final VoidCallback onTap;
    late final IconData icon;

    if (item.isUnstitched) {
      fg = AppColors.surface;
      bg = AppColors.accent;
      label = 'Send to Tailor';
      icon = Icons.content_cut_rounded;
      onTap = onSendToTailor;
    } else if (item.isWithTailor) {
      fg = _amber;
      bg = _amber.withValues(alpha: 0.12);
      label = 'Track Order';
      icon = Icons.local_shipping_outlined;
      onTap = onCheckStatus;
    } else {
      fg = _green;
      bg = _green.withValues(alpha: 0.12);
      label = 'Ready to Wear';
      icon = Icons.check_circle_rounded;
      onTap = onMarkReady;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 31,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 5),
            Flexible(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: body(10, weight: FontWeight.w700, color: fg)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddWardrobePieceSheet extends StatefulWidget {
  const _AddWardrobePieceSheet();

  @override
  State<_AddWardrobePieceSheet> createState() => _AddWardrobePieceSheetState();
}

class _AddWardrobePieceSheetState extends State<_AddWardrobePieceSheet> {
  final _nameController = TextEditingController();
  final _tailorNameController = TextEditingController();
  final _tailorEtaController = TextEditingController();

  String _category = 'Kurta';
  String _status = 'stitched'; // 'stitched' | 'unstitched' | 'with_tailor'
  final Set<String> _selectedTags = {'cotton', 'casual'};

  static const _categories = [
    'Kurta',
    'Shalwar Kameez',
    'Blazer',
    'Waistcoat',
    'Sherwani',
    'Casual / Western',
    'Unstitched Fabric',
    'Dupatta',
    'Other',
  ];

  static const _availableTags = [
    'cotton',
    'linen',
    'silk',
    'lawn',
    'formal',
    'casual',
    'festive',
    'wedding',
    'eid',
    'traditional',
    'western',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _tailorNameController.dispose();
    _tailorEtaController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final state = AppScope.of(context);
    final newItem = WardrobeItem(
      id: 'w_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      category: _category,
      tags: _selectedTags.toList(),
      status: _status,
      tailorName: _status == 'with_tailor' && _tailorNameController.text.trim().isNotEmpty
          ? _tailorNameController.text.trim()
          : null,
      tailorEta: _status == 'with_tailor' && _tailorEtaController.text.trim().isNotEmpty
          ? _tailorEtaController.text.trim()
          : null,
      imageUrl: '', // default placeholder
    );

    state.addWardrobeItem(newItem);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "$name" to your wardrobe!'),
        backgroundColor: AppColors.accent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.hairline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Add a Piece to Wardrobe', style: heading(18))),
                  IconButton(
                    icon: Icon(glyph('close'), size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name input
              Text('PIECE NAME', style: overline(10.5, color: AppColors.inkSecondary)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                style: body(13.5),
                decoration: InputDecoration(
                  hintText: 'e.g. Rust embroidered cotton kurta',
                  hintStyle: body(13.5, color: AppColors.inkFaint),
                  filled: true,
                  fillColor: AppColors.sand.withValues(alpha: 0.3),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.hairline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.hairline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.accent),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Category dropdown
              Text('CATEGORY', style: overline(10.5, color: AppColors.inkSecondary)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.hairline),
                  color: AppColors.sand.withValues(alpha: 0.3),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _category,
                    isExpanded: true,
                    icon: Icon(glyph('chevronDown'), size: 18),
                    items: _categories.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(c, style: body(13.5)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _category = val;
                          if (val == 'Unstitched Fabric') {
                            _status = 'unstitched';
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Wearable status
              Text('WEARABLE STATUS', style: overline(10.5, color: AppColors.inkSecondary)),
              const SizedBox(height: 8),
              _statusOption(
                key: 'stitched',
                title: 'Stitched & ready to wear',
                subtitle: 'You can wear this today in Subah Edit.',
                color: const Color(0xFF1A7A38),
              ),
              const SizedBox(height: 8),
              _statusOption(
                key: 'unstitched',
                title: 'Just fabric — needs a tailor',
                subtitle: "Hasn't been stitched into a garment yet.",
                color: const Color(0xFFA11F37),
              ),
              const SizedBox(height: 8),
              _statusOption(
                key: 'with_tailor',
                title: 'With a tailor right now',
                subtitle: 'Currently out for stitching or alteration.',
                color: const Color(0xFF8A6A1E),
              ),

              // Conditional tailor fields
              if (_status == 'with_tailor') ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tailorNameController,
                        style: body(12.5),
                        decoration: InputDecoration(
                          hintText: 'Tailor name (e.g. Master Rafiq)',
                          hintStyle: body(11.5, color: AppColors.inkFaint),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.hairline),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _tailorEtaController,
                        style: body(12.5),
                        decoration: InputDecoration(
                          hintText: 'Delivery ETA (e.g. Sep 15)',
                          hintStyle: body(11.5, color: AppColors.inkFaint),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.hairline),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 18),

              // Tags
              Text('FABRIC & OCCASION TAGS', style: overline(10.5, color: AppColors.inkSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTags.map((tag) {
                  final active = _selectedTags.contains(tag);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (active) {
                          _selectedTags.remove(tag);
                        } else {
                          _selectedTags.add(tag);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.accent.withValues(alpha: 0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: active ? AppColors.accent : AppColors.hairline,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: body(
                          11.5,
                          weight: active ? FontWeight.w700 : FontWeight.w500,
                          color: active ? AppColors.accent : AppColors.ink,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              PrimaryButton(
                'Add to Wardrobe',
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusOption({
    required String key,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final active = _status == key;
    return GestureDetector(
      onTap: () => setState(() => _status = key),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.06) : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? color : AppColors.hairline,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: active ? color : AppColors.inkFaint, width: 2),
                color: active ? color : Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: body(12.5, weight: FontWeight.w700, color: active ? color : AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: body(11, color: AppColors.inkSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
