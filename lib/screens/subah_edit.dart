import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class SubahEditScreen extends StatefulWidget {
  const SubahEditScreen({super.key});

  @override
  State<SubahEditScreen> createState() => _SubahEditScreenState();
}

class _SubahEditScreenState extends State<SubahEditScreen> {
  String _selectedWeather = 'warm'; // 'cool' | 'warm' | 'hot' | 'rain'
  String _selectedOccasion = 'office'; // 'office' | 'casual' | 'festive' | 'wedding' | 'gym'
  bool _revealed = false;

  final Map<String, ({String title, String desc, IconData icon, String fabric})> _weatherDefs = {
    'cool': (
      title: 'Cool / Crisp',
      desc: '16°–22°C · Light layers',
      icon: Icons.wb_twilight_outlined,
      fabric: 'Soft khaddar, fine linen, or layered cotton',
    ),
    'warm': (
      title: 'Warm & Sunny',
      desc: '23°–30°C · Daytime pace',
      icon: Icons.wb_sunny_outlined,
      fabric: 'Breathable pure lawn or light printed cotton',
    ),
    'hot': (
      title: 'Peak Heat',
      desc: '31°C+ · Midday heat',
      icon: Icons.whatshot_outlined,
      fabric: 'Ultra-fine unlined lawn in soothing pastel tones',
    ),
    'rain': (
      title: 'Rainy & Humid',
      desc: 'Monsoon humidity',
      icon: Icons.water_drop_outlined,
      fabric: 'Low-fuss cottons that resist creasing in humidity',
    ),
  };

  final Map<String, ({String title, String desc, IconData icon, String vibe})> _occasionDefs = {
    'office': (
      title: 'Desk / Office',
      desc: 'Sharp & presentable',
      icon: Icons.business_center_outlined,
      vibe: 'Clean silhouettes, structured collar, understated elegance',
    ),
    'casual': (
      title: 'Casual Errands',
      desc: 'Easy & relaxed',
      icon: Icons.checkroom_outlined,
      vibe: 'Relaxed A-line kurti or lightweight co-ord set',
    ),
    'festive': (
      title: 'Jummah / Festive',
      desc: 'Traditional morning',
      icon: Icons.auto_awesome_outlined,
      vibe: 'Latha, subtle embroidery, or hand-blocked lawn',
    ),
    'wedding': (
      title: 'Wedding / Event',
      desc: 'Celebration ready',
      icon: Icons.celebration_outlined,
      vibe: 'Raw silk, organza dupatta, or festive jacquard',
    ),
    'gym': (
      title: 'Lounge / Home',
      desc: 'Stripped back comfort',
      icon: Icons.weekend_outlined,
      vibe: 'Softest breathable loungewear & easy-breezy cuts',
    ),
  };

  String get _weekdayGreeting {
    final now = DateTime.now();
    switch (now.weekday) {
      case DateTime.friday:
        return 'Jummah Mubarak · Traditional Morning';
      case DateTime.saturday:
      case DateTime.sunday:
        return 'Weekend Pace · Relaxed Styling';
      default:
        return 'Weekday Rhythm · Daily Edit';
    }
  }

  Product _pickHeroProduct() {
    // Select an appropriate product from kProducts based on occasion
    if (_selectedOccasion == 'wedding') {
      return kProducts.firstWhere(
        (p) => p.occasion.toLowerCase() == 'wedding' || p.category.toLowerCase() == 'festive',
        orElse: () => kProducts[1], // p2
      );
    } else if (_selectedOccasion == 'festive') {
      return kProducts.firstWhere(
        (p) => p.occasion.toLowerCase() == 'eid' || p.category.toLowerCase() == 'pret',
        orElse: () => kProducts[5], // p6
      );
    } else if (_selectedOccasion == 'casual') {
      return kProducts.firstWhere(
        (p) => p.category.toLowerCase() == 'co-ord' || p.priceNumeric < 4000,
        orElse: () => kProducts[20], // p21
      );
    } else {
      // office
      return kProducts.firstWhere(
        (p) => p.category.toLowerCase() == 'pret' && p.priceNumeric > 5000,
        orElse: () => kProducts[0], // p1
      );
    }
  }

