import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

const _aiSuggestions = [
  'Find an Eid outfit under Rs. 10k',
  'Compare black kurtas',
  'Show me summer lawn',
  'Build an outfit around this shirt',
  'Find something similar to my photo',
];

const _quickChips = ['Show cheaper', 'Change color', 'More formal', 'Compare these', 'Show local brands'];

void _sendMessage(BuildContext context, AppState state, String text) {
  text = text.trim();
  if (text.isEmpty) return;
  state.set(() {
    state.chatMessages.add(ChatMessage(isUser: true, text: text));
    state.thinking = true;
  });
  if (ModalRoute.of(context)?.settings.name != '/aiChat') {
    Navigator.of(context).pushNamed('/aiChat');
  }

  Future.delayed(const Duration(milliseconds: 1300), () {
    final lower = text.toLowerCase();
    String replyText = '';
    List<String> matchedIds = [];

    if (lower.contains('compare these') || lower == 'compare') {
      final prevBot = state.chatMessages.reversed.firstWhere(
        (m) => !m.isUser && m.productIds.isNotEmpty,
        orElse: () => ChatMessage(isUser: false, text: '', productIds: ['p1', 'p2', 'p6']),
      );
      state.set(() {
        state.compareIds.clear();
        state.compareIds.addAll(prevBot.productIds.take(4));
        state.compareMode = true;
      });
      replyText =
          'I have added these ${state.compareIds.length} items to your comparison table. You can review them side-by-side or ask me to highlight key differences.';
      matchedIds = List.from(state.compareIds);
    } else if (lower.contains('show cheaper') ||
        lower.contains('budget') ||
        lower.contains('affordable')) {
      final cheaper = kProducts
          .where((p) => p.priceNumeric > 0 && p.priceNumeric < 5000)
          .toList()
        ..sort((a, b) => a.priceNumeric.compareTo(b.priceNumeric));
      matchedIds = cheaper.take(4).map((p) => p.id).toList();
      replyText =
          'Here are budget-friendly options under Rs. 5,000 without compromising on fabric quality and styling.';
    } else if (lower.contains('show local') ||
        lower.contains('emerging') ||
        lower.contains('independent')) {
      final emerging = kProducts.where((p) => p.emerging).toList();
      matchedIds = emerging.take(4).map((p) => p.id).toList();
      final brandNames = emerging.take(3).map((p) => p.brand).toSet().join(', ');
      replyText =
          'Highlighting independent Pakistani designer labels ($brandNames). These emerging brands offer unique embroidery and tailored cuts.';
    } else if (lower.contains('more formal') ||
        lower.contains('luxury') ||
        lower.contains('party') ||
        lower.contains('wedding')) {
      final formal = kProducts
          .where((p) =>
              p.occasion.toLowerCase() == 'eid' ||
              (p.category.toLowerCase() == 'pret' && p.priceNumeric > 8000))
          .toList()
        ..sort((a, b) => b.priceNumeric.compareTo(a.priceNumeric));
      matchedIds = formal.take(4).map((p) => p.id).toList();
      replyText =
          'Here are elevated formal and festive selections featuring intricate embroidery and luxury fabric blends.';
    } else if (lower.contains('change color') || lower.contains('color')) {
      final colorsList = [
        kProducts.firstWhere(
            (p) =>
                p.title.toLowerCase().contains('green') ||
                p.imgLabel.toLowerCase().contains('green'),
            orElse: () => kProducts[15]),
        kProducts.firstWhere(
            (p) =>
                p.title.toLowerCase().contains('blue') ||
                p.imgLabel.toLowerCase().contains('blue'),
            orElse: () => kProducts[17]),
        kProducts.firstWhere(
            (p) =>
                p.title.toLowerCase().contains('pink') ||
                p.imgLabel.toLowerCase().contains('pink'),
            orElse: () => kProducts[8]),
        kProducts.firstWhere(
            (p) =>
                p.title.toLowerCase().contains('black') ||
                p.imgLabel.toLowerCase().contains('black'),
            orElse: () => kProducts[18]),
      ];
      matchedIds = colorsList.map((p) => p.id).toList();
      replyText =
          'Here are versatile options across contrasting colorways including rich emerald, rose pink, and deep navy.';
    } else {
      // General semantic & catalog search
      int? maxBudget;
      final kMatch = RegExp(r'(\d+)\s*k\b').firstMatch(lower);
      if (kMatch != null) {
        maxBudget = (int.tryParse(kMatch.group(1)!) ?? 0) * 1000;
      } else {
        final numMatch =
            RegExp(r'(?:under|below|rs\.?|less than)\s*(\d{4,6})').firstMatch(lower);
        if (numMatch != null) {
          maxBudget = int.tryParse(numMatch.group(1)!);
        }
      }

      final colorKeywords = [
        'black',
        'maroon',
        'green',
        'blue',
        'pink',
        'white',
        'gold',
        'navy',
        'cream',
        'rose',
        'brown',
        'purple',
        'yellow',
        'emerald',
        'teal'
      ];
      final detectedColors = colorKeywords.where((c) => lower.contains(c)).toList();

      final isMen = lower.contains('men') || lower.contains('man') || lower.contains('boy');
      final isEid = lower.contains('eid') || lower.contains('festive');
      final isUnstitched = lower.contains('unstitched');
      final isKurta = lower.contains('kurta');
      final isLawn = lower.contains('lawn');

      // Score products
      final scored = kProducts.map((p) {
        int score = 0;
        final title = p.title.toLowerCase();
        final brand = p.brand.toLowerCase();
        final cat = p.category.toLowerCase();
        final occ = p.occasion.toLowerCase();
        final imgLabel = p.imgLabel.toLowerCase();
        final url = p.productUrl.toLowerCase();

        // 1. Color matching (text + hex RGB)
        if (detectedColors.isNotEmpty) {
          for (final c in detectedColors) {
            final inText = title.contains(c) || imgLabel.contains(c) || url.contains(c);
            if (inText) {
              score += 10;
            } else {
              final isHexMatch = p.colors.any((col) {
                final r = (col >> 16) & 0xFF;
                final g = (col >> 8) & 0xFF;
                final b = col & 0xFF;
                if (c == 'black') return r < 55 && g < 55 && b < 55;
                if (c == 'green' || c == 'emerald' || c == 'teal') return g > r && g > b;
                if (c == 'blue' || c == 'navy') return b > r && b > g;
                if (c == 'maroon') return r > 90 && g < 50 && b < 60;
                if (c == 'pink' || c == 'rose') return r > 180 && b > 130;
                if (c == 'white' || c == 'cream') return r > 215 && g > 205 && b > 195;
                return false;
              });
              if (isHexMatch) {
                score += 7;
              } else {
                score -= 3;
              }
            }
          }
        }

        // 2. Budget constraint
        if (maxBudget != null && p.priceNumeric > 0) {
          if (p.priceNumeric <= maxBudget) {
            score += 5;
          } else {
            score -= 6;
          }
        }

        // 3. Gender / Men
        if (isMen) {
          if (title.contains('men') || cat.contains('men') || url.contains('men') || imgLabel.contains('men')) {
            score += 8;
          } else {
            score -= 5;
          }
        }

        // 4. Occasion & category
        if (isEid && (occ.contains('eid') || occ.contains('festive') || title.contains('festive'))) score += 4;
        if (isUnstitched && (cat.contains('unstitched') || title.contains('unstitched') || url.contains('unstitched'))) {
          score += 5;
        }
        if (isKurta && (cat.contains('kurta') || title.contains('kurta') || title.contains('shirt'))) {
          score += 4;
        }
        if (isLawn && (title.contains('lawn') || occ.contains('lawn') || url.contains('lawn'))) score += 4;

        // 5. General term matching
        for (final word in lower.split(RegExp(r'\s+'))) {
          if (word.length > 2) {
            if (title.contains(word)) score += 3;
            if (brand.contains(word)) score += 4;
            if (cat.contains(word)) score += 2;
            if (imgLabel.contains(word)) score += 2;
          }
        }
        return MapEntry(p, score);
      }).toList();

      scored.sort((a, b) => b.value.compareTo(a.value));
      final top = scored.where((e) => e.value > 0).take(4).map((e) => e.key).toList();
      final results = top.isNotEmpty ? top : kProducts.take(4).toList();
      matchedIds = results.map((p) => p.id).toList();

      final brands = results.map((p) => p.brand).toSet().join(' & ');
      final budgetStr = maxBudget != null
          ? ' within Rs. ${maxBudget.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
          : '';
      final colorStr = detectedColors.isNotEmpty ? ' ${detectedColors.join('/')}' : '';
      replyText =
          'Found ${results.length}$colorStr styles from $brands$budgetStr tailored to your query. Each item can be viewed in detail or compared side-by-side.';
    }

    state.set(() {
      state.thinking = false;
      state.chatMessages.add(ChatMessage(
        isUser: false,
        text: replyText,
        productIds: matchedIds,
      ));
    });
  });
}

