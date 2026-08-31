import 'package:flutter/foundation.dart';

class Product {
  final String id, title, brand, brandId, price, oldPrice, category, occasion, imgLabel;
  final bool emerging;
  final List<String> sizes;
  final List<int> colors; // 0xAARRGGBB

  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.brandId,
    required this.emerging,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.occasion,
    required this.sizes,
    required this.colors,
    required this.imgLabel,
  });

  bool get hasOldPrice => oldPrice.isNotEmpty;
}

class Brand {
  final String id, name, tagline;
  final bool emerging;
  final int count;
  const Brand(this.id, this.name, this.tagline, this.emerging, this.count);
  String get initial => name[0];
}

int _c(String hex) => int.parse('FF${hex.substring(1)}', radix: 16);

const kBrands = <Brand>[
  Brand('malika', 'Malika House', 'Bridal & festive couture', false, 86),
  Brand('noorwala', 'Noorwala', 'Modern formal essentials', false, 64),
  Brand('zabasics', 'Za Basics', 'Everyday staples, done well', false, 52),
  Brand('rangrez', 'Rangrez Studio', 'Hand-block prints, small batches', true, 19),
  Brand('threadtehzeeb', 'Thread & Tehzeeb', 'Lawn & unstitched, made local', true, 27),
  Brand('chinar', 'Chinar', "Men's waistcoats & sherwanis", true, 15),
];

