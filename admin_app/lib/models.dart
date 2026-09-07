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
        enabled: j['enabled'] as bool? ?? true,
        detectedAt: j['detected_at'] as String?,
        detectNote: j['detect_note'] as String?,
        createdAt: j['created_at'] as String? ?? '',
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
        productsCount: j['products_count'] as int? ?? 0,
        log: j['log'] as String? ?? '',
      );
}

class AdminStats {
  final int totalProducts;
  final int totalBrands;
  final int luxuryBrands;
  final int emergingBrands;
  final int activeTailors;
  final int activeOrders;
  final int outboundClicks;
  final double emergingSharePercent;
  final Map<String, int> brandClicks;
  final List<Map<String, dynamic>> trendingQueries;

  AdminStats({
    required this.totalProducts,
    required this.totalBrands,
    required this.luxuryBrands,
    required this.emergingBrands,
    required this.activeTailors,
    required this.activeOrders,
    required this.outboundClicks,
    required this.emergingSharePercent,
    required this.brandClicks,
    required this.trendingQueries,
  });

  factory AdminStats.fromJson(Map<String, dynamic> j) => AdminStats(
        totalProducts: j['total_products'] as int? ?? 168,
        totalBrands: j['total_brands'] as int? ?? 15,
        luxuryBrands: j['luxury_brands'] as int? ?? 8,
        emergingBrands: j['emerging_brands'] as int? ?? 7,
        activeTailors: j['active_tailors'] as int? ?? 6,
        activeOrders: j['active_orders'] as int? ?? 2,
        outboundClicks: j['outbound_clicks'] as int? ?? 1420,
        emergingSharePercent: (j['emerging_share_percent'] as num?)?.toDouble() ?? 48.5,
        brandClicks: (j['brand_clicks'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, v as int),
            ) ??
            {},
        trendingQueries: (j['trending_queries'] as List?)
                ?.map((e) => Map<String, dynamic>.from(e as Map))
                .toList() ??
            [],
      );
}

class AdminTailor {
  final String id;
  final String name;
  final String city;
  final String location;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final String turnaroundDays;
  final int startingPrice;
  String status; // accepting | at_capacity | suspended
  final List<String> specialties;
  final bool isVerified;
  final Map<String, int> rates;

  AdminTailor({
    required this.id,
    required this.name,
    required this.city,
    required this.location,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.turnaroundDays,
    required this.startingPrice,
    required this.status,
    required this.specialties,
    required this.isVerified,
    required this.rates,
  });

  factory AdminTailor.fromJson(Map<String, dynamic> j) => AdminTailor(
        id: j['id'] as String,
        name: j['name'] as String,
        city: j['city'] as String,
        location: j['location'] as String,
        experienceYears: j['experience_years'] as int? ?? 15,
        rating: (j['rating'] as num?)?.toDouble() ?? 4.8,
        reviewCount: j['review_count'] as int? ?? 120,
        turnaroundDays: j['turnaround_days'] as String? ?? '3-5',
        startingPrice: j['starting_price'] as int? ?? 2500,
        status: j['status'] as String? ?? 'accepting',
        specialties: (j['specialties'] as List?)?.map((e) => e.toString()).toList() ?? [],
        isVerified: j['is_verified'] as bool? ?? true,
        rates: (j['rates'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, v as int),
            ) ??
            {},
      );
}

class AdminOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String tailorId;
  final String tailorName;
  final String outfitTitle;
  final String gender;
  final String fabricSource;
  final String measurementNotes;
  final String deliveryAddress;
  final String orderDate;
  final String estimatedDelivery;
  final int price;
  int stageIndex;
  String status;
  final String trackingCode;

  AdminOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.tailorId,
    required this.tailorName,
    required this.outfitTitle,
    required this.gender,
    required this.fabricSource,
    required this.measurementNotes,
    required this.deliveryAddress,
    required this.orderDate,
    required this.estimatedDelivery,
    required this.price,
    required this.stageIndex,
    required this.status,
    required this.trackingCode,
  });

  factory AdminOrder.fromJson(Map<String, dynamic> j) => AdminOrder(
        id: j['id'] as String,
        customerName: j['customer_name'] as String? ?? 'Valued Client',
        customerPhone: j['customer_phone'] as String? ?? '+92 300 1234567',
        tailorId: j['tailor_id'] as String,
        tailorName: j['tailor_name'] as String,
        outfitTitle: j['outfit_title'] as String,
        gender: j['gender'] as String? ?? 'Unspecified',
        fabricSource: j['fabric_source'] as String? ?? 'Customer Provided',
        measurementNotes: j['measurement_notes'] as String? ?? '',
        deliveryAddress: j['delivery_address'] as String? ?? 'Gulberg III, Lahore',
        orderDate: j['order_date'] as String,
        estimatedDelivery: j['estimated_delivery'] as String,
        price: j['price'] as int,
        stageIndex: j['stage_index'] as int? ?? 0,
        status: j['status'] as String,
        trackingCode: j['tracking_code'] as String,
      );
}

class CatalogItem {
  final String id;
  final String title;
  final String brand;
  final int price;
  final int originalPrice;
  final String category;
  final String gender;
  final String occasion;
  final String imageUrl;
  final String productUrl;
  final bool inStock;

  CatalogItem({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.category,
    required this.gender,
    required this.occasion,
    required this.imageUrl,
    required this.productUrl,
    required this.inStock,
  });

  factory CatalogItem.fromJson(Map<String, dynamic> j) => CatalogItem(
        id: j['id'] as String,
        title: j['title'] as String,
        brand: j['brand'] as String,
        price: j['price'] as int? ?? 0,
        originalPrice: j['original_price'] as int? ?? 0,
        category: j['category'] as String? ?? 'Uncategorized',
        gender: j['gender'] as String? ?? 'Women',
        occasion: j['occasion'] as String? ?? 'Casual',
        imageUrl: j['image_url'] as String? ?? '',
        productUrl: j['product_url'] as String? ?? '',
        inStock: j['in_stock'] as bool? ?? true,
      );
}

class TaxonomyTerm {
  final String id;
  final String alias;
  final String canonical;
  final String category;
  final double weight;

  TaxonomyTerm({
    required this.id,
    required this.alias,
    required this.canonical,
    required this.category,
    required this.weight,
  });
}
