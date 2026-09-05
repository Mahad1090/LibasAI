class Brand {
  final String id;
  final String name;
  final String baseUrl;
  final String type;
  final String tier;
  final String currency;
  final bool enabled;
  final String? detectedAt;
  final String? detectNote;
  final String createdAt;

  Brand({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.type,
    required this.tier,
    required this.currency,
    required this.enabled,
    required this.detectedAt,
    required this.detectNote,
    required this.createdAt,
  });

  factory Brand.fromJson(Map<String, dynamic> j) => Brand(
        id: j['id'] as String,
        name: j['name'] as String,
        baseUrl: j['base_url'] as String,
        type: j['type'] as String,
        tier: j['tier'] as String,
        currency: j['currency'] as String,
        enabled: j['enabled'] as bool,
        detectedAt: j['detected_at'] as String?,
        detectNote: j['detect_note'] as String?,
        createdAt: j['created_at'] as String,
      );
}

class ScrapeJob {
  final int id;
  final String? brandId;
  final String status; // running | success | failed
  final String startedAt;
  final String? finishedAt;
  final int productsCount;
  final String log;

  ScrapeJob({
    required this.id,
    required this.brandId,
    required this.status,
    required this.startedAt,
    required this.finishedAt,
    required this.productsCount,
    required this.log,
  });

  factory ScrapeJob.fromJson(Map<String, dynamic> j) => ScrapeJob(
        id: j['id'] as int,
        brandId: j['brand_id'] as String?,
        status: j['status'] as String,
        startedAt: j['started_at'] as String,
        finishedAt: j['finished_at'] as String?,
        productsCount: j['products_count'] as int,
        log: j['log'] as String,
      );
}