  List<Product> _pickAlternatives(String heroId) {
    return kProducts.where((p) => p.id != heroId).take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final hero = _pickHeroProduct();
    final alts = _pickAlternatives(hero.id);
    final weatherInfo = _weatherDefs[_selectedWeather]!;
    final occasionInfo = _occasionDefs[_selectedOccasion]!;

    // Check if wardrobe has matching pieces
    final matchingWardrobeStitched = state.wardrobeItems.where((item) {
      if (!item.isStitched) return false;
      if (_selectedOccasion == 'wedding') {
        return item.tags.contains('wedding') || item.tags.contains('festive');
      } else if (_selectedOccasion == 'festive') {
        return item.tags.contains('festive') || item.tags.contains('eid') || item.tags.contains('traditional');
      } else if (_selectedOccasion == 'office') {
        return item.tags.contains('formal') || item.category == 'Kurta';
      } else {
        return item.tags.contains('casual') || item.tags.contains('cotton');
      }
    }).toList();

    final matchingWardrobeUnstitched = state.wardrobeItems.where((item) {
      return item.isUnstitched;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              'Subah Edit',
              trailingText: 'Closet (${state.wardrobeItems.length})',
              onTrailing: () => go(context, '/wardrobe'),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
                children: [
                  // Editorial Morning Header Banner
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
                              child: const Icon(Icons.wb_sunny_outlined, size: 20, color: AppColors.accent),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MORNING OUTFIT RITUAL',
                                    style: overline(9.5, color: AppColors.accent),
                                  ),
                                  Text(
                                    'What should I wear today?',
                                    style: heading(16),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.sand,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: AppColors.hairline),
                              ),
                              child: Text(
                                'Daily AI Ritual',
                                style: body(10, weight: FontWeight.w700, color: AppColors.accent),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _weekdayGreeting,
                          style: body(12.5, weight: FontWeight.w700, color: AppColors.ink),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'LibasAI checks what you own in My Wardrobe before suggesting fresh pieces from 80+ Pakistani fashion labels.',
                          style: body(11.5, color: AppColors.inkSecondary, height: 1.45),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Step 1: Weather
                  Text('STEP 1 · TODAY\'S MORNING WEATHER', style: overline(10.5, color: AppColors.inkSecondary)),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _weatherDefs.entries.map((entry) {
                        final key = entry.key;
                        final data = entry.value;
                        final isSelected = _selectedWeather == key;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedWeather = key;
                              });
                            },
                            child: Container(
                              width: 130,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.accent.withValues(alpha: 0.06) : AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? AppColors.accent : AppColors.hairline,
                                  width: isSelected ? 1.8 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(data.icon, size: 22, color: isSelected ? AppColors.accent : AppColors.inkFaint),
                                  const SizedBox(height: 10),
                                  Text(
                                    data.title,
                                    style: body(12, weight: FontWeight.w700, color: isSelected ? AppColors.accent : AppColors.ink),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    data.desc,
                                    style: body(10, color: AppColors.inkSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Step 2: Occasion
                  Text('STEP 2 · YOUR PLANS & OCCASION', style: overline(10.5, color: AppColors.inkSecondary)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _occasionDefs.entries.map((entry) {
                      final key = entry.key;
                      final data = entry.value;
                      final isSelected = _selectedOccasion == key;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedOccasion = key;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.accent : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.accent : AppColors.hairline,
                            ),
                            boxShadow: isSelected ? AppShadows.soft : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                data.icon,
                                size: 15,
                                color: isSelected ? AppColors.surface : AppColors.accent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                data.title,
                                style: body(
                                  12,
                                  weight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: isSelected ? AppColors.surface : AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Reveal Button
                  PrimaryButton(
                    _revealed ? 'Regenerate Subah Edit ↻' : 'Reveal Today\'s Subah Edit ✨',
                    onTap: () {
                      setState(() {
                        _revealed = true;
                      });
                    },
                  ),

                  // Revealed Section
                  if (_revealed) ...[
                    const SizedBox(height: 28),

                    // Editorial Rationale Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.sand,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome, size: 16, color: AppColors.accent),
                              const SizedBox(width: 8),
                              Text(
                                'EDITORIAL REASONING',
                                style: overline(9.5, color: AppColors.accent),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Curated for a ${weatherInfo.title.toLowerCase()} and ${occasionInfo.title.toLowerCase()}:',
                            style: body(13, weight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fabric priority is ${weatherInfo.fabric}. Styled around ${occasionInfo.vibe}.',
                            style: body(12, color: AppColors.inkSecondary, height: 1.45),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Wardrobe Match 1: Stitched piece from user's closet
                    if (matchingWardrobeStitched.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF1A7A38).withValues(alpha: 0.3)),
                          boxShadow: AppShadows.soft,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A7A38).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.checkroom, size: 26, color: Color(0xFF1A7A38)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1A7A38),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'FROM YOUR CLOSET',
                                          style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    matchingWardrobeStitched.first.name,
                                    style: body(13, weight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Stitched & ready in your wardrobe — wear this to anchor today\'s look!',
                                    style: body(11, color: AppColors.inkSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // Wardrobe Match 2: Unstitched piece nudge
                    if (matchingWardrobeUnstitched.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF7EB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF8A6A1E).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8A6A1E).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.content_cut_outlined, size: 20, color: Color(0xFF8A6A1E)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'UNSTITCHED FABRIC ALERT',
                                    style: overline(9, color: const Color(0xFF8A6A1E)),
                                  ),
                                  Text(
                                    'You own "${matchingWardrobeUnstitched.first.name}"',
                                    style: body(12, weight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Send it to a master tailor with Get Stitched so it\'s ready for your next event.',
                                    style: body(10.5, color: AppColors.inkSecondary),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => go(context, '/getStitched'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Get Stitched',
                                  style: body(10, weight: FontWeight.w700, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Recommended Hero Product
                    Text('HERO OUTFIT OF THE DAY', style: overline(10.5, color: AppColors.inkSecondary)),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.hairline),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 10,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                                  child: StripePlaceholder(
                                    label: hero.title,
                                    imageUrl: hero.imageUrl,
                                    radius: BorderRadius.zero,
                                    decodeWidth: 480,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    hero.brand.toUpperCase(),
                                    style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        hero.title,
                                        style: heading(16),
                                      ),
                                    ),
                                    Text(
                                      hero.price,
                                      style: body(15, weight: FontWeight.w800, color: AppColors.accent),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${hero.category} · ${hero.occasion} · Available sizes: ${hero.sizes.take(4).join(', ')}',
                                  style: body(11.5, color: AppColors.inkSecondary),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: PrimaryButton(
                                        'Wear This Look 👗',
                                        onTap: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Logged today\'s Subah Edit look: ${hero.title}'),
                                              backgroundColor: const Color(0xFF1A7A38),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: SecondaryButton(
                                        'Save Look',
                                        onTap: () {
                                          state.savedLooks.insert(
                                            0,
                                            SavedLook('subah_${DateTime.now().millisecondsSinceEpoch}', 'Subah Edit: ${hero.title}', [hero.id, 'p11', 'p13']),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Saved to your Lookbook!'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Alternatives Section
                    Text('ALTERNATIVE STYLES FOR TODAY', style: overline(10.5, color: AppColors.inkSecondary)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (final alt in alts)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: alt == alts.first ? 10 : 0),
                              child: ProductCard(alt, compact: true),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
