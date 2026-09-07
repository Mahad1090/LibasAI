import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class OrdersAdminScreen extends StatefulWidget {
  const OrdersAdminScreen({super.key});

  @override
  State<OrdersAdminScreen> createState() => _OrdersAdminScreenState();
}

class _OrdersAdminScreenState extends State<OrdersAdminScreen> {
  final _api = ApiClient();
  List<AdminOrder>? _orders;
  String _filter = 'All';
  bool _loading = true;

  static const _stageNames = [
    'Fabric Received',
    'Cutting & Marking',
    'Stitching & Overlock',
    'Quality Inspection',
    'Dispatched / Delivered',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final orders = await _api.listOrders();
    if (mounted) {
      setState(() {
        _orders = orders;
        _loading = false;
      });
    }
  }

  Future<void> _advanceStage(AdminOrder order) async {
    if (order.stageIndex >= _stageNames.length - 1) return;
    final nextStage = order.stageIndex + 1;
    if (!mounted) return;
    setState(() {
      order.stageIndex = nextStage;
      order.status = _stageNames[nextStage];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Advanced ${order.id} to "${_stageNames[nextStage]}"'),
        backgroundColor: AppColors.accent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _orders == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }

    final filtered = _orders!.where((o) {
      if (_filter == 'In Progress' && o.stageIndex >= 4) return false;
      if (_filter == 'Delivered' && o.stageIndex < 4) return false;
      return true;
    }).toList();

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
                Text('Bespoke Stitching Order Ledger', style: heading(22)),
                const SizedBox(height: 4),
                Text('Track physical-to-digital tailoring lifecycle, reference pickups, and stage progression.',
                    style: body(12.5, color: AppColors.inkSecondary)),
              ],
            ),
            Wrap(
              spacing: 8,
              children: ['All', 'In Progress', 'Delivered'].map((tab) {
                final active = _filter == tab;
                return ChoiceChip(
                  label: Text(tab),
                  selected: active,
                  onSelected: (_) => setState(() => _filter = tab),
                  selectedColor: AppColors.accent,
                  labelStyle: TextStyle(
                    color: active ? AppColors.surface : AppColors.ink,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Order cards
        ...filtered.map((ord) {
          final isDelivered = ord.stageIndex >= 4;

          return Container(
            margin: const EdgeInsets.only(bottom: 18),
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
                // Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.sand,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(ord.id, style: body(11, weight: FontWeight.w700, color: AppColors.accent)),
                        ),
                        const SizedBox(width: 10),
                        Text('Tracking: ${ord.trackingCode}',
                            style: body(11.5, weight: FontWeight.w600, color: AppColors.inkSecondary)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 13, color: AppColors.inkFaint),
                        const SizedBox(width: 4),
                        Text('Ordered ${ord.orderDate} · Est. ${ord.estimatedDelivery}',
                            style: body(11, color: AppColors.inkSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Title & Tailor
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ord.outfitTitle, style: heading(17)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.cut, size: 14, color: AppColors.accent),
                              const SizedBox(width: 6),
                              Text('Assigned Darzi: ${ord.tailorName}',
                                  style: body(12.5, weight: FontWeight.w600, color: AppColors.ink)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Fabric Source: ${ord.fabricSource}',
                              style: body(12, color: AppColors.inkSecondary)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Stitching Fee', style: overline(9, color: AppColors.inkFaint)),
                        Text('Rs. ${ord.price}', style: heading(18, color: AppColors.accent)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 5-Stage Stepper
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.sand.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Stage Status: ${ord.status}',
                              style: body(12, weight: FontWeight.w700, color: AppColors.accent)),
                          Text('Step ${ord.stageIndex + 1} of 5',
                              style: body(11, weight: FontWeight.w600, color: AppColors.inkSecondary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          for (int i = 0; i < _stageNames.length; i++) ...[
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: i <= ord.stageIndex ? AppColors.accent : AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: i <= ord.stageIndex ? AppColors.accent : AppColors.hairline,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: i <= ord.stageIndex
                                    ? const Icon(Icons.check, size: 12, color: AppColors.surface)
                                    : Text('${i + 1}', style: body(10, color: AppColors.inkFaint)),
                              ),
                            ),
                            if (i < _stageNames.length - 1)
                              Expanded(
                                child: Container(
                                  height: 3,
                                  color: i < ord.stageIndex ? AppColors.accent : AppColors.hairline,
                                ),
                              ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Customer & Delivery Details Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Client: ${ord.customerName} (${ord.customerPhone})',
                              style: body(12, weight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('Doorstep: ${ord.deliveryAddress}',
                              style: body(11.5, color: AppColors.inkSecondary)),
                          const SizedBox(height: 2),
                          Text('Fitting Mode: ${ord.measurementNotes}',
                              style: body(11, color: AppColors.mutedRose, weight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    if (!isDelivered)
                      PrimaryButton(
                        'Advance to Next Stage →',
                        icon: Icons.fast_forward_rounded,
                        onTap: () => _advanceStage(ord),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF15803D).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF15803D).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, size: 16, color: Color(0xFF15803D)),
                            const SizedBox(width: 6),
                            Text('Order Completed & Delivered',
                                style: body(12, weight: FontWeight.w700, color: const Color(0xFF15803D))),
                          ],
                        ),
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
