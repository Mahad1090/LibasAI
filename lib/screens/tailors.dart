import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class _BackBtn extends StatelessWidget {
  final VoidCallback? onTap;
  const _BackBtn({this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap ?? () => goBack(context),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.chevron_left, size: 17),
        ),
      );
}

/// Screen 1: Master Tailor Directory
class TailorsDirectoryScreen extends StatefulWidget {
  const TailorsDirectoryScreen({super.key});

  @override
  State<TailorsDirectoryScreen> createState() => _TailorsDirectoryScreenState();
}

class _TailorsDirectoryScreenState extends State<TailorsDirectoryScreen> {
  String _selectedCity = 'All';
  String _selectedSpecialty = 'All';
  String _query = '';

  final _cities = const ['All', 'Lahore', 'Karachi', 'Islamabad', 'Rawalpindi', 'Faisalabad'];
  final _specialties = const ['All', 'Men\'s Wear', 'Women\'s Pret', 'Waistcoats', 'Sherwani', 'Express 48h'];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final tailors = kTailors.where((t) {
      if (_selectedCity != 'All' && t.city != _selectedCity) return false;
      if (_selectedSpecialty != 'All') {
        if (_selectedSpecialty == 'Men\'s Wear' && !t.specialties.any((s) => s.contains('Men') || s.contains('Kurta'))) return false;
        if (_selectedSpecialty == 'Women\'s Pret' && !t.specialties.any((s) => s.contains('Lawn') || s.contains('Women'))) return false;
        if (_selectedSpecialty == 'Waistcoats' && !t.specialties.any((s) => s.contains('Waistcoat'))) return false;
        if (_selectedSpecialty == 'Sherwani' && !t.specialties.any((s) => s.contains('Sherwani'))) return false;
        if (_selectedSpecialty == 'Express 48h' && !t.specialties.any((s) => s.contains('Express'))) return false;
      }
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        final match = t.name.toLowerCase().contains(q) ||
            t.city.toLowerCase().contains(q) ||
            t.location.toLowerCase().contains(q) ||
            t.specialties.any((s) => s.toLowerCase().contains(q));
        if (!match) return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 10),
          child: Row(
            children: [
              const _BackBtn(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Master Tailor Network', style: heading(18)),
                    Text('Verified Master Darzis across Pakistan',
                        style: body(11, color: AppColors.inkSecondary)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => go(context, '/myRequests'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.sand,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 14, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(
                        'Orders (${state.stitchingRequests.length})',
                        style: body(10.5, weight: FontWeight.w700, color: AppColors.accent),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Search input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 18, color: AppColors.inkSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _query = val),
                    decoration: InputDecoration(
                      hintText: 'Search by tailor name, area, or specialty…',
                      hintStyle: body(12.5, color: AppColors.inkFaint),
                      border: InputBorder.none,
                    ),
                    style: body(12.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        // City Chips
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _cities.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final c = _cities[i];
              final active = c == _selectedCity;
              return ChoiceChip(
                label: Text(c),
                selected: active,
                onSelected: (_) => setState(() => _selectedCity = c),
                selectedColor: AppColors.accent,
                backgroundColor: AppColors.surface,
                labelStyle: body(11,
                    weight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? AppColors.surface : AppColors.ink),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: active ? AppColors.accent : AppColors.hairline,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        // Specialty Filter
        SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _specialties.length,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              final s = _specialties[i];
              final active = s == _selectedSpecialty;
              return GestureDetector(
                onTap: () => setState(() => _selectedSpecialty = s),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: active ? AppColors.sand : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: active ? AppColors.accent : AppColors.hairline,
                    ),
                  ),
                  child: Text(
                    s,
                    style: body(10.5,
                        weight: active ? FontWeight.w700 : FontWeight.w500,
                        color: active ? AppColors.accent : AppColors.inkSecondary),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Tailor list
        Expanded(
          child: tailors.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_search_outlined, size: 48, color: AppColors.inkFaint),
                      const SizedBox(height: 12),
                      Text('No tailors match your filters', style: heading(16)),
                      const SizedBox(height: 6),
                      Text('Try selecting a different city or specialty',
                          style: body(12, color: AppColors.inkSecondary)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
                  itemCount: tailors.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, i) {
                    final t = tailors[i];
                    return _TailorCard(
                      tailor: t,
                      onTap: () {
                        state.set(() => state.selectedTailorId = t.id);
                        go(context, '/tailorProfile');
                      },
                      onBook: () {
                        state.set(() => state.selectedTailorId = t.id);
                        go(context, '/getStitched');
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _TailorCard extends StatelessWidget {
  final Tailor tailor;
  final VoidCallback onTap;
  final VoidCallback onBook;

  const _TailorCard({
    required this.tailor,
    required this.onTap,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.soft,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.sand,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.2), width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      tailor.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                      style: heading(18).copyWith(color: AppColors.accent),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(tailor.name, style: heading(15.5)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified, size: 12, color: AppColors.accent),
                                const SizedBox(width: 3),
                                Text('VERIFIED',
                                    style: overline(8.5, color: AppColors.accent)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${tailor.location} · ${tailor.experienceYears} Yrs Exp',
                        style: body(11.5, color: AppColors.inkSecondary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 13, color: Color(0xFFE5A83B)),
                          const SizedBox(width: 3),
                          Text(
                            '${tailor.rating}',
                            style: body(11.5, weight: FontWeight.w700),
                          ),
                          Text(
                            ' (${tailor.reviewCount})',
                            style: body(10.5, color: AppColors.inkSecondary),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.schedule, size: 12, color: AppColors.inkSecondary),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              '~${tailor.turnaroundDays} days delivery',
                              overflow: TextOverflow.ellipsis,
                              style: body(10.5, color: AppColors.inkSecondary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tailor.specialties.take(3).map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.sand.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(s, style: body(10, weight: FontWeight.w600, color: AppColors.inkSecondary)),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Starting from', style: overline(9, color: AppColors.inkFaint)),
                      Text('Rs. ${tailor.startingPrice}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: heading(15).copyWith(color: AppColors.accent)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.hairline),
                        ),
                        child: Text('Profile',
                            style: body(11.5, weight: FontWeight.w600, color: AppColors.ink)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onBook,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.cut, size: 12, color: AppColors.surface),
                            const SizedBox(width: 5),
                            Text('Get Stitched',
                                style: body(11.5,
                                    weight: FontWeight.w700, color: AppColors.surface)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen 2: Tailor Profile Screen
class TailorProfileScreen extends StatelessWidget {
  const TailorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = tailorById(state.selectedTailorId);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 10),
            child: Row(
              children: [
                const _BackBtn(),
                const SizedBox(width: 14),
                Expanded(child: Text('Atelier Profile', style: heading(18))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(t.phone, style: body(10.5, weight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              children: [
                // Artisan Card Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
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
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.sand,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accent, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                t.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                                style: heading(22).copyWith(color: AppColors.accent),
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
                                    Expanded(child: Text(t.name, style: heading(18))),
                                    const Icon(Icons.verified, size: 16, color: AppColors.accent),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(t.specialtyTitle,
                                    style: body(12,
                                        weight: FontWeight.w600, color: AppColors.accentPressed)),
                                const SizedBox(height: 4),
                                Text('${t.location}, ${t.city}',
                                    style: body(11.5, color: AppColors.inkSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Stats Row
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.sand.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: _metric('${t.rating} ★', '${t.reviewCount} Reviews')),
                            _divider(),
                            Expanded(child: _metric('${t.experienceYears} Yrs', 'Experience')),
                            _divider(),
                            Expanded(child: _metric('Rs. ${t.startingPrice}', 'Starting Rate')),
                            _divider(),
                            Expanded(child: _metric('${t.turnaroundDays} Days', 'Avg Turnaround')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // About Section
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About the Atelier', style: heading(15)),
                      const SizedBox(height: 8),
                      Text(
                        t.about,
                        style: body(13, color: AppColors.inkSecondary, height: 1.55),
                      ),
                      const SizedBox(height: 14),
                      Text('Artisanal Specialties', style: body(12, weight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: t.specialties.map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.sand,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(s,
                                style: body(11, weight: FontWeight.w600, color: AppColors.accent)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Rate Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Standard Rate Card', style: heading(15)),
                          Text('Transparent Pricing',
                              style: overline(9.5, color: AppColors.accent)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      for (final r in t.rateCard)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 14, color: AppColors.accent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(r.item, style: body(12.5, weight: FontWeight.w600)),
                              ),
                              Text(r.time,
                                  style: body(11, color: AppColors.inkSecondary)),
                              const SizedBox(width: 14),
                              Text(r.price,
                                  style: body(13, weight: FontWeight.w700, color: AppColors.accent)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Guarantees Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.sand.withValues(alpha: 0.6),
                        AppColors.sand.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.shield_outlined, size: 16, color: AppColors.accent),
                        const SizedBox(width: 6),
                        Text('LibasAI Craft Guarantees', style: heading(14)),
                      ]),
                      const SizedBox(height: 10),
                      _guaranteeRow('Exact Reference Copy',
                          'Send your best-fitting kurta/suit; master cutter replicates dimensions perfectly.'),
                      _guaranteeRow('Complimentary Alterations',
                          'Free adjustments within 7 days if the fit is not 100% satisfactory.'),
                      _guaranteeRow('Doorstep Pickup & Delivery',
                          'Rider collects unstitched fabric from your home and returns the finished piece.'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  'Book Stitching with ${t.name}',
                  onTap: () {
                    state.set(() => state.selectedTailorId = t.id);
                    go(context, '/getStitched');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String val, String label) => Column(
        children: [
          Text(val,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: heading(14).copyWith(color: AppColors.ink)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: overline(8.5, color: AppColors.inkSecondary)),
        ],
      );

  Widget _divider() => Container(width: 1, height: 24, color: AppColors.border);

  Widget _guaranteeRow(String title, String desc) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('✓ ', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: body(11.5, color: AppColors.inkSecondary, height: 1.4),
                  children: [
                    TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                    TextSpan(text: desc),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

/// Screen 3: "Get Stitched" Interactive Booking Wizard
class GetStitchedScreen extends StatefulWidget {
  const GetStitchedScreen({super.key});

  @override
  State<GetStitchedScreen> createState() => _GetStitchedScreenState();
}

class _GetStitchedScreenState extends State<GetStitchedScreen> {
  int _step = 1;

  // Form selections
  String _gender = 'Men';
  String _outfitType = 'Standard Kurta Shalwar';
  String _fabricSource = 'I have unstitched fabric from brand/market';
  final _fabricDescCtrl = TextEditingController(text: '3-Piece Cotton / Lawn fabric');
  bool _includeLining = true;
  bool _expressDelivery = false;
  String _measurementMode = 'Pickup reference suit from home';
  String _standardSize = 'M';
  final _specialInstructionsCtrl = TextEditingController(text: 'Please ensure neat piping on neckline');
  final _addressCtrl = TextEditingController(text: 'House 42, Street 7, Phase 5, DHA');
  final _cityCtrl = TextEditingController(text: 'Lahore');
  final _phoneCtrl = TextEditingController(text: '+92 300 1234567');

  late String _tailorId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tailorId = AppScope.of(context).selectedTailorId;
  }

  @override
  void dispose() {
    _fabricDescCtrl.dispose();
    _specialInstructionsCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  int get _calculatedPrice {
    int base = 2800;
    if (_gender == 'Men') {
      if (_outfitType.contains('Boski')) base = 3500;
      if (_outfitType.contains('Waistcoat')) base = 4200;
      if (_outfitType.contains('Sherwani')) base = 9500;
    } else {
      if (_outfitType.contains('Formal')) base = 4500;
      if (_outfitType.contains('Lehenga')) base = 7500;
      if (_outfitType.contains('Kurti')) base = 2200;
    }
    if (_includeLining) base += 600;
    if (_expressDelivery) base += 800;
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final selectedTailor = tailorById(_tailorId);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 12),
            child: Row(
              children: [
                _BackBtn(onTap: () {
                  if (_step > 1) {
                    setState(() => _step--);
                  } else {
                    goBack(context);
                  }
                }),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Get Your Suit Stitched', style: heading(18)),
                      Text('Step $_step of 3 · Bespoke Stitching Order',
                          style: body(11, color: AppColors.inkSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: List.generate(3, (i) {
                final active = i < _step;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: active ? AppColors.accent : AppColors.hairline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          // Step views
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: _step == 1
                  ? _buildStep1()
                  : _step == 2
                      ? _buildStep2()
                      : _buildStep3(state, selectedTailor),
            ),
          ),
          // Bottom button bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.hairline)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Estimated Price', style: overline(9, color: AppColors.inkFaint)),
                    Text('Rs. $_calculatedPrice',
                        style: heading(17).copyWith(color: AppColors.accent)),
                  ],
                ),
                const Spacer(),
                if (_step < 3)
                  ElevatedButton(
                    onPressed: () => setState(() => _step++),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Continue →',
                        style: body(13, weight: FontWeight.w700, color: AppColors.surface)),
                  )
                else
                  ElevatedButton(
                    onPressed: () => _submitOrder(state, selectedTailor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Confirm & Book Darzi',
                        style: body(13, weight: FontWeight.w700, color: AppColors.surface)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    final menOutfits = const [
      'Standard Kurta Shalwar',
      'Pure Boski / Silk Suit',
      'Embroidered Waistcoat',
      'Prince Coat / Sherwani',
    ];
    final womenOutfits = const [
      '3-Piece Lawn / Pret Suit',
      'Luxury Formal Ensemble',
      'Festive Lehenga Choli',
      'A-Line Kurti & Trouser',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Gender & Outfit Type', style: heading(16)),
        const SizedBox(height: 6),
        Text('Tailors specialize in both Men and Women\'s bespoke cuts.',
            style: body(12, color: AppColors.inkSecondary)),
        const SizedBox(height: 16),
        // Gender toggle
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _gender = 'Men';
                  _outfitType = menOutfits.first;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _gender == 'Men' ? AppColors.accent : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _gender == 'Men' ? AppColors.accent : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Men\'s Apparel',
                      style: body(13,
                          weight: FontWeight.w700,
                          color: _gender == 'Men' ? AppColors.surface : AppColors.ink),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _gender = 'Women';
                  _outfitType = womenOutfits.first;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _gender == 'Women' ? AppColors.accent : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _gender == 'Women' ? AppColors.accent : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Women\'s Apparel',
                      style: body(13,
                          weight: FontWeight.w700,
                          color: _gender == 'Women' ? AppColors.surface : AppColors.ink),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('Choose Garment Silhouette', style: heading(14)),
        const SizedBox(height: 10),
        for (final o in (_gender == 'Men' ? menOutfits : womenOutfits))
          GestureDetector(
            onTap: () => setState(() => _outfitType = o),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _outfitType == o ? AppColors.sand.withValues(alpha: 0.6) : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _outfitType == o ? AppColors.accent : AppColors.border,
                  width: _outfitType == o ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _outfitType == o ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: _outfitType == o ? AppColors.accent : AppColors.inkFaint,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(o, style: body(13, weight: FontWeight.w600))),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStep2() {
    final sources = const [
      'I have unstitched fabric from brand/market',
      'Fabric purchased through LibasAI catalog',
      'Tailor to provide premium fabric material',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fabric & Customization Details', style: heading(16)),
        const SizedBox(height: 6),
        Text('Specify where your fabric is coming from and finishing needs.',
            style: body(12, color: AppColors.inkSecondary)),
        const SizedBox(height: 16),
        for (final s in sources)
          GestureDetector(
            onTap: () => setState(() => _fabricSource = s),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: _fabricSource == s ? AppColors.sand.withValues(alpha: 0.5) : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _fabricSource == s ? AppColors.accent : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _fabricSource == s ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: _fabricSource == s ? AppColors.accent : AppColors.inkFaint,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(s, style: body(12, weight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text('Fabric Description & Brand', style: heading(14)),
        const SizedBox(height: 8),
        TextField(
          controller: _fabricDescCtrl,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            hintText: 'e.g. Sana Safinaz 3-Piece Luxury Lawn, 4.5 meters',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.border),
            ),
          ),
          style: body(12.5),
        ),
        const SizedBox(height: 16),
        // Add-ons
        SwitchListTile(
          value: _includeLining,
          onChanged: (v) => setState(() => _includeLining = v),
          title: Text('Include Soft Cotton Lining (+Rs. 600)', style: body(12.5, weight: FontWeight.w600)),
          subtitle: Text('Prevents transparency & enhances suit drape', style: body(11, color: AppColors.inkSecondary)),
          activeThumbColor: AppColors.accent,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          value: _expressDelivery,
          onChanged: (v) => setState(() => _expressDelivery = v),
          title: Text('Express 48h Turnaround (+Rs. 800)', style: body(12.5, weight: FontWeight.w600)),
          subtitle: Text('Fast-tracked cutting & priority stitching queue', style: body(11, color: AppColors.inkSecondary)),
          activeThumbColor: AppColors.accent,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildStep3(AppState state, Tailor tailor) {
    final modes = const [
      ('Pickup reference suit from home', 'Rider collects your favorite-fit suit from your doorstep. Master cutter replicates it 100%.'),
      ('Quick Standard S/M/L/XL sizing', 'Choose your general size with optional custom shirt/trouser length tweaks.'),
      ('Enter custom tailored dimensions', 'Input exact chest, shoulder, waist, and sleeve measurements manually.'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fit Measurements & Tailor Confirmation', style: heading(16)),
        const SizedBox(height: 6),
        Text('Select how you would like your measurements confirmed.',
            style: body(12, color: AppColors.inkSecondary)),
        const SizedBox(height: 16),
        for (final m in modes)
          GestureDetector(
            onTap: () => setState(() => _measurementMode = m.$1),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _measurementMode == m.$1 ? AppColors.sand.withValues(alpha: 0.5) : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _measurementMode == m.$1 ? AppColors.accent : AppColors.border,
                  width: _measurementMode == m.$1 ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _measurementMode == m.$1 ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: _measurementMode == m.$1 ? AppColors.accent : AppColors.inkFaint,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(m.$1, style: body(12.5, weight: FontWeight.w700))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: Text(m.$2, style: body(11, color: AppColors.inkSecondary)),
                  ),
                ],
              ),
            ),
          ),
        if (_measurementMode.contains('Standard')) ...[
          const SizedBox(height: 10),
          Text('Select Standard Size', style: body(12, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: ['S', 'M', 'L', 'XL'].map((s) {
              final active = _standardSize == s;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  label: Text(s),
                  selected: active,
                  onSelected: (_) => setState(() => _standardSize = s),
                  selectedColor: AppColors.accent,
                  labelStyle: TextStyle(
                    color: active ? AppColors.surface : AppColors.ink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 16),
        Text('Delivery / Pickup Address', style: heading(14)),
        const SizedBox(height: 8),
        TextField(
          controller: _addressCtrl,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            labelText: 'Street Address',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: body(12.5),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityCtrl,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  labelText: 'City',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                style: body(12.5),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _phoneCtrl,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  labelText: 'Phone',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                style: body(12.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Selected Master Tailor Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Selected Master Darzi', style: overline(9, color: AppColors.accent)),
                  GestureDetector(
                    onTap: () => go(context, '/tailors'),
                    child: Text('Change Tailor →',
                        style: body(11, weight: FontWeight.w700, color: AppColors.accent)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(tailor.name, style: heading(15)),
              Text('${tailor.location}, ${tailor.city}',
                  style: body(11.5, color: AppColors.inkSecondary)),
              const Divider(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Estimated Delivery', style: body(12, color: AppColors.inkSecondary)),
                  Text(
                    _expressDelivery ? 'Within 48 Hours' : '~${tailor.turnaroundDays} Days',
                    style: body(12, weight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitOrder(AppState state, Tailor tailor) {
    final now = DateTime.now();
    final newOrder = StitchingRequest(
      id: 'REQ-${(1000 + now.millisecond * 7).toString().padLeft(4, '0')}',
      outfitTitle: '$_outfitType ($_gender)',
      gender: _gender,
      fabricSource: _fabricDescCtrl.text.trim().isNotEmpty ? _fabricDescCtrl.text.trim() : _fabricSource,
      tailorName: tailor.name,
      tailorCity: tailor.city,
      status: 'Fabric Received & Registered',
      stageIndex: 0,
      price: _calculatedPrice,
      orderDate: 'Today',
      estimatedDelivery: _expressDelivery ? 'Within 48 hours' : 'In ${tailor.turnaroundDays} days',
      trackingCode: 'LBS-${tailor.city.substring(0, 3).toUpperCase()}-${now.millisecondsSinceEpoch.toString().substring(8)}',
      measurementNotes: _measurementMode,
    );

    state.addStitchingRequest(newOrder);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFD4EDDA),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 32, color: Color(0xFF155724)),
            ),
            const SizedBox(height: 14),
            Text('Stitching Order Confirmed!', textAlign: TextAlign.center, style: heading(18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your request #${newOrder.id} has been submitted to ${tailor.name}.',
              textAlign: TextAlign.center,
              style: body(13, color: AppColors.inkSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.sand,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code, size: 16, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text('Tracking: ${newOrder.trackingCode}',
                      style: body(11.5, weight: FontWeight.w700, color: AppColors.accent)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                go(context, '/myRequests');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('View Active Orders', style: body(12.5, weight: FontWeight.w700, color: AppColors.surface)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen 4: "My Requests" Stitching Orders Tracker
class MyStitchingRequestsScreen extends StatelessWidget {
  const MyStitchingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final orders = state.stitchingRequests;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 14),
          child: Row(
            children: [
              const _BackBtn(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Stitching Orders', style: heading(18)),
                    Text('${orders.length} Active Bespoke Requests',
                        style: body(11, color: AppColors.inkSecondary)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => go(context, '/getStitched'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add, size: 14, color: AppColors.surface),
                      const SizedBox(width: 4),
                      Text('New Order',
                          style: body(11, weight: FontWeight.w700, color: AppColors.surface)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.inkFaint),
                      const SizedBox(height: 12),
                      Text('No Active Stitching Orders', style: heading(16)),
                      const SizedBox(height: 6),
                      Text('Turn unstitched fabrics into bespoke ready-to-wear.',
                          style: body(12, color: AppColors.inkSecondary)),
                      const SizedBox(height: 16),
                      PrimaryButton('Book a Master Darzi', onTap: () => go(context, '/getStitched')),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                  itemCount: orders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final ord = orders[i];
                    return _OrderCard(order: ord);
                  },
                ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final StitchingRequest order;
  const _OrderCard({required this.order});

  static const _stages = ['Fabric Received', 'Cutting', 'Stitching', 'Quality Check', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.soft,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.sand,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(order.id, style: body(10.5, weight: FontWeight.w700, color: AppColors.accent)),
              ),
              Text('Ordered ${order.orderDate}',
                  style: body(11, color: AppColors.inkSecondary)),
            ],
          ),
          const SizedBox(height: 10),
          Text(order.outfitTitle, style: heading(16)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.cut_outlined, size: 13, color: AppColors.accent),
              const SizedBox(width: 5),
              Expanded(
                child: Text('${order.tailorName} · ${order.tailorCity}',
                    overflow: TextOverflow.ellipsis,
                    style: body(12, weight: FontWeight.w600, color: AppColors.inkSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Fabric: ${order.fabricSource}',
              style: body(11.5, color: AppColors.inkFaint)),
          const SizedBox(height: 16),
          // Progress Stages Timeline
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.sand.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Status: ',
                              style: body(11.5, weight: FontWeight.w600, color: AppColors.inkSecondary),
                            ),
                            TextSpan(
                              text: order.status,
                              style: body(11.5, weight: FontWeight.w700, color: AppColors.accent),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Text(
                        'Est: ${order.estimatedDelivery}',
                        style: body(10, weight: FontWeight.w600, color: AppColors.inkSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    for (int idx = 0; idx < _stages.length; idx++) ...[
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: idx <= order.stageIndex ? AppColors.accent : AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: idx <= order.stageIndex ? AppColors.accent : AppColors.hairline,
                          ),
                        ),
                        child: Center(
                          child: idx <= order.stageIndex
                              ? const Icon(Icons.check, size: 10, color: AppColors.surface)
                              : null,
                        ),
                      ),
                      if (idx < _stages.length - 1)
                        Expanded(
                          child: Container(
                            height: 2.5,
                            color: idx < order.stageIndex ? AppColors.accent : AppColors.hairline,
                          ),
                        ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Fit Mode: ${order.measurementNotes}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: body(10.5, color: AppColors.inkSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_2, size: 15, color: AppColors.inkSecondary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        order.trackingCode,
                        overflow: TextOverflow.ellipsis,
                        style: body(11, weight: FontWeight.w600, color: AppColors.inkSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text('Rs. ${order.price}',
                  style: heading(15.5).copyWith(color: AppColors.accent)),
            ],
          ),
        ],
      ),
    );
  }
}