final kProducts = <Product>[
  Product(id: 'p1', title: 'Maroon Embroidered Kurta', brand: 'Malika House', brandId: 'malika', emerging: false, price: 'Rs. 7,990', oldPrice: 'Rs. 9,500', category: 'Kurta', occasion: 'Wedding', sizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#7A1F2B'), _c('#171515')], imgLabel: 'PRODUCT PHOTO — maroon embroidered kurta'),
  Product(id: 'p2', title: 'Black Chikankari Kurta', brand: 'Noorwala', brandId: 'noorwala', emerging: false, price: 'Rs. 6,490', oldPrice: '', category: 'Kurta', occasion: 'Formal', sizes: const ['S', 'M', 'L'], colors: [_c('#171515'), _c('#F7EDDF')], imgLabel: 'PRODUCT PHOTO — black chikankari kurta'),
  Product(id: 'p3', title: 'Sage Lawn Suit, 3pc Unstitched', brand: 'Thread & Tehzeeb', brandId: 'threadtehzeeb', emerging: true, price: 'Rs. 4,990', oldPrice: '', category: 'Unstitched', occasion: 'Casual', sizes: const ['Unstitched'], colors: [_c('#8A9A7E'), _c('#F2E4D2')], imgLabel: 'PRODUCT PHOTO — sage lawn 3pc suit'),
  Product(id: 'p4', title: 'Ivory Hand-block Print Suit', brand: 'Rangrez Studio', brandId: 'rangrez', emerging: true, price: 'Rs. 8,250', oldPrice: '', category: 'Festive', occasion: 'Eid', sizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#F7EDDF'), _c('#C98F82')], imgLabel: 'PRODUCT PHOTO — ivory hand-block suit'),
  Product(id: 'p5', title: 'Charcoal Formal Waistcoat', brand: 'Chinar', brandId: 'chinar', emerging: true, price: 'Rs. 5,400', oldPrice: '', category: 'Waistcoat', occasion: 'Formal', sizes: const ['M', 'L', 'XL'], colors: [_c('#171515'), _c('#A76F70')], imgLabel: 'PRODUCT PHOTO — charcoal waistcoat'),
  Product(id: 'p6', title: 'Blush Embellished Shalwar Kameez', brand: 'Malika House', brandId: 'malika', emerging: false, price: 'Rs. 12,990', oldPrice: 'Rs. 15,000', category: 'Shalwar Kameez', occasion: 'Wedding', sizes: const ['S', 'M', 'L'], colors: [_c('#E4C5BA'), _c('#9F1733')], imgLabel: 'PRODUCT PHOTO — blush embellished shalwar kameez'),
  Product(id: 'p7', title: 'White Essential Kurta', brand: 'Za Basics', brandId: 'zabasics', emerging: false, price: 'Rs. 3,490', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#FFFDF9'), _c('#171515')], imgLabel: 'PRODUCT PHOTO — white essential kurta'),
  Product(id: 'p8', title: 'Rust Printed Lawn Kurti', brand: 'Thread & Tehzeeb', brandId: 'threadtehzeeb', emerging: true, price: 'Rs. 3,990', oldPrice: '', category: 'Kurti', occasion: 'Casual', sizes: const ['S', 'M', 'L'], colors: [_c('#B5583A'), _c('#F2E4D2')], imgLabel: 'PRODUCT PHOTO — rust printed kurti'),
  Product(id: 'p9', title: 'Navy Formal Shirt', brand: 'Za Basics', brandId: 'zabasics', emerging: false, price: 'Rs. 4,250', oldPrice: '', category: 'Formal', occasion: 'Office', sizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#22304A'), _c('#FFFDF9')], imgLabel: 'PRODUCT PHOTO — navy formal shirt'),
  Product(id: 'p10', title: 'Maroon Velvet Waistcoat', brand: 'Chinar', brandId: 'chinar', emerging: true, price: 'Rs. 6,900', oldPrice: '', category: 'Waistcoat', occasion: 'Festive', sizes: const ['M', 'L', 'XL'], colors: [_c('#7A1F2B'), _c('#171515')], imgLabel: 'PRODUCT PHOTO — maroon velvet waistcoat'),
  Product(id: 'p11', title: 'Dusty Rose Organza Dupatta', brand: 'Rangrez Studio', brandId: 'rangrez', emerging: true, price: 'Rs. 2,990', oldPrice: '', category: 'Dupatta', occasion: 'Festive', sizes: const ['One Size'], colors: [_c('#C98F82'), _c('#F7EDDF')], imgLabel: 'PRODUCT PHOTO — dusty rose organza dupatta'),
  Product(id: 'p12', title: 'Black Embroidered Kurta', brand: 'Noorwala', brandId: 'noorwala', emerging: false, price: 'Rs. 7,200', oldPrice: '', category: 'Kurta', occasion: 'Eid', sizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#171515'), _c('#9F1733')], imgLabel: "PRODUCT PHOTO — black embroidered kurta, men's"),
  Product(id: 'p13', title: 'Gold Jhumka Earrings', brand: 'Malika House', brandId: 'malika', emerging: false, price: 'Rs. 1,850', oldPrice: '', category: 'Accessories', occasion: 'Wedding', sizes: const ['One Size'], colors: [_c('#C9A227')], imgLabel: 'PRODUCT PHOTO — gold jhumka earrings'),
  Product(id: 'p14', title: 'Nude Embellished Khussa', brand: 'Malika House', brandId: 'malika', emerging: false, price: 'Rs. 3,200', oldPrice: '', category: 'Accessories', occasion: 'Wedding', sizes: const ['36', '37', '38', '39', '40'], colors: [_c('#E4C5BA')], imgLabel: 'PRODUCT PHOTO — nude embellished khussa'),
];

Product productById(String id) => kProducts.firstWhere((p) => p.id == id, orElse: () => kProducts.first);
Brand brandById(String id) => kBrands.firstWhere((b) => b.id == id, orElse: () => kBrands.first);

const kCategoryOptions = ['Women', 'Men', 'Unstitched', 'Pret', 'Formal', 'Casual', 'Eastern Wear', 'Accessories'];
const kStyleOptions = ['Minimal', 'Traditional', 'Modern', 'Festive', 'Luxury', 'Casual', 'Formal', 'Street-inspired', 'Modest'];
const kBudgetOptions = ['Under Rs. 5k', 'Rs. 5k–10k', 'Rs. 10k–20k', 'Rs. 20k+'];
const kColorSwatches = <MapEntry<String, int>>[
  MapEntry('Maroon', 0xFF7A1F2B),
  MapEntry('Black', 0xFF171515),
  MapEntry('Cream', 0xFFF2E4D2),
  MapEntry('Blush', 0xFFE4C5BA),
  MapEntry('Navy', 0xFF22304A),
  MapEntry('Rose', 0xFFC98F82),
];
const kSizeOptions = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
const kSortOptions = ['Recommended', 'Most Relevant', 'Price: Low to High', 'Price: High to Low', 'Newest', 'Popular'];

class ChatMessage {
  final bool isUser;
  final String text;
  final List<String> productIds;
  ChatMessage({required this.isUser, required this.text, this.productIds = const []});
}

class SavedLook {
  final String id, title;
  final List<String> productIds;
  SavedLook(this.id, this.title, this.productIds);
}

/// Single app-wide store.
class AppState extends ChangeNotifier {
  final wished = <String, bool>{};
  final compareIds = <String>[];
  bool compareMode = false;

  final chatMessages = <ChatMessage>[
    ChatMessage(isUser: true, text: 'I need a maroon embroidered outfit for a wedding under Rs. 15,000.'),
    ChatMessage(isUser: false, text: 'I found a few options that fit your budget and occasion.', productIds: ['p1', 'p6', 'p10']),
  ];
  bool thinking = false;

  String searchQuery = '';
  final searchHistory = <String>['Wedding outfit under 15k', 'Black embroidered kurta', 'Blue lawn suit'];
  final recentlyViewed = <String>[];

  String selectedProductId = 'p1';
  String selectedBrandId = 'malika';

  final prefCategories = <String>{};
  final prefStyles = <String>{};
  final prefBrands = <String>{};
  final prefBudget = <String>{};
  final prefColors = <String>{};
  final prefSizes = <String>{};

  final filterCategories = <String>{};
  final filterColors = <String>{};
  final filterSizes = <String>{};
  bool filterEmergingOnly = false;
  String sortOption = 'Recommended';

  final savedLooks = <SavedLook>[
    SavedLook('look1', 'Wedding Guest, Maroon & Gold', ['p1', 'p11', 'p10']),
  ];
  bool settingsNotif = true;
  bool resetSent = false;

  bool isWished(String id) => wished[id] == true;
  void toggleWish(String id) {
    wished[id] = !isWished(id);
    notifyListeners();
  }

  void toggleCompareMode() {
    compareMode = !compareMode;
    if (!compareMode) compareIds.clear();
    notifyListeners();
  }

  void toggleCompareSelect(String id) {
    if (compareIds.contains(id)) {
      compareIds.remove(id);
    } else if (compareIds.length < 4) {
      compareIds.add(id);
    }
    notifyListeners();
  }

  void clearCompare() {
    compareIds.clear();
    compareMode = false;
    notifyListeners();
  }

  void pushRecent(String id) {
    recentlyViewed.remove(id);
    recentlyViewed.insert(0, id);
    if (recentlyViewed.length > 8) recentlyViewed.removeLast();
    notifyListeners();
  }

  void toggleSetMember(Set<String> set, String value) {
    set.contains(value) ? set.remove(value) : set.add(value);
    notifyListeners();
  }

  void addSearch(String q) {
    if (q.trim().isEmpty) return;
    searchHistory.remove(q);
    searchHistory.insert(0, q);
    if (searchHistory.length > 10) searchHistory.removeLast();
    notifyListeners();
  }

  void set<T>(void Function() mutate) {
    mutate();
    notifyListeners();
  }

  List<Product> get wishedProducts => kProducts.where((p) => isWished(p.id)).toList();
  List<Product> get recentProducts => recentlyViewed.map(productById).toList();
}
