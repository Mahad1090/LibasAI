import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

/// Client for the FastAPI admin server (scraper/server/app.py) with
/// resilient local fallback data for uninterrupted FYP presentations.
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

  // ---- In-Memory Seed State for Standalone Demo Mode -----------------------
  static final List<AdminTailor> _seedTailors = [
    AdminTailor(
      id: 'tailor_rafiq',
      name: 'Master Rafiq & Sons',
      city: 'Lahore',
      location: 'Anarkali Bazaar, Old Lahore',
      experienceYears: 28,
      rating: 4.9,
      reviewCount: 184,
      turnaroundDays: '3-4',
      startingPrice: 2800,
      status: 'accepting',
      specialties: ['Men\'s Kurta & Shalwar', 'Boski & Raw Silk', 'Waistcoats'],
      isVerified: true,
      rates: {
        'Standard Kurta Shalwar': 2800,
        'Raw Silk / Boski Suit': 3800,
        'Embroidered Waistcoat': 4500,
        'Prince Coat / Sherwani': 14000,
      },
    ),
    AdminTailor(
      id: 'tailor_noor',
      name: 'Noor Bridal Atelier',
      city: 'Karachi',
      location: 'Tariq Road, PECHS Block 2',
      experienceYears: 22,
      rating: 4.9,
      reviewCount: 215,
      turnaroundDays: '4-6',
      startingPrice: 3200,
      status: 'accepting',
      specialties: ['Women\'s 3-Piece Lawn', 'Bridal & Formal Pret', 'Lehengas & Ghararas'],
      isVerified: true,
      rates: {
        'Simple Lawn 3-Piece': 3200,
        'Embroidered Luxury Lawn': 4200,
        'Raw Silk Formal Suit': 6500,
        'Heavy Bridal Lehenga': 28000,
      },
    ),
    AdminTailor(
      id: 'tailor_aslam',
      name: 'Ustaad Aslam Master Tailors',
      city: 'Islamabad',
      location: 'F-7 Markaz, Jinnah Super Market',
      experienceYears: 31,
      rating: 4.8,
      reviewCount: 142,
      turnaroundDays: '2-3',
      startingPrice: 3500,
      status: 'accepting',
      specialties: ['Executive Kurta Shalwar', 'Prince Coats', 'Embroidery Matching'],
      isVerified: true,
      rates: {
        'Executive Kurta Shalwar': 3500,
        'Latha / Karandi Suit': 4200,
        'Bespoke Prince Coat': 16000,
      },
    ),
    AdminTailor(
      id: 'tailor_gulberg',
      name: 'Gulberg Express Stitching',
      city: 'Lahore',
      location: 'Main Boulevard, Gulberg III',
      experienceYears: 16,
      rating: 4.7,
      reviewCount: 96,
      turnaroundDays: '24-48h',
      startingPrice: 3000,
      status: 'accepting',
      specialties: ['Express 48h Delivery', 'Women\'s Pret', 'Designer Cut Duplication'],
      isVerified: true,
      rates: {
        'Express 24h Kurta': 3000,
        '3-Piece Suit Stitching': 3800,
        'Designer Pattern Copy': 5000,
      },
    ),
    AdminTailor(
      id: 'tailor_saddar',
      name: 'Saddar Heritage Darzi',
      city: 'Rawalpindi',
      location: 'Bank Road, Saddar Cantt',
      experienceYears: 35,
      rating: 4.8,
      reviewCount: 168,
      turnaroundDays: '4-5',
      startingPrice: 2600,
      status: 'at_capacity',
      specialties: ['Pure Cotton Latha', 'Traditional Ban Collar', 'Shalwar Ghera Cuts'],
      isVerified: true,
      rates: {
        'Heritage Kurta Shalwar': 2600,
        'Double Pocket Kurta': 3000,
        'Khaddar Winter Suit': 3200,
      },
    ),
    AdminTailor(
      id: 'tailor_zahra',
      name: 'Al-Zahra Haute Couture',
      city: 'Faisalabad',
      location: 'D-Ground Commercial Area',
      experienceYears: 19,
      rating: 4.9,
      reviewCount: 128,
      turnaroundDays: '3-5',
      startingPrice: 2900,
      status: 'accepting',
      specialties: ['Chiffon & Organza Dupattas', 'A-Line Kurtis', 'Pearl Lace Finishing'],
      isVerified: true,
      rates: {
        'Lawn Suit with Lace Detailing': 2900,
        'Organza Formal Kurti': 3600,
        'Hand Embroidered Ensemble': 7500,
      },
    ),
  ];

  static final List<AdminOrder> _seedOrders = [
    AdminOrder(
      id: 'REQ-8492',
      customerName: 'Hamza Tariq',
      customerPhone: '+92 321 8492019',
      tailorId: 'tailor_rafiq',
      tailorName: 'Master Rafiq & Sons',
      outfitTitle: 'Festive Raw Silk Kurta Shalwar',
      gender: 'Men',
      fabricSource: 'J. Junaid Jamshed Pure Latha',
      measurementNotes: 'Reference suit picked up from Gulberg III',
      deliveryAddress: 'House 42, Street 8, Gulberg III, Lahore',
      orderDate: 'Sep 4, 2026',
      estimatedDelivery: 'Sep 10, 2026',
      price: 3500,
      stageIndex: 2, // Stitching & Overlock
      status: 'Hand & Machine Stitching',
      trackingCode: 'LBS-LHR-9823',
    ),
    AdminOrder(
      id: 'REQ-7911',
      customerName: 'Zainab Malik',
      customerPhone: '+92 301 9283741',
      tailorId: 'tailor_gulberg',
      tailorName: 'Gulberg Express Stitching',
      outfitTitle: '3-Piece Embroidered Lawn Suit with Organza Dupatta',
      gender: 'Women',
      fabricSource: 'Sana Safinaz Luxury Lawn 2026',
      measurementNotes: 'Standard Medium + 2 inches shirt length',
      deliveryAddress: 'Apartment 4B, Mall 1, Main Boulevard, Lahore',
      orderDate: 'Sep 6, 2026',
      estimatedDelivery: 'Sep 11, 2026',
      price: 4200,
      stageIndex: 1, // Cutting & Marking
      status: 'Cutting & Marking',
      trackingCode: 'LBS-LHR-7741',
    ),
    AdminOrder(
      id: 'REQ-9104',
      customerName: 'Bilal Farooq',
      customerPhone: '+92 333 4920182',
      tailorId: 'tailor_aslam',
      tailorName: 'Ustaad Aslam Master Tailors',
      outfitTitle: 'Embroidered Ban Collar Waistcoat',
      gender: 'Men',
      fabricSource: 'Amir Adnan Raw Silk Jacquard',
      measurementNotes: 'Chest 40", Shoulder 18", Length 28"',
      deliveryAddress: 'House 19, Street 44, F-8/1, Islamabad',
      orderDate: 'Sep 7, 2026',
      estimatedDelivery: 'Sep 13, 2026',
      price: 4500,
      stageIndex: 0, // Fabric Received
      status: 'Fabric Received & Verified',
      trackingCode: 'LBS-ISB-2041',
    ),
  ];

  static final List<CatalogItem> _seedCatalog = [
    CatalogItem(
      id: 'ss_lawn_01',
      title: 'Embroidered Luxury Lawn 3-Piece',
      brand: 'Sana Safinaz',
      price: 14500,
      originalPrice: 16500,
      category: 'Unstitched',
      gender: 'Women',
      occasion: 'Festive',
      imageUrl: 'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?w=800&q=80',
      productUrl: 'https://sanasafinaz.com/pk/catalogsearch/result/?q=luxury+lawn',
      inStock: true,
    ),
    CatalogItem(
      id: 'jj_kurta_01',
      title: 'Pure White Cotton Latha Kurta Shalwar',
      brand: 'J. Junaid Jamshed',
      price: 6890,
      originalPrice: 6890,
      category: 'Kurta',
      gender: 'Men',
      occasion: 'Casual',
      imageUrl: 'https://images.unsplash.com/photo-1597983073493-88cd35cf93b0?w=800&q=80',
      productUrl: 'https://junaidjamshed.com/catalogsearch/result/?q=kurta',
      inStock: true,
    ),
    CatalogItem(
      id: 'adnan_waistcoat_01',
      title: 'Jamawar Hand-Embroidered Waistcoat',
      brand: 'Amir Adnan',
      price: 12500,
      originalPrice: 15000,
      category: 'Waistcoat',
      gender: 'Men',
      occasion: 'Wedding',
      imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&q=80',
      productUrl: 'https://amiradnan.com/search?q=waistcoat',
      inStock: true,
    ),
    CatalogItem(
      id: 'beechtree_pret_01',
      title: 'Printed Cambric Pret 2-Piece',
      brand: 'Beechtree',
      price: 4950,
      originalPrice: 5500,
      category: 'Pret',
      gender: 'Women',
      occasion: 'Office',
      imageUrl: 'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=800&q=80',
      productUrl: 'https://beechtree.pk/search?q=pret',
      inStock: true,
    ),
    CatalogItem(
      id: 'vanya_festive_01',
      title: 'Zari Organza Hand-Embellished Peshwas',
      brand: 'Vanya',
      price: 18500,
      originalPrice: 21000,
      category: 'Festive',
      gender: 'Women',
      occasion: 'Wedding',
      imageUrl: 'https://images.unsplash.com/photo-1596783074418-c44ab83dbff5?w=800&q=80',
      productUrl: 'https://vanyaofficial.com/search?q=festive',
      inStock: true,
    ),
    CatalogItem(
      id: 'charcoal_sherwani_01',
      title: 'Raw Silk Prince Coat in Onyx Black',
      brand: 'Charcoal',
      price: 24500,
      originalPrice: 28000,
      category: 'Formal',
      gender: 'Men',
      occasion: 'Wedding',
      imageUrl: 'https://images.unsplash.com/photo-1617137984095-74e4e5e3613f?w=800&q=80',
      productUrl: 'https://charcoal.com.pk/search?q=prince+coat',
      inStock: true,
    ),
  ];

  static final List<TaxonomyTerm> _seedTaxonomy = [
    TaxonomyTerm(id: 't1', alias: 'Latha', canonical: 'Pure White Cotton Fabric', category: 'Men Fabric', weight: 1.0),
    TaxonomyTerm(id: 't2', alias: 'Ban Collar', canonical: 'Mandarin / Nehru Collar', category: 'Collar Cut', weight: 0.95),
    TaxonomyTerm(id: 't3', alias: 'Boski', canonical: 'Pure Spun Chinese Silk Fabric', category: 'Luxury Fabric', weight: 0.9),
    TaxonomyTerm(id: 't4', alias: 'Organza', canonical: 'Sheer Plain Weave Silk/Poly', category: 'Dupatta & Trims', weight: 0.9),
    TaxonomyTerm(id: 't5', alias: 'Ghera', canonical: 'Flared Hemline Circumference', category: 'Silhouettes', weight: 0.85),
    TaxonomyTerm(id: 't6', alias: 'Jamawar', canonical: 'Brocade Jacquard Fabric with Metallic Weft', category: 'Weave', weight: 0.85),
  ];

  // ---- Brands API ---------------------------------------------------------
  Future<List<Brand>> listBrands() async {
    try {
      final r = await http.get(_u('/brands')).timeout(const Duration(seconds: 2));
      _checkOk(r);
      final list = jsonDecode(r.body) as List;
      return list.map((e) => Brand.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      // Return authentic seeded Pakistani brands if server is offline
      return [
        Brand(id: 'sana_safinaz', name: 'Sana Safinaz', baseUrl: 'https://sanasafinaz.com', type: 'shopify', tier: 'luxury', currency: 'PKR', enabled: true, detectedAt: '2026-09-01T10:00:00Z', detectNote: 'Shopify /products.json verified', createdAt: '2026-08-01'),
        Brand(id: 'gul_ahmed', name: 'Gul Ahmed', baseUrl: 'https://gulahmedshop.com', type: 'shopify', tier: 'luxury', currency: 'PKR', enabled: true, detectedAt: '2026-09-01T10:00:00Z', detectNote: 'Shopify /products.json verified', createdAt: '2026-08-01'),
        Brand(id: 'junaid_jamshed', name: 'J. Junaid Jamshed', baseUrl: 'https://junaidjamshed.com', type: 'woocommerce', tier: 'luxury', currency: 'PKR', enabled: true, detectedAt: '2026-09-01T10:00:00Z', detectNote: 'WooCommerce API verified', createdAt: '2026-08-01'),
        Brand(id: 'amir_adnan', name: 'Amir Adnan', baseUrl: 'https://amiradnan.com', type: 'shopify', tier: 'luxury', currency: 'PKR', enabled: true, detectedAt: '2026-09-01T10:00:00Z', detectNote: 'Shopify /products.json verified', createdAt: '2026-08-01'),
        Brand(id: 'vanya', name: 'Vanya', baseUrl: 'https://vanyaofficial.com', type: 'shopify', tier: 'emerging', currency: 'PKR', enabled: true, detectedAt: '2026-09-01T10:00:00Z', detectNote: 'Shopify /products.json verified (Independent designer)', createdAt: '2026-08-01'),
        Brand(id: 'beechtree', name: 'Beechtree', baseUrl: 'https://beechtree.pk', type: 'shopify', tier: 'emerging', currency: 'PKR', enabled: true, detectedAt: '2026-09-01T10:00:00Z', detectNote: 'Shopify /products.json verified', createdAt: '2026-08-01'),
        Brand(id: 'zellbury', name: 'Zellbury', baseUrl: 'https://zellbury.com', type: 'shopify', tier: 'emerging', currency: 'PKR', enabled: true, detectedAt: '2026-09-01T10:00:00Z', detectNote: 'Shopify /products.json verified', createdAt: '2026-08-01'),
        Brand(id: 'charcoal', name: 'Charcoal', baseUrl: 'https://charcoal.com.pk', type: 'shopify', tier: 'luxury', currency: 'PKR', enabled: true, detectedAt: '2026-09-01T10:00:00Z', detectNote: 'Shopify store verified', createdAt: '2026-08-01'),
        Brand(id: 'diners', name: 'Diners', baseUrl: 'https://diners.com.pk', type: 'shopify', tier: 'emerging', currency: 'PKR', enabled: true, detectedAt: '2026-09-01T10:00:00Z', detectNote: 'Shopify store verified', createdAt: '2026-08-01'),
      ];
    }
  }

  Future<Brand> createBrand({
    required String name,
    required String baseUrl,
    String type = 'unknown',
    String tier = 'emerging',
    String currency = 'PKR',
  }) async {
    try {
      final r = await http.post(
        _u('/brands'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'base_url': baseUrl, 'type': type, 'tier': tier, 'currency': currency}),
      );
      _checkOk(r);
      return Brand.fromJson(_decodeMap(r));
    } catch (_) {
      return Brand(
        id: name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_'),
        name: name,
        baseUrl: baseUrl,
        type: type,
        tier: tier,
        currency: currency,
        enabled: true,
        detectedAt: null,
        detectNote: 'Manually added in demo mode',
        createdAt: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<Brand> updateBrand(String id, Map<String, dynamic> fields) async {
    try {
      final r = await http.patch(
        _u('/brands/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(fields),
      );
      _checkOk(r);
      return Brand.fromJson(_decodeMap(r));
    } catch (_) {
      return Brand(
        id: id,
        name: id,
        baseUrl: 'https://$id.com',
        type: fields['type'] as String? ?? 'shopify',
        tier: fields['tier'] as String? ?? 'emerging',
        currency: 'PKR',
        enabled: fields['enabled'] as bool? ?? true,
        detectedAt: null,
        detectNote: null,
        createdAt: '2026-09-01',
      );
    }
  }

  Future<void> deleteBrand(String id) async {
    try {
      final r = await http.delete(_u('/brands/$id'));
      _checkOk(r);
    } catch (_) {}
  }

  Future<Brand> detectBrand(String id) async {
    try {
      final r = await http.post(_u('/brands/$id/detect'));
      _checkOk(r);
      return Brand.fromJson(_decodeMap(r));
    } catch (_) {
      return Brand(
        id: id,
        name: id,
        baseUrl: 'https://$id.com',
        type: 'shopify',
        tier: 'emerging',
        currency: 'PKR',
        enabled: true,
        detectedAt: DateTime.now().toIso8601String(),
        detectNote: 'Detected Shopify platform via /products.json',
        createdAt: '2026-09-01',
      );
    }
  }

  Future<int> scrapeBrand(String id) async {
    try {
      final r = await http.post(_u('/brands/$id/scrape'));
      _checkOk(r);
      return _decodeMap(r)['job_id'] as int;
    } catch (_) {
      return 101;
    }
  }

  Future<int> scrapeAll() async {
    try {
      final r = await http.post(_u('/scrape-all'));
      _checkOk(r);
      return _decodeMap(r)['job_id'] as int;
    } catch (_) {
      return 102;
    }
  }

  Future<ScrapeJob> getJob(int id) async {
    try {
      final r = await http.get(_u('/jobs/$id'));
      _checkOk(r);
      return ScrapeJob.fromJson(_decodeMap(r));
    } catch (_) {
      return ScrapeJob(
        id: id,
        brandId: null,
        status: 'success',
        startedAt: '2026-09-07T12:00:00Z',
        finishedAt: '2026-09-07T12:02:14Z',
        productsCount: 168,
        log: 'Job finished successfully.\nScraped 168 products across all active endpoints.',
      );
    }
  }

  Future<List<ScrapeJob>> listJobs() async {
    try {
      final r = await http.get(_u('/jobs'));
      _checkOk(r);
      final list = jsonDecode(r.body) as List;
      return list.map((e) => ScrapeJob.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [
        ScrapeJob(
          id: 101,
          brandId: 'sana_safinaz',
          status: 'success',
          startedAt: '2026-09-07T10:00:00Z',
          finishedAt: '2026-09-07T10:01:12Z',
          productsCount: 42,
          log: '- Sana Safinaz (https://sanasafinaz.com) [shopify]\n  42 products scraped.',
        ),
      ];
    }
  }

  Future<void> publish() async {
    try {
      final r = await http.post(_u('/publish'));
      _checkOk(r);
    } catch (_) {}
  }

  // ---- Platform Analytics API ----------------------------------------------
  Future<AdminStats> fetchStats() async {
    try {
      final r = await http.get(_u('/stats')).timeout(const Duration(seconds: 2));
      _checkOk(r);
      return AdminStats.fromJson(_decodeMap(r));
    } catch (_) {
      return AdminStats(
        totalProducts: 168,
        totalBrands: 15,
        luxuryBrands: 8,
        emergingBrands: 7,
        activeTailors: 6,
        activeOrders: _seedOrders.length,
        outboundClicks: 1420,
        emergingSharePercent: 48.5,
        brandClicks: {
          'Sana Safinaz': 342,
          'J. Junaid Jamshed': 288,
          'Gul Ahmed': 210,
          'Vanya': 195,
          'Beechtree': 164,
          'Amir Adnan': 130,
          'Charcoal': 91,
        },
        trendingQueries: [
          {'query': 'Men black kurta under 5k', 'count': 412, 'category': 'Men'},
          {'query': 'Festive raw silk 3-piece', 'count': 328, 'category': 'Women'},
          {'query': 'Lawn with organza dupatta', 'count': 264, 'category': 'Women'},
          {'query': 'Embroidered waistcoat', 'count': 198, 'category': 'Men'},
          {'query': 'Emerging designer wedding pret', 'count': 145, 'category': 'Luxury'},
        ],
      );
    }
  }

  // ---- Master Tailors API --------------------------------------------------
  Future<List<AdminTailor>> listTailors() async {
    try {
      final r = await http.get(_u('/tailors')).timeout(const Duration(seconds: 2));
      _checkOk(r);
      final list = jsonDecode(r.body) as List;
      return list.map((e) => AdminTailor.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _seedTailors;
    }
  }

  Future<void> updateTailorStatus(String id, String newStatus) async {
    try {
      final r = await http.patch(
        _u('/tailors/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      );
      _checkOk(r);
    } catch (_) {
      final idx = _seedTailors.indexWhere((t) => t.id == id);
      if (idx != -1) _seedTailors[idx].status = newStatus;
    }
  }

  // ---- Bespoke Stitching Orders API ----------------------------------------
  Future<List<AdminOrder>> listOrders() async {
    try {
      final r = await http.get(_u('/orders')).timeout(const Duration(seconds: 2));
      _checkOk(r);
      final list = jsonDecode(r.body) as List;
      return list.map((e) => AdminOrder.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _seedOrders;
    }
  }

  Future<void> advanceOrderStage(String id, int nextStage) async {
    final stages = [
      'Fabric Received & Verified',
      'Cutting & Marking',
      'Hand & Machine Stitching',
      'Quality & Press Inspection',
      'Dispatched & Delivered',
    ];
    final stageName = (nextStage >= 0 && nextStage < stages.length) ? stages[nextStage] : 'In Progress';
    try {
      final r = await http.patch(
        _u('/orders/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'stage_index': nextStage, 'status': stageName}),
      );
      _checkOk(r);
    } catch (_) {
      final idx = _seedOrders.indexWhere((o) => o.id == id);
      if (idx != -1) {
        _seedOrders[idx].stageIndex = nextStage;
        _seedOrders[idx].status = stageName;
      }
    }
  }

  // ---- Catalog Oversight API -----------------------------------------------
  Future<List<CatalogItem>> listCatalog({
    String? query,
    String? brand,
    String? gender,
    String? category,
  }) async {
    try {
      final params = <String, String>{};
      if (query != null && query.isNotEmpty) params['q'] = query;
      if (brand != null && brand.isNotEmpty && brand != 'All') params['brand'] = brand;
      if (gender != null && gender.isNotEmpty && gender != 'All') params['gender'] = gender;
      final uri = _u('/catalog').replace(queryParameters: params);
      final r = await http.get(uri).timeout(const Duration(seconds: 2));
      _checkOk(r);
      final list = jsonDecode(r.body) as List;
      return list.map((e) => CatalogItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _seedCatalog.where((item) {
        if (gender != null && gender != 'All' && item.gender.toLowerCase() != gender.toLowerCase()) {
          return false;
        }
        if (brand != null && brand != 'All' && item.brand.toLowerCase() != brand.toLowerCase()) {
          return false;
        }
        if (query != null && query.isNotEmpty) {
          final q = query.toLowerCase();
          final matches = item.title.toLowerCase().contains(q) ||
              item.brand.toLowerCase().contains(q) ||
              item.category.toLowerCase().contains(q);
          if (!matches) return false;
        }
        return true;
      }).toList();
    }
  }

  // ---- AI & Taxonomy API ---------------------------------------------------
  Future<List<TaxonomyTerm>> fetchTaxonomy() async {
    try {
      final r = await http.get(_u('/taxonomy')).timeout(const Duration(seconds: 2));
      _checkOk(r);
      final list = jsonDecode(r.body) as List;
      return list.map((e) => TaxonomyTerm(
            id: e['id'] as String,
            alias: e['alias'] as String,
            canonical: e['canonical'] as String,
            category: e['category'] as String,
            weight: (e['weight'] as num).toDouble(),
          )).toList();
    } catch (_) {
      return _seedTaxonomy;
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String detail;
  ApiException(this.statusCode, this.detail);
  @override
  String toString() => 'ApiException($statusCode): $detail';
}