class _AiHeader extends StatelessWidget {
  const _AiHeader();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 14),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.hairline))),
        child: Row(children: [
          const Icon(Icons.auto_awesome, size: 17, color: AppColors.accent),
          const SizedBox(width: 8),
          Text('LibasAI Assistant', style: body(15, weight: FontWeight.w700)),
        ]),
      );
}

class _Composer extends StatefulWidget {
  final String hint;
  final bool showCamera;
  const _Composer({required this.hint, this.showCamera = false});
  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  final _ctrl = TextEditingController();
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              decoration: InputDecoration.collapsed(
                  hintText: widget.hint, hintStyle: body(13.5, color: AppColors.inkFaint)),
              onSubmitted: (v) {
                _sendMessage(context, state, v);
                _ctrl.clear();
              },
            ),
          ),
          if (widget.showCamera) ...[
            _roundBtn(AppColors.sand, glyph('camera'), AppColors.ink,
                () => go(context, '/imageSearchIntro')),
            const SizedBox(width: 8),
          ],
          _roundBtn(AppColors.accent, glyph('send'), AppColors.surface, () {
            _sendMessage(context, state, _ctrl.text);
            _ctrl.clear();
          }),
        ]),
      ),
    );
  }

  Widget _roundBtn(Color bg, IconData icon, Color fg, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, size: 15, color: fg),
        ),
      );
}

