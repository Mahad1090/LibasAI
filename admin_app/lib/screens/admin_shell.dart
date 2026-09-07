import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../theme.dart';
import 'dashboard_screen.dart';
import 'brands_screen.dart';
import 'tailors_admin_screen.dart';
import 'orders_admin_screen.dart';
import 'catalog_admin_screen.dart';
import 'ai_tuning_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  String _activeTab = 'dashboard';
  final _api = ApiClient();
  AdminStats? _stats;
  bool _backendLive = false;

  @override
  void initState() {
    super.initState();
    _checkBackend();
  }

  Future<void> _checkBackend() async {
    try {
      final s = await _api.fetchStats();
      if (mounted) {
        setState(() {
          _stats = s;
          _backendLive = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _backendLive = false;
        });
      }
    }
  }

  List<({String id, String label, IconData icon, String? badge})> get _navItems => [
    (id: 'dashboard', label: 'Executive Dashboard', icon: Icons.dashboard_outlined, badge: null),
    (id: 'brands', label: 'Brand & Scraper Registry', icon: Icons.storefront_outlined, badge: '${_stats?.totalBrands ?? 21}'),
    (id: 'tailors', label: 'Master Tailor Network', icon: Icons.content_cut_outlined, badge: '${_stats?.activeTailors ?? 6}'),
    (id: 'orders', label: 'Bespoke Stitching Orders', icon: Icons.local_shipping_outlined, badge: '${_stats?.activeOrders ?? 3}'),
    (id: 'catalog', label: 'Catalog & Inventory', icon: Icons.inventory_2_outlined, badge: '${_stats?.totalProducts ?? 6435}'),
    (id: 'ai_tuning', label: 'AI Stylist & Search Tuning', icon: Icons.psychology_outlined, badge: null),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          // Left Navigation Sidebar
          Container(
            width: 270,
            decoration: BoxDecoration(
              color: const Color(0xFF5E0A26), // deep royal burgundy
              border: Border(right: BorderSide(color: AppColors.hairline)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Brand Monogram
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7A122E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.sand.withValues(alpha: 0.3),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(4),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/libasai-emblem.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Image.network(
                            '/assets/libasai-emblem.png',
                            width: 36,
                            height: 36,
                            fit: BoxFit.contain,
                            errorBuilder: (context2, error2, stackTrace2) => Image.asset(
                              'assets/libasai-logo.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LibasAI',
                              style: heading(20, color: AppColors.surface),
                            ),
                            Text(
                              'OPERATIONS PORTAL',
                              style: overline(8.5, color: AppColors.sand.withValues(alpha: 0.7)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(color: AppColors.surface.withValues(alpha: 0.12), height: 1),
                const SizedBox(height: 14),

                // Navigation Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    children: _navItems.map((item) {
                      final isActive = _activeTab == item.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => setState(() => _activeTab = item.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.surface.withValues(alpha: 0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: isActive
                                    ? Border.all(color: AppColors.surface.withValues(alpha: 0.25))
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item.icon,
                                    size: 18,
                                    color: isActive
                                        ? AppColors.sand
                                        : AppColors.surface.withValues(alpha: 0.65),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: body(12.5,
                                          weight: isActive ? FontWeight.w700 : FontWeight.w500,
                                          color: isActive
                                              ? AppColors.surface
                                              : AppColors.surface.withValues(alpha: 0.75)),
                                    ),
                                  ),
                                  if (item.badge != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? AppColors.surface
                                            : AppColors.surface.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        item.badge!,
                                        style: body(10,
                                            weight: FontWeight.w700,
                                            color: isActive ? AppColors.accent : AppColors.surface),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Bottom System Status Box
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: _checkBackend,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _backendLive
                              ? const Color(0xFF22C55E).withValues(alpha: 0.3)
                              : const Color(0xFFF59E0B).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _backendLive ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _backendLive ? 'FastAPI: Live & Connected' : 'FastAPI: Connecting...',
                                  style: body(10.5, weight: FontWeight.w700, color: AppColors.surface),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _backendLive
                                ? 'Port 8000 · 6,435 products · 21 brands'
                                : 'Tap to re-ping port 8000',
                            style: body(9.5, color: AppColors.surface.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main View Content Area
          Expanded(
            child: Column(
              children: [
                // Top App Bar
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('LibasAI Operations',
                              style: body(12, weight: FontWeight.w600, color: AppColors.inkSecondary)),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right, size: 16, color: AppColors.inkFaint),
                          const SizedBox(width: 8),
                          Text(
                            _navItems.firstWhere((i) => i.id == _activeTab).label,
                            style: body(12.5, weight: FontWeight.w700, color: AppColors.ink),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.sand,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shield_outlined, size: 14, color: AppColors.accent),
                                const SizedBox(width: 6),
                                Text('Super Admin Role',
                                    style: body(11, weight: FontWeight.w700, color: AppColors.accent)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                'A',
                                style: body(13, weight: FontWeight.w700, color: AppColors.surface),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Active View Body
                Expanded(
                  child: _buildActiveView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveView() {
    switch (_activeTab) {
      case 'dashboard':
        return DashboardScreen(onNavigate: (tab) => setState(() => _activeTab = tab));
      case 'brands':
        return const BrandsScreen();
      case 'tailors':
        return const TailorsAdminScreen();
      case 'orders':
        return const OrdersAdminScreen();
      case 'catalog':
        return const CatalogAdminScreen();
      case 'ai_tuning':
        return const AiTuningScreen();
      default:
        return DashboardScreen(onNavigate: (tab) => setState(() => _activeTab = tab));
    }
  }
}
