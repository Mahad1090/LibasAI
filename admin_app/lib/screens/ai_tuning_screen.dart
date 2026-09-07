import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class AiTuningScreen extends StatefulWidget {
  const AiTuningScreen({super.key});

  @override
  State<AiTuningScreen> createState() => _AiTuningScreenState();
}

class _AiTuningScreenState extends State<AiTuningScreen> {
  final _api = ApiClient();
  List<TaxonomyTerm>? _terms;
  bool _loading = true;

  final _promptController = TextEditingController(
    text: 'You are LibasAI, a premier Pakistani fashion concierge. Always understand traditional garments (Lawn, Pret, Kurta, Shalwar, Boski, Waistcoat, Sherwani, Lehenga). Strictly respect customer budgets in PKR. Promote fair discovery by featuring independent designers (Vanya, Mushq, Zeen) alongside established retail houses (Sana Safinaz, J., Gul Ahmed).',
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final terms = await _api.fetchTaxonomy();
    if (mounted) {
      setState(() {
        _terms = terms;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _terms == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }

    final searchGaps = [
      {'query': 'Velvet bridal shawl maroon', 'hits': 0, 'intent': 'Winter Luxury Formal', 'suggestedBrand': 'Bareeze / Maria.B'},
      {'query': 'Pure Pashmina prince coat', 'hits': 0, 'intent': 'Men Winter Formal', 'suggestedBrand': 'Amir Adnan / Charcoal'},
      {'query': 'Block print ajrak kurta', 'hits': 0, 'intent': 'Sindhi Cultural Ethnic', 'suggestedBrand': 'Generation / Khaadi'},
      {'query': 'Handmade gota patti lehenga', 'hits': 0, 'intent': 'Traditional Wedding', 'suggestedBrand': 'Faiza Saqlain / Vanya'},
    ];

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
                Text('AI Stylist & Cultural Taxonomy Governance', style: heading(22)),
                const SizedBox(height: 4),
                Text('Configure natural language personas, local Urdu fashion synonyms, and catalog gap audits.',
                    style: body(12.5, color: AppColors.inkSecondary)),
              ],
            ),
            PrimaryButton('Save AI Configuration', icon: Icons.save, onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('AI system prompt and synonym weights successfully updated across instances.'),
                  backgroundColor: AppColors.accent,
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 24),

        // Section 1: System Persona & Prompt
        Container(
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
                  Row(
                    children: [
                      const Icon(Icons.psychology_outlined, size: 20, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Text('AI Stylist Core System Prompt', style: heading(16)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.sand,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Active Version: v2.4-PAK',
                        style: body(10.5, weight: FontWeight.w700, color: AppColors.accent)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _promptController,
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.bg.withValues(alpha: 0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                style: body(12.5, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Section 2: Cultural Fashion Taxonomy Dictionary
        Container(
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
                      Text('Pakistani Fashion Taxonomy & Local Synonyms', style: heading(16)),
                      const SizedBox(height: 2),
                      Text('Maps regional dialect, fabrics, and cut terms to standard e-commerce catalog attributes.',
                          style: body(11.5, color: AppColors.inkSecondary)),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16),
                    label: Text('Add Synonym', style: body(12, weight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ..._terms!.map((t) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.sand.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(t.alias,
                              style: body(11.5, weight: FontWeight.w700, color: AppColors.surface)),
                        ),
                        const SizedBox(width: 14),
                        Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.inkFaint),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.canonical, style: body(12.5, weight: FontWeight.w600)),
                              Text('Taxonomy Category: ${t.category}',
                                  style: body(11, color: AppColors.inkSecondary)),
                            ],
                          ),
                        ),
                        Text('Weight: ${t.weight}',
                            style: body(11.5, weight: FontWeight.w700, color: AppColors.accent)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Section 3: Zero-Result Query Gap Audit
        Container(
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
                      Text('Zero-Result Query Gap Audit', style: heading(16)),
                      const SizedBox(height: 2),
                      Text('Unmet customer search demand detected by AI; guides upcoming brand scraping cycles.',
                          style: body(11.5, color: AppColors.inkSecondary)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE11D48).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('4 Catalog Gaps',
                        style: body(11, weight: FontWeight.w700, color: const Color(0xFFE11D48))),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...searchGaps.map((g) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.bg.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_off_rounded, size: 18, color: Color(0xFFE11D48)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('"${g['query']}"', style: body(13, weight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text('Intent: ${g['intent']} · Recommended Target: ${g['suggestedBrand']}',
                                  style: body(11.5, color: AppColors.inkSecondary)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Target added to scrape queue: ${g['suggestedBrand']}')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            foregroundColor: AppColors.accent,
                            side: BorderSide(color: AppColors.accent.withValues(alpha: 0.4)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            minimumSize: const Size(0, 36),
                          ),
                          child: Text('Queue Brand Scrape', style: body(11.5, weight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