class AiEmptyScreen extends StatelessWidget {
  const AiEmptyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Column(
      children: [
        const _AiHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                      gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(22)),
                  child: const Icon(Icons.auto_awesome, size: 28, color: AppColors.surface),
                ),
                const SizedBox(height: 16),
                Text('Hi, what are we shopping for today?',
                    textAlign: TextAlign.center, style: heading(22).copyWith(height: 1.3)),
                const SizedBox(height: 8),
                Text(
                  "Ask naturally — LibasAI's agents search, compare, and recommend across every brand.",
                  textAlign: TextAlign.center,
                  style: body(13, color: AppColors.inkSecondary),
                ),
                const SizedBox(height: 16),
                for (final sg in _aiSuggestions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: GestureDetector(
                      onTap: () => _sendMessage(context, state, sg),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.button),
                          border: Border.all(color: AppColors.hairline),
                        ),
                        child: Text(sg, style: body(13, weight: FontWeight.w600)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const _Composer(hint: "Describe what you're looking for…", showCamera: true),
        const LibasBottomNav(active: 'ai'),
      ],
    );
  }
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});
  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _scroll = ScrollController();

  void _toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        _toBottom();
        return Column(
          children: [
            const _AiHeader(),
            Expanded(
              child: ListView(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
                children: [
                  for (final m in state.chatMessages) _bubble(context, m),
                  if (state.thinking)
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const _Dots(),
                        const SizedBox(width: 8),
                        Text('Agents are working on it…',
                            style: body(11, weight: FontWeight.w600, color: AppColors.inkSecondary)),
                      ]),
                    ),
                ],
              ),
            ),
            const _Composer(hint: 'Ask a follow-up…'),
            const LibasBottomNav(active: 'ai'),
          ],
        );
      },
    );
  }

  Widget _bubble(BuildContext context, ChatMessage m) {
    if (m.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          constraints: const BoxConstraints(maxWidth: 260),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
          decoration: const BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(m.text, style: body(13.5, color: AppColors.surface, height: 1.45)),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.hairline),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(m.text, style: body(13.5, height: 1.45)),
          ),
          if (m.productIds.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 288,
              child: HScroller(
                [for (final id in m.productIds) ProductCard(productById(id), compact: true)],
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final c in _quickChips)
                GestureDetector(
                  onTap: () => _sendMessage(context, AppScope.of(context), c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
                    ),
                    child: Text(c, style: body(12, weight: FontWeight.w600, color: AppColors.accent)),
                  ),
                ),
            ]),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => go(context, '/aiResults'),
              child: Text('See all options →',
                  style: body(12.5, weight: FontWeight.w700, color: AppColors.accent)),
            ),
          ],
        ],
      ),
    );
  }
}

