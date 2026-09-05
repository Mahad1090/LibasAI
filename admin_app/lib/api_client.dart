import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

/// Thin client for the FastAPI admin server (scraper/server/app.py).
/// Base URL is overridable at build/run time:
///   flutter run -d chrome --dart-define=API_BASE=http://localhost:8000
class ApiClient {
  final String baseUrl;
  ApiClient({String? baseUrl})
      : baseUrl = baseUrl ??
            const String.fromEnvironment('API_BASE', defaultValue: 'http://127.0.0.1:8000');

  Uri _u(String path) => Uri.parse('$baseUrl$path');

  Map<String, dynamic> _decodeMap(http.Response r) => jsonDecode(r.body) as Map<String, dynamic>;

  void _checkOk(http.Response r) {
    if (r.statusCode >= 400) {
      String detail = r.body;
      try {
        final j = jsonDecode(r.body);
        if (j is Map && j['detail'] != null) detail = j['detail'].toString();
      } catch (_) {}
      throw ApiException(r.statusCode, detail);
    }
  }

  Future<List<Brand>> listBrands() async {
    final r = await http.get(_u('/brands'));
    _checkOk(r);
    final list = jsonDecode(r.body) as List;
    return list.map((e) => Brand.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Brand> createBrand({
    required String name,
    required String baseUrl,
    String type = 'unknown',
    String tier = 'emerging',
    String currency = 'PKR',
  }) async {
    final r = await http.post(
      _u('/brands'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'base_url': baseUrl, 'type': type, 'tier': tier, 'currency': currency}),
    );
    _checkOk(r);
    return Brand.fromJson(_decodeMap(r));
  }

  Future<Brand> updateBrand(String id, Map<String, dynamic> fields) async {
    final r = await http.patch(
      _u('/brands/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(fields),
    );
    _checkOk(r);
    return Brand.fromJson(_decodeMap(r));
  }

  Future<void> deleteBrand(String id) async {
    final r = await http.delete(_u('/brands/$id'));
    _checkOk(r);
  }

  Future<Brand> detectBrand(String id) async {
    final r = await http.post(_u('/brands/$id/detect'));
    _checkOk(r);
    return Brand.fromJson(_decodeMap(r));
  }

  Future<int> scrapeBrand(String id) async {
    final r = await http.post(_u('/brands/$id/scrape'));
    _checkOk(r);
    return _decodeMap(r)['job_id'] as int;
  }

  Future<int> scrapeAll() async {
    final r = await http.post(_u('/scrape-all'));
    _checkOk(r);
    return _decodeMap(r)['job_id'] as int;
  }

  Future<ScrapeJob> getJob(int id) async {
    final r = await http.get(_u('/jobs/$id'));
    _checkOk(r);
    return ScrapeJob.fromJson(_decodeMap(r));
  }

  Future<List<ScrapeJob>> listJobs() async {
    final r = await http.get(_u('/jobs'));
    _checkOk(r);
    final list = jsonDecode(r.body) as List;
    return list.map((e) => ScrapeJob.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> publish() async {
    final r = await http.post(_u('/publish'));
    _checkOk(r);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String detail;
  ApiException(this.statusCode, this.detail);
  @override
  String toString() => 'ApiException($statusCode): $detail';
}
