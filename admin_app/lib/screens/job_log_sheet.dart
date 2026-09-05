import 'dart:async';
import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Bottom sheet that polls a scrape job until it finishes, showing its log.
void showJobLogSheet(BuildContext context, ApiClient api, int jobId, {String? title}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _JobLogSheet(api: api, jobId: jobId, title: title),
  );
}

class _JobLogSheet extends StatefulWidget {
  final ApiClient api;
  final int jobId;
  final String? title;
  const _JobLogSheet({required this.api, required this.jobId, this.title});
  @override
  State<_JobLogSheet> createState() => _JobLogSheetState();
}

class _JobLogSheetState extends State<_JobLogSheet> {
  ScrapeJob? _job;
  Timer? _timer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _poll();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _poll());
  }

  Future<void> _poll() async {
    try {
      final job = await widget.api.getJob(widget.jobId);
      if (!mounted) return;
      setState(() => _job = job);
      if (job.status != 'running') _timer?.cancel();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final job = _job;
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Row(
              children: [
                Expanded(child: Text(widget.title ?? 'Scrape job #${widget.jobId}', style: heading(18))),
                StatusPill(job?.status ?? 'running'),
              ],
            ),
            if (job != null) ...[
              const SizedBox(height: 4),
              Text('${job.productsCount} products so far', style: body(12.5, color: AppColors.inkSecondary)),
            ],
            const SizedBox(height: 14),
            if (_error != null)
              Text(_error!, style: body(12.5, color: AppColors.accent))
            else
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: SelectableText(
                      job?.log.isEmpty ?? true ? 'Starting…' : job!.log,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