class _Dots extends StatefulWidget {
  const _Dots();
  @override
  State<_Dots> createState() => _DotsState();
}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final t = ((_c.value + i * 0.2) % 1.0);
            final o = 0.3 + 0.7 * (t < 0.5 ? t * 2 : (1 - t) * 2);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: o,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class AiProcessingScreen extends StatefulWidget {
  const AiProcessingScreen({super.key});
  @override
  State<AiProcessingScreen> createState() => _AiProcessingScreenState();
}

class _AiProcessingScreenState extends State<AiProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/aiResults');
    });
  }

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFF7EDDF);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF650B20), Color(0xFF3D0713)],
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: cream.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(22)),
            child: const Icon(Icons.auto_awesome, size: 28, color: cream),
          ),
          const SizedBox(height: 22),
          Text('Finding your perfect match',
              textAlign: TextAlign.center, style: heading(21, color: cream)),
          const SizedBox(height: 8),
          Text('Four specialized agents are working together',
              style: body(12.5, color: cream.withValues(alpha: 0.55))),
          const SizedBox(height: 30),
          for (final label in const [
            'Search Agent',
            'Recommendation Agent',
            'Comparison Agent',
            'Outfit Agent'
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: cream.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: Icon(Icons.check, size: 14, color: cream.withValues(alpha: 0.9)),
                ),
                const SizedBox(width: 12),
                Text(label, style: body(13.5, weight: FontWeight.w600, color: cream.withValues(alpha: 0.88))),
              ]),
            ),
        ],
      ),
    );
  }
}

class AiResultsScreen extends StatelessWidget {
  const AiResultsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 24),
                children: [
                  Text('Black kurta under Rs. 8,000',
                      style: body(11.5, weight: FontWeight.w600, color: AppColors.inkSecondary)),
                  const SizedBox(height: 4),
                  Text('24 options across 7 brands', style: heading(20)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(left: BorderSide(color: AppColors.accent, width: 2.5)),
                    ),
                    child: Text(
                        'I found 24 options across 7 brands that match your budget and color.',
                        style: body(12.5, color: AppColors.inkSecondary)),
                  ),
                  const SizedBox(height: 14),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final t in ['Black', 'Kurta', '≤ Rs. 8,000'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                            color: AppColors.sand, borderRadius: BorderRadius.circular(AppRadius.pill)),
                        child: Text(t, style: body(11.5, weight: FontWeight.w600)),
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
                    children: [for (final p in kProducts.take(30)) ProductCard(p)],
                  ),
                ],
              ),
            ),
            if (state.compareIds.isNotEmpty) const CompareBar(),
            const LibasBottomNav(active: 'ai'),
          ],
        );
      },
    );
  }
}

class ProductGridToolbar extends StatelessWidget {
  const ProductGridToolbar({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    Widget btn(IconData icon, String label, VoidCallback onTap) => Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(icon, size: 14),
                const SizedBox(width: 7),
                Text(label, style: body(12.5, weight: FontWeight.w600)),
              ]),
            ),
          ),
        );
    return Row(children: [
      btn(glyph('filter'), 'Filter', () => go(context, '/filters')),
      const SizedBox(width: 10),
      btn(glyph('chevronDown'), 'Sort', () => go(context, '/sortSheet')),
      const SizedBox(width: 10),
      GestureDetector(
        onTap: state.toggleCompareMode,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: state.compareMode ? AppColors.accent : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Text('Compare',
              style: body(12.5,
                  weight: FontWeight.w600,
                  color: state.compareMode ? AppColors.surface : AppColors.ink)),
        ),
      ),
    ]);
  }
}

class CompareBar extends StatelessWidget {
  const CompareBar({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(AppRadius.card)),
      child: Row(children: [
        Expanded(
          child: Text('${state.compareIds.length} selected',
              style: body(12.5, weight: FontWeight.w700, color: AppColors.bg)),
        ),
        GestureDetector(
          onTap: state.clearCompare,
          child: Text('Clear', style: body(12, weight: FontWeight.w600, color: AppColors.bg.withValues(alpha: 0.6))),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => go(context, '/productComparison'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Text('Compare Now', style: body(12, weight: FontWeight.w700, color: AppColors.surface)),
          ),
        ),
      ]),
    );
  }
}
