import 'package:flutter/foundation.dart';

class Product {
  final String id, title, brand, brandId, price, oldPrice, category, occasion, imgLabel;
  final bool emerging;
  final List<String> sizes;
  final List<String> inStockSizes; // subset of sizes currently available
  final List<int> colors; // 0xAARRGGBB
  final String imageUrl; // remote product photo; empty => striped placeholder
  final String productUrl; // brand's own PDP (discovery-and-redirect)

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
    this.inStockSizes = const [],
    required this.colors,
    required this.imgLabel,
    this.imageUrl = '',
    this.productUrl = '',
  });

  bool get hasOldPrice => oldPrice.isNotEmpty;
  bool sizeAvailable(String s) => inStockSizes.isEmpty || inStockSizes.contains(s);
  int get priceNumeric => int.tryParse(price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
}

class Brand {
  final String id, name, tagline;
  final bool emerging;
  final int count;
  final String logoUrl;
  const Brand(this.id, this.name, this.tagline, this.emerging, this.count,
      {this.logoUrl = ''});
  String get initial => name[0];
}

int _c(String hex) => int.parse('FF${hex.substring(1)}', radix: 16);

const kBrands = <Brand>[
  Brand('beechtree', 'Beechtree', 'Everyday pret & unstitched', false, 1787, logoUrl: 'https://beechtree.pk/cdn/shop/files/favicon_795a4ade-31bc-437b-bf6f-6c8b2a7dc348.png?crop=center&height=192&v=1732020357&width=192'),
  Brand('ismail_farid', 'Ismail Farid', 'Pakistani fashion', true, 2019, logoUrl: 'https://www.ismailfarid.com/cdn/shop/files/favicon_32x32.png?v=1670475385'),
  Brand('the_cambridge_shop', 'Cambridge', 'Pakistani fashion', false, 8072, logoUrl: 'https://thecambridgeshop.com/cdn/shop/files/Untitled-4.png?v=1686911574&width=192'),
  Brand('uniworth', 'Uniworth', 'Pakistani fashion', false, 6478),
  Brand('unze_london', 'Unze London', 'Pakistani fashion', false, 3141),
  Brand('engine', 'Engine', 'Pakistani fashion', false, 16562),
  Brand('lulusar', 'Lulusar', 'Pakistani fashion', true, 3731),
  Brand('vanya', 'Vanya', 'Modern femininity, designer pret', true, 919, logoUrl: 'https://vanya.pk/cdn/shop/files/Untitled-2.png?crop=center&height=192&v=1613520797&width=192'),
  Brand('mushq', 'Mushq', 'Embroidered pret & bridals', true, 328, logoUrl: 'https://mushq.com/cdn/shop/files/favicon_32x32.png?v=1614075099'),
  Brand('zeen', 'Zeen', 'Wardrobe staples for women', true, 1266, logoUrl: 'https://zeenwoman.com/cdn/shop/files/Untitled-4.png?crop=center&height=192&v=1686735426&width=192'),
  Brand('zaaviay', 'Zaaviay', 'Independent designer label', true, 387, logoUrl: 'https://www.google.com/s2/favicons?domain=zaaviay.com&sz=128'),
  Brand('suffuse', 'Suffuse', 'Sana Yasir\'s formal & festive line', true, 564, logoUrl: 'https://suffuse.pk/cdn/shop/files/FAVICON_48x48.png?v=1614302619'),
  Brand('junaid_jamshed', 'J. Junaid Jamshed', 'Pakistani fashion', false, 20000, logoUrl: 'https://www.google.com/s2/favicons?domain=www.junaidjamshed.com&sz=128'),
  Brand('diners', 'Diners', 'Pakistani fashion', false, 4688, logoUrl: 'https://diners.com.pk/cdn/shop/files/diners_D_32x32_86da2b32-55e9-4d21-b2df-b9c6a2cc9b33_32x32.webp?v=1685348096'),
  Brand('edenrobe', 'Edenrobe', 'Pakistani fashion', false, 18386, logoUrl: 'https://edenrobe.com/cdn/shop/files/favicon_new.png?crop=center&height=192&v=1735988025&width=192'),
  Brand('charcoal', 'Charcoal', 'Pakistani fashion', false, 10828, logoUrl: 'https://charcoal.com.pk/cdn/shop/files/favicon.png?v=1613556833&width=192'),
  Brand('amir_adnan', 'Amir Adnan', 'Pakistani fashion', false, 514, logoUrl: 'https://amiradnan.com/cdn/shop/files/AmirAdnan_fdd1bff0-39fa-4f3d-aa1a-e2038e680ae1_32x32.png?v=1766551811'),
];

final kProducts = <Product>[
  Product(id: 'p1', title: '3 PIECE PRINTED LAWN SUIT-SORCERERS GARDEN (UNSTITCHED)', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 2,694', oldPrice: '', category: 'Unstitched', occasion: 'Casual', sizes: const ['3PCS'], inStockSizes: const ['3PCS'], colors: [_c('#5B7355')], imgLabel: 'PRODUCT PHOTO - 3 PIECE PRINTED LAWN SUIT-SORCERERS GARD', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BT12603UN004795_1.jpg?v=1787262013', productUrl: 'https://beechtree.pk/products/bt12603un004795-green'),
  Product(id: 'p2', title: '3 PIECE EMBROIDERED PAPER COTTON SUIT (LUXURY PRET)', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 10,495', oldPrice: '', category: 'Pret', occasion: 'Eid', sizes: const ['8', '10', '12', '14', '16'], inStockSizes: const ['10'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - 3 PIECE EMBROIDERED PAPER COTTON SUIT (L', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/DSC02336.jpg?v=1787137102', productUrl: 'https://beechtree.pk/products/bt1260003lp2542-black'),
  Product(id: 'p3', title: '3 PIECE EMBROIDERED LAWN SUIT-CHARCOAL CHARM (UNSTITCHED)', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 3,894', oldPrice: '', category: 'Unstitched', occasion: 'Casual', sizes: const ['3PCS'], inStockSizes: const ['3PCS'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - 3 PIECE EMBROIDERED LAWN SUIT-CHARCOAL C', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BT12603UN004924_1.jpg?v=1788177069', productUrl: 'https://beechtree.pk/products/bt12603un004924-black'),
  Product(id: 'p4', title: '2 PIECE EMBROIDERED MULTI NEPS SUIT (FLOW)', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 5,694', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['8', '10', '12', '14'], inStockSizes: const ['8', '10', '12', '14'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - 2 PIECE EMBROIDERED MULTI NEPS SUIT (FLO', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BT1260005FU1026_1.jpg?v=1788175347', productUrl: 'https://beechtree.pk/products/bt1260005fu1026-blue'),
  Product(id: 'p5', title: '2 PIECE PRINTED LAWN SUIT (PRET)', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 3,294', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['8', '10', '12', '14', '16'], inStockSizes: const ['8', '10', '12', '16'], colors: [_c('#F2E1CC'), _c('#DCA998'), _c('#A7A79B')], imgLabel: 'PRODUCT PHOTO - 2 PIECE PRINTED LAWN SUIT (PRET)', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BT1260005DP2135_1_0ea078ca-78d6-4f01-be19-6a964ceae533.jpg?v=1787262002', productUrl: 'https://beechtree.pk/products/bt1260005dp2135-mix'),
  Product(id: 'p6', title: 'EMBROIDERED PANTS', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 1,794', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['8', '10', '12', '14', '16'], inStockSizes: const ['8', '10', '12', '16'], colors: [_c('#F3EDE3')], imgLabel: 'PRODUCT PHOTO - EMBROIDERED PANTS', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BT1260006PT1578_1.jpg?v=1786963907', productUrl: 'https://beechtree.pk/products/bt1260006pt1578-off-white'),
  Product(id: 'p7', title: '3 PIECE EMBROIDERED LAWN SUIT-FORAL SERENITY (UNSTITCHED)', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 3,894', oldPrice: '', category: 'Unstitched', occasion: 'Casual', sizes: const ['3PC'], inStockSizes: const ['3PC'], colors: [_c('#F5E2CE'), _c('#DEAA9D'), _c('#A76861')], imgLabel: 'PRODUCT PHOTO - 3 PIECE EMBROIDERED LAWN SUIT-FORAL SERE', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/bt12603un004879_5_0b44c13a-5052-4112-a2df-639218e43243.jpg?v=1785389957', productUrl: 'https://beechtree.pk/products/bt12603un004879-multi'),
  Product(id: 'p8', title: '2 PIECE DIGITAL PRINTED SUIT', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 2,399', oldPrice: 'Rs. 2,999', category: 'Bottoms', occasion: 'Casual', sizes: const ['3-4Y', '4-5Y', '5-6Y', '6-7Y', '7-8Y', '8-9Y', '9-10Y', '11-12Y'], inStockSizes: const ['3-4Y', '4-5Y', '5-6Y', '6-7Y', '7-8Y', '8-9Y', '9-10Y', '11-12Y', '13-14Y', '15-16Y'], colors: [_c('#DBCAB5'), _c('#6C6756'), _c('#9A6956')], imgLabel: 'PRODUCT PHOTO - 2 PIECE DIGITAL PRINTED SUIT', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BK12603GEWS29646_1.jpg?v=1785327253', productUrl: 'https://beechtree.pk/products/bk12603gews29646-multi'),
  Product(id: 'p9', title: '2 PIECE PRINTED TWO WAY SLUB SUIT (PRET)', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 4,074', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['8', '10', '12', '14', '16'], inStockSizes: const ['8', '10', '16'], colors: [_c('#F2E0C8'), _c('#E16334'), _c('#E6915F')], imgLabel: 'PRODUCT PHOTO - 2 PIECE PRINTED TWO WAY SLUB SUIT (PRET)', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BT1260004DP2109_1.jpg?v=1784189566', productUrl: 'https://beechtree.pk/products/bt1260004dp2109-mix'),
  Product(id: 'p10', title: '3 PIECE PRINTED LAWN SUIT-DAY MAGIC (UNSTITCHED)', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 2,694', oldPrice: '', category: 'Unstitched', occasion: 'Casual', sizes: const ['3PC'], inStockSizes: const ['3PC'], colors: [_c('#EDDECD'), _c('#A4A098'), _c('#C8B6A0')], imgLabel: 'PRODUCT PHOTO - 3 PIECE PRINTED LAWN SUIT-DAY MAGIC (UNS', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BT12602UN004509_1_878e230e-950d-42da-b768-93402e617f6a.jpg?v=1784969084', productUrl: 'https://beechtree.pk/products/bt12602un004509-multi'),
  Product(id: 'p11', title: 'FLORAL EMBROIDERED DRESS', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 1,650', oldPrice: 'Rs. 2,099', category: 'Bottoms', occasion: 'Casual', sizes: const ['1-2Y', '2-3Y', '3-4Y', '4-5Y', '5-6Y', '6-7Y', '7-8Y'], inStockSizes: const ['1-2Y'], colors: [_c('#B5583A')], imgLabel: 'PRODUCT PHOTO - FLORAL EMBROIDERED DRESS', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BK12602LGWD7591_1.jpg?v=1782194142', productUrl: 'https://beechtree.pk/products/bk12602lgwd7591-rust'),
  Product(id: 'p12', title: '3 PIECE EMBROIDERED LAWN SUIT (LUXURY PRET)', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 10,194', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['8', '10', '12', '14'], inStockSizes: const ['8', '10', '12', '14'], colors: [_c('#B0C7CA'), _c('#96B2B3'), _c('#625855')], imgLabel: 'PRODUCT PHOTO - 3 PIECE EMBROIDERED LAWN SUIT (LUXURY PR', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BT12601UN004174A_1.jpg?v=1781090581', productUrl: 'https://beechtree.pk/products/bt12601un004174a-azure-mist'),
  Product(id: 'p13', title: '2 PIECE EMBROIDERED SLUB SUIT (PRET)', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 4,495', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['8', '10', '12', '14', '16'], inStockSizes: const ['8'], colors: [_c('#5B7355')], imgLabel: 'PRODUCT PHOTO - 2 PIECE EMBROIDERED SLUB SUIT (PRET)', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BT1260003PR0137_1.jpg?v=1779428626', productUrl: 'https://beechtree.pk/products/bt1260003pr0137-dk-green'),
  Product(id: 'p14', title: 'BASIC STRAIGHT PANTS', brand: 'Beechtree', brandId: 'beechtree', emerging: false, price: 'Rs. 1,494', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['8', '10', '12', '14', '16'], inStockSizes: const ['8'], colors: [_c('#F2E8DD'), _c('#CC946F'), _c('#A57154')], imgLabel: 'PRODUCT PHOTO - BASIC STRAIGHT PANTS', imageUrl: 'https://cdn.shopify.com/s/files/1/0488/9201/8848/files/BT1260002PT1514_1.jpg?v=1771916448', productUrl: 'https://beechtree.pk/products/bt1260002pt1514-mix'),
  Product(id: 'p15', title: 'SAGE GREEN KURTA PAJAMA', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 22,500', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['S', 'M', 'MCL', 'L', 'XL'], inStockSizes: const ['S', 'M', 'MCL', 'L', 'XL'], colors: [_c('#5B7355')], imgLabel: 'PRODUCT PHOTO - SAGE GREEN KURTA PAJAMA', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/DLRT157_1.jpg?v=1760524154', productUrl: 'https://ismailfarid.com/products/sage-green-kurta-pajama-dkrt157'),
  Product(id: 'p16', title: 'SKY BLUE LINEN SHIRT', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 12,500', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['14.5', '15.5 (Slim)', '15.5', '16.5 (Slim)', '16.5', '17.5 (Slim)', '17.5'], inStockSizes: const ['14.5', '15.5 (Slim)', '15.5', '16.5 (Slim)', '16.5', '17.5 (Slim)', '17.5'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - SKY BLUE LINEN SHIRT', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/LIN292_1.jpg?v=1778265976', productUrl: 'https://ismailfarid.com/products/sky-blue-linen-shirt-lin292'),
  Product(id: 'p17', title: 'PREMIUM GRAY KAMEEZ SHALWAR', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 18,500', oldPrice: '', category: 'Shalwar Kameez', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL', 'M-Classic'], inStockSizes: const ['S', 'M', 'L', 'XL', 'M-Classic'], colors: [_c('#8C8783')], imgLabel: 'PRODUCT PHOTO - PREMIUM GRAY KAMEEZ SHALWAR', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/SHK2493_1.jpg?v=1757931780', productUrl: 'https://ismailfarid.com/products/premium-gray-kameez-shalwar-shk2493'),
  Product(id: 'p18', title: 'IVORY TEXTURED KURTA PAJAMA', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 18,500', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['S', 'M', 'MC', 'L', 'XL'], inStockSizes: const ['S', 'M', 'MC', 'L', 'XL'], colors: [_c('#F7EDDF')], imgLabel: 'PRODUCT PHOTO - IVORY TEXTURED KURTA PAJAMA', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/1_af7d0f1d-b803-4eeb-9b5e-30bcf6793de8.jpg?v=1768924918', productUrl: 'https://ismailfarid.com/products/ivory-textured-kurta-pajama-dkrt170'),
  Product(id: 'p19', title: 'BLACK SELF EMBROIDERED WAISTCOAT', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 48,000', oldPrice: '', category: 'Waistcoat', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - BLACK SELF EMBROIDERED WAISTCOAT', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/WST496_1.jpg?v=1760169544', productUrl: 'https://ismailfarid.com/products/black-self-embroidered-waistcoat-wst496'),
  Product(id: 'p20', title: 'SEA FOAM EMBROIDERED WAISTCOAT', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 38,000', oldPrice: '', category: 'Waistcoat', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#B3CACF'), _c('#6F5C5A'), _c('#788A8E')], imgLabel: 'PRODUCT PHOTO - SEA FOAM EMBROIDERED WAISTCOAT', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/WST473_1.jpg?v=1748243444', productUrl: 'https://ismailfarid.com/products/sea-foam-embroidered-waistcoat-wst473'),
  Product(id: 'p21', title: 'LIGHT BROWN LINEN SHIRT', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 12,500', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['14.5', '15.5 (Slim)', '15.5', '16.5 (Slim)', '16.5', '17.5 (Slim)', '17.5'], inStockSizes: const ['14.5', '15.5 (Slim)', '15.5', '16.5 (Slim)', '16.5', '17.5 (Slim)', '17.5'], colors: [_c('#6B4A32')], imgLabel: 'PRODUCT PHOTO - LIGHT BROWN LINEN SHIRT', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/lin225.jpg?v=1721422767', productUrl: 'https://ismailfarid.com/products/light-brown-linen-shirt-lin225'),
  Product(id: 'p22', title: 'LIGHT GREEN EMBROIDERED JACKET', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 285,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#5B7355')], imgLabel: 'PRODUCT PHOTO - LIGHT GREEN EMBROIDERED JACKET', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/JKT248-B-2.jpg?v=1727693486', productUrl: 'https://ismailfarid.com/products/light-green-embroidered-jacket-jkt248-b'),
  Product(id: 'p23', title: 'CREAM JOG PANT', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 15,500', oldPrice: '', category: 'Bottoms', occasion: 'Everyday', sizes: const ['32', '34', '36', '38', '40'], inStockSizes: const ['32', '34', '36', '38', '40'], colors: [_c('#F2E4D2')], imgLabel: 'PRODUCT PHOTO - CREAM JOG PANT', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/PNT334_3.jpg?v=1721911984', productUrl: 'https://ismailfarid.com/products/cream-jog-pant-pnt334'),
  Product(id: 'p24', title: 'BLUE CHECKERED SHIRT', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 9,800', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['14.5', '15.5 (Slim)', '15.5', '16.5 (Slim)', '16.5', '17.5 (Slim)', '17.5'], inStockSizes: const ['14.5', '15.5 (Slim)', '15.5', '16.5 (Slim)', '16.5', '17.5 (Slim)', '17.5'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - BLUE CHECKERED SHIRT', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/CHK141-_1.jpg?v=1702381024', productUrl: 'https://ismailfarid.com/products/blue-checkered-shirt-chk141'),
  Product(id: 'p25', title: 'RUST CLASSIC TWO BUTTONS JACKET', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 95,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['M', 'L'], colors: [_c('#B5583A')], imgLabel: 'PRODUCT PHOTO - RUST CLASSIC TWO BUTTONS JACKET', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/files/JKT226_1.jpg?v=1686654741', productUrl: 'https://ismailfarid.com/products/rust-classic-two-buttons-blazer-jkt226'),
  Product(id: 'p26', title: 'BLACK APPLEAQUE PRINCE SUIT', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 185,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - BLACK APPLEAQUE PRINCE SUIT', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/products/jkt171---main_6.jpg?v=1669798172', productUrl: 'https://ismailfarid.com/products/black-appleaque-prince-suit-jkt171'),
  Product(id: 'p27', title: 'LIGHT BLUE PRINT SHIRT', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 7,800', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['14.5', '15.5', '15.5 (SLIM)', '16.5', '16.5 (SLIM)', '17.5', '17.5 (SLIM)'], inStockSizes: const ['14.5', '15.5', '15.5 (SLIM)', '16.5', '16.5 (SLIM)', '17.5', '17.5 (SLIM)'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - LIGHT BLUE PRINT SHIRT', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/products/frl940-_1.jpg?v=1669797804', productUrl: 'https://ismailfarid.com/products/light-blue-print-shirt-frl940'),
  Product(id: 'p28', title: 'BROWN CLASSIC SUIT', brand: 'Ismail Farid', brandId: 'ismail_farid', emerging: true, price: 'Rs. 95,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#6B4A32')], imgLabel: 'PRODUCT PHOTO - BROWN CLASSIC SUIT', imageUrl: 'https://cdn.shopify.com/s/files/1/0508/0675/1423/products/main---sut233_5.jpg?v=1669801769', productUrl: 'https://ismailfarid.com/products/brown-classic-suit-sut233'),
  Product(id: 'p29', title: 'MEN\'S BUTTON POLO FULL SLEEVES', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 4,995', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#8C8783')], imgLabel: 'PRODUCT PHOTO - MEN\'S BUTTON POLO FULL SLEEVES', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/0022_W26PSW01-Grey.jpg?v=1789015010', productUrl: 'https://thecambridgeshop.com/products/full-sleeves-waffle-polo-w26psw01-ash-grey'),
  Product(id: 'p30', title: 'Formal Reversible Belt - Black and Tan', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 6,495', oldPrice: '', category: 'Pret', occasion: 'Formal', sizes: const ['32', '34', '36', '38', '40', '42', '43', '44'], inStockSizes: const ['34', '36'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Formal Reversible Belt - Black and Tan', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/BTL26-06.jpg?v=1783941399', productUrl: 'https://thecambridgeshop.com/products/belts-btl26-06-black'),
  Product(id: 'p31', title: 'ACID WASH SHIRT - MAROON', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 3,996', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'], inStockSizes: const ['M', 'L', 'XL'], colors: [_c('#7A1F2B')], imgLabel: 'PRODUCT PHOTO - ACID WASH SHIRT - MAROON', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/7927.jpg?v=1779280194', productUrl: 'https://thecambridgeshop.com/products/half-sleeve-acid-wash-t-shirt-s26bas01-maroon'),
  Product(id: 'p32', title: 'JUNIOR SHALWAR SUIT', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 5,995', oldPrice: 'Rs. 8,995', category: 'Shalwar Kameez', occasion: 'Eid', sizes: const ['3-4 years', '5-6 years', '7-8 years', '9-10 years', 'T1', 'T2', 'T3', 'T4'], inStockSizes: const ['5-6 years', '7-8 years', 'T1', 'T2', 'T3', 'T4'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - JUNIOR SHALWAR SUIT', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/0011_GBKB2602Whitecopy.jpg?v=1777891238', productUrl: 'https://thecambridgeshop.com/products/junior-shalwar-suit-gbkb-2602-white'),
  Product(id: 'p33', title: 'PERFORMANCE BUTTON POLO - PURPLE (E-FACTORY OUTLET)', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 2,457', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'], inStockSizes: const ['M', 'L'], colors: [_c('#4A3B52')], imgLabel: 'PRODUCT PHOTO - PERFORMANCE BUTTON POLO - PURPLE (E-FACT', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/7372.jpg?v=1776497749', productUrl: 'https://thecambridgeshop.com/products/half-sleeve-performance-buttoned-polo-s26pbp01-b-purple'),
  Product(id: 'p34', title: 'PERFORMANCE BUTTON POLO - LAVENDER', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 2,866', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'], inStockSizes: const ['S'], colors: [_c('#B9A7CE')], imgLabel: 'PRODUCT PHOTO - PERFORMANCE BUTTON POLO - LAVENDER', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/Men_s_Half_Sleeve_Performance_Buttoned_Polo_Shirt_in_Lavender_-_Summer_Collection_Cambridge.jpg?v=1781010699', productUrl: 'https://thecambridgeshop.com/products/half-sleeve-performance-buttoned-polo-s26pbp01-lavender'),
  Product(id: 'p35', title: 'ACID WASH MAROON T-SHIRT', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 2,376', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'], inStockSizes: const ['XL'], colors: [_c('#7A1F2B')], imgLabel: 'PRODUCT PHOTO - ACID WASH MAROON T-SHIRT', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/C08825.jpg?v=1776165648', productUrl: 'https://thecambridgeshop.com/products/half-sleeve-acid-wash-t-shirt-s26tas01-maroon'),
  Product(id: 'p36', title: 'Half Sleeves Casual T-Shirt', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 1,448', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S'], colors: [_c('#5B7355')], imgLabel: 'PRODUCT PHOTO - Half Sleeves Casual T-Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/CK24-36-Salty_feb5e5cc-f792-4b8f-91df-c583b8c857e6.jpg?v=1756208883', productUrl: 'https://thecambridgeshop.com/products/h-s-summer-tee-ck24-36'),
  Product(id: 'p37', title: 'BASIC SHALWAR KAMEEZ', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 8,046', oldPrice: 'Rs. 11,495', category: 'Shalwar Kameez', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#6B4A32'), _c('#2F6E6A')], imgLabel: 'PRODUCT PHOTO - BASIC SHALWAR KAMEEZ', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/1_07e74490-a7b1-48f2-a900-bbceaec9851c.jpg?v=1761894391', productUrl: 'https://thecambridgeshop.com/products/basic-winter-wwb-2516'),
  Product(id: 'p38', title: 'DESIGNER SWEATER', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 7,206', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#8C8783')], imgLabel: 'PRODUCT PHOTO - DESIGNER SWEATER', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/1_64c3b8e8-e6d4-40ab-a9af-b3472c87cd0d.jpg?v=1761056430', productUrl: 'https://thecambridgeshop.com/products/sleeve-less-lambs-wool-sweater-swd26-22-ash-grey'),
  Product(id: 'p39', title: 'SHALWAR SUIT', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 7,696', oldPrice: '', category: 'Shalwar Kameez', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['M'], colors: [_c('#8C8783')], imgLabel: 'PRODUCT PHOTO - SHALWAR SUIT', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/AKS2573STEELGREY.jpg?v=1758371305', productUrl: 'https://thecambridgeshop.com/products/fancy-suit-aks2573-ash-grey'),
  Product(id: 'p40', title: 'Dyed Denim Shorts Regular Fit - Aqua', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 2,098', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['30', '31', '32', '33', '34', '35', '36', '38'], inStockSizes: const ['40'], colors: [_c('#4A6079')], imgLabel: 'PRODUCT PHOTO - Dyed Denim Shorts Regular Fit - Aqua', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/DyeddenimShortsCDDS2501Aqua_2.jpg?v=1754543557', productUrl: 'https://thecambridgeshop.com/products/denim-shorts-cdds2501'),
  Product(id: 'p41', title: 'Thermal Top', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 2,516', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'L'], colors: [_c('#171515'), _c('#33302E'), _c('#8C8783'), _c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - Thermal Top', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/KTT2302Grey__1_d27286da-bd6f-419b-b89e-1c011dd4ac61.jpg?v=1737366821', productUrl: 'https://thecambridgeshop.com/products/fs-thermal-top-ktt24-01'),
  Product(id: 'p42', title: 'PRINTED SHIRT  - BLACK', brand: 'Cambridge', brandId: 'the_cambridge_shop', emerging: false, price: 'Rs. 1,993', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'], inStockSizes: const ['S'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - PRINTED SHIRT  - BLACK', imageUrl: 'https://cdn.shopify.com/s/files/1/0283/5510/0758/files/BC4-001_1_b9efb88b-fb5b-4f04-9f45-c9fc022e25ef.jpg?v=1757076112', productUrl: 'https://thecambridgeshop.com/products/half-sleeves-casual-shirt-bc4-009'),
  Product(id: 'p43', title: 'Gun Metalic Square Cufflink', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 2,995', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['F.S'], inStockSizes: const ['F.S'], colors: [_c('#2B302E'), _c('#7E8289'), _c('#B6BAC2')], imgLabel: 'PRODUCT PHOTO - Gun Metalic Square Cufflink', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/CK2698.jpg?v=1789036838', productUrl: 'https://uniworthshop.com/products/gun-metalic-square-cufflink-ck2698'),
  Product(id: 'p44', title: 'White Plain Classic Fit Shirt', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 5,995', oldPrice: '', category: 'Kurta', occasion: 'Formal', sizes: const ['14½', '15', '15½', '16', '16½', '17', '17½', '18'], inStockSizes: const ['16', '17'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - White Plain Classic Fit Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/a8e5dd56f23ee46e25acf488aa28a06e.jpg?v=1782816488', productUrl: 'https://uniworthshop.com/products/white-plain-classic-fit-shirt-fs1524-3rf'),
  Product(id: 'p45', title: 'D Grey Straight Fit Denim', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 6,495', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['30', '32', '34', '36', '38', '40', '42', '44'], inStockSizes: const ['32', '34', '36', '38', '40', '42'], colors: [_c('#8C8783')], imgLabel: 'PRODUCT PHOTO - D Grey Straight Fit Denim', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/DM2604.jpg?v=1779356407', productUrl: 'https://uniworthshop.com/products/d-grey-straight-fit-denim-dm2604'),
  Product(id: 'p46', title: 'Sky Stripe Tailored Smart Fit Shirt', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 9,975', oldPrice: '', category: 'Kurta', occasion: 'Formal', sizes: const ['14½', '15', '15½', '16', '16½', '17', '17½', '18'], inStockSizes: const ['14½', '16'], colors: [_c('#8FB3D4')], imgLabel: 'PRODUCT PHOTO - Sky Stripe Tailored Smart Fit Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/FS2907-1RF_d12b64b3-ab08-4ef3-8ae0-e00534eca691.jpg?v=1776343961', productUrl: 'https://uniworthshop.com/products/sky-stripe-tailored-smart-fit-shirt-fs2907-1sf'),
  Product(id: 'p47', title: 'Navy Texture Smart Fit Kameez Shalwar', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 12,975', oldPrice: '', category: 'Shalwar Kameez', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S'], colors: [_c('#22304A')], imgLabel: 'PRODUCT PHOTO - Navy Texture Smart Fit Kameez Shalwar', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/KS2613S.jpg?v=1771586350', productUrl: 'https://uniworthshop.com/products/navy-texture-kameez-shalwar-ks2613s'),
  Product(id: 'p48', title: 'Navy Slub Designer Waistcoat', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 14,995', oldPrice: '', category: 'Waistcoat', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XXL'], colors: [_c('#22304A')], imgLabel: 'PRODUCT PHOTO - Navy Slub Designer Waistcoat', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/1PAJWC833-1.jpg?v=1769849552', productUrl: 'https://uniworthshop.com/products/navy-slub-designer-waistcoat-1pajwc833-1'),
  Product(id: 'p49', title: 'Equality Mustard Pullover Hoodie', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 6,495', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'XXL'], colors: [_c('#C99A2E')], imgLabel: 'PRODUCT PHOTO - Equality Mustard Pullover Hoodie', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/TH2402.jpg?v=1769850241', productUrl: 'https://uniworthshop.com/products/equality-mustard-pullover-hoodie-th2402'),
  Product(id: 'p50', title: 'Charcoal Texture Tailored Smart Fit Suit', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 36,995', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['34', '36', '38', '40', '42', '44', '46', '48'], inStockSizes: const ['34'], colors: [_c('#33302E')], imgLabel: 'PRODUCT PHOTO - Charcoal Texture Tailored Smart Fit Suit', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/ST860-1S.jpg?v=1769849852', productUrl: 'https://uniworthshop.com/products/charcoal-texture-tailored-smart-fit-suit-st860-1s'),
  Product(id: 'p51', title: 'Camel Smart Fit Denim', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 6,495', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['30', '32', '34', '36', '38', '40', '42', '44'], inStockSizes: const ['30', '32', '34', '36', '38', '40'], colors: [_c('#4A6079')], imgLabel: 'PRODUCT PHOTO - Camel Smart Fit Denim', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/d25b912a0987adab2c75edb338686e92.jpg?v=1769849112', productUrl: 'https://uniworthshop.com/products/camel-smart-fit-denim-dm2523'),
  Product(id: 'p52', title: 'Beige Stripe Classic Fit  Shirt', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 9,975', oldPrice: '', category: 'Kurta', occasion: 'Formal', sizes: const ['14½', '15', '15½', '16', '16½', '17', '17½', '18'], inStockSizes: const ['15½', '17', '17½', '18'], colors: [_c('#D8C7A8')], imgLabel: 'PRODUCT PHOTO - Beige Stripe Classic Fit  Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/FS2885-2RF.jpg?v=1769848466', productUrl: 'https://uniworthshop.com/products/beige-stripe-classic-fit-shirt-fs2885-2rf'),
  Product(id: 'p53', title: 'White Printed Classic Fit Shirt', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 4,796', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['14½', '15', '15½', '16', '16½', '17', '17½', '18'], inStockSizes: const ['15½', '16', '17', '17½'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - White Printed Classic Fit Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/FS838RH..jpg?v=1769847662', productUrl: 'https://uniworthshop.com/products/white-printed-classic-fit-shirt-fs838rh'),
  Product(id: 'p54', title: 'Lemon Plain Tailored Smart Fit Shirt', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 4,995', oldPrice: '', category: 'Kurta', occasion: 'Formal', sizes: const ['14½', '15', '15½', '16', '16½', '17', '17½', '18'], inStockSizes: const ['14½', '15', '15½', '16'], colors: [_c('#D9DF88'), _c('#AFB359'), _c('#959B33')], imgLabel: 'PRODUCT PHOTO - Lemon Plain Tailored Smart Fit Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/FS1332-1SF.jpg?v=1769846939', productUrl: 'https://uniworthshop.com/products/plain-lemon-tailored-smart-fit-shirt-fs1332-1sf'),
  Product(id: 'p55', title: 'Turquoise Self Cufflink Tie Set', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 3,995', oldPrice: '', category: 'Pret', occasion: 'Wedding', sizes: const ['F.S'], inStockSizes: const ['F.S'], colors: [_c('#93E0CE'), _c('#70CFB7'), _c('#62AA97')], imgLabel: 'PRODUCT PHOTO - Turquoise Self Cufflink Tie Set', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/e267dccc6ee55d52704bc46226a71403.jpg?v=1769850780', productUrl: 'https://uniworthshop.com/products/turquoise-self-cufflink-tie-set-gsct25127'),
  Product(id: 'p56', title: 'Red Paisley Tie', brand: 'Uniworth', brandId: 'uniworth', emerging: false, price: 'Rs. 2,395', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['F.S'], inStockSizes: const ['F.S'], colors: [_c('#9F1733')], imgLabel: 'PRODUCT PHOTO - Red Paisley Tie', imageUrl: 'https://cdn.shopify.com/s/files/1/0689/7978/5818/files/TIE24227.jpg?v=1769851483', productUrl: 'https://uniworthshop.com/products/red-paisley-tie-tie24227'),
  Product(id: 'p57', title: 'Women "ACORN" Luxury Shoulder Bags', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 7,599', oldPrice: '', category: 'Accessories', occasion: 'Everyday', sizes: const ['One Size'], inStockSizes: const ['One Size'], colors: [_c('#C8B29B'), _c('#E7D9CC'), _c('#AB8E71')], imgLabel: 'PRODUCT PHOTO - Women "ACORN" Luxury Shoulder Bags', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/bg9233_c3681eac-3362-4eaf-ada6-217e50f8de66.jpg?v=1778149009', productUrl: 'https://unze.com.pk/products/women-acorn-luxury-shoulder-bags-1'),
  Product(id: 'p58', title: 'Men "WAYLO" Lace Up Leather Formal Shoes', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 19,599', oldPrice: '', category: 'Pret', occasion: 'Formal', sizes: const ['UK 6 - US 7 - EU 40', 'UK 7 - US 8 - EU 41', 'UK 8 - US 9 - EU 42', 'UK 9 - US 10 - EU 43', 'UK 10 - US 11 - EU 44', 'UK 11 - US 12 - EU 45', 'UK 12 - US 13 - EU 46'], inStockSizes: const ['UK 6 - US 7 - EU 40', 'UK 7 - US 8 - EU 41', 'UK 8 - US 9 - EU 42', 'UK 9 - US 10 - EU 43', 'UK 10 - US 11 - EU 44', 'UK 11 - US 12 - EU 45'], colors: [_c('#EBEBEB'), _c('#242424'), _c('#525251')], imgLabel: 'PRODUCT PHOTO - Men "WAYLO" Lace Up Leather Formal Shoes', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/gs9967a_2142c8b7-81f7-400e-80d1-1a256c98a7f5.jpg?v=1779541215', productUrl: 'https://unze.com.pk/products/men-waylo-lace-up-leather-formal-shoes'),
  Product(id: 'p59', title: 'Women "FRANCO" Fancy Formal Heel Sandals', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 8,049', oldPrice: '', category: 'Pret', occasion: 'Formal', sizes: const ['UK 3 - US 5 - EU 36', 'UK 4 - US 6 - EU 37', 'UK 5 - US 7 - EU 38', 'UK 6 - US 8 - EU 39', 'UK 7 - US 9 - EU 40', 'UK 8 - US 10 - EU 41'], inStockSizes: const ['UK 3 - US 5 - EU 36', 'UK 4 - US 6 - EU 37', 'UK 5 - US 7 - EU 38', 'UK 6 - US 8 - EU 39', 'UK 7 - US 9 - EU 40', 'UK 8 - US 10 - EU 41'], colors: [_c('#E3DDD6'), _c('#CAAB99'), _c('#A88773')], imgLabel: 'PRODUCT PHOTO - Women "FRANCO" Fancy Formal Heel Sandals', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/l42678_388d40f2-9194-4cfe-9cb0-a60c158bc2f3.jpg?v=1783601841', productUrl: 'https://unze.com.pk/products/women-franco-fancy-formal-heel-sandals-2'),
  Product(id: 'p60', title: 'Women "BNTINA" Stable Low Heel Sandals', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 4,750', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['UK 3 - US 5 - EU 36', 'UK 4 - US 6 - EU 37', 'UK 5 - US 7 - EU 38', 'UK 6 - US 8 - EU 39', 'UK 7 - US 9 - EU 40', 'UK 8 - US 10 - EU 41'], inStockSizes: const ['UK 3 - US 5 - EU 36', 'UK 4 - US 6 - EU 37', 'UK 5 - US 7 - EU 38', 'UK 6 - US 8 - EU 39', 'UK 7 - US 9 - EU 40', 'UK 8 - US 10 - EU 41'], colors: [_c('#1D1A15'), _c('#908B83'), _c('#562B16')], imgLabel: 'PRODUCT PHOTO - Women "BNTINA" Stable Low Heel Sandals', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/l42871_408c3078-8147-4efb-b4cb-0f79ab94b25e.jpg?v=1773030749', productUrl: 'https://unze.com.pk/products/women-bntina-stable-low-heel-sandals'),
  Product(id: 'p61', title: '"SALVAD"Solid Regular Fit Polo Shirt', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 2,200', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['2 Y', '3 Y', '4 Y', '5-6 Y', '7-8 Y', '9-10 Y', '11-12Y', '13-14Y'], inStockSizes: const ['5-6 Y', '7-8 Y', '9-10 Y', '11-12Y'], colors: [_c('#E1D7C5'), _c('#CEB59B'), _c('#A7916F')], imgLabel: 'PRODUCT PHOTO - "SALVAD"Solid Regular Fit Polo Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/kc791.jpg?v=1771603944', productUrl: 'https://unze.com.pk/products/salvadsolid-regular-fit-polo-shirt-2'),
  Product(id: 'p62', title: '"HOSEA" Wide Leg Denim Pant', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 3,000', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['26', '28', '30', '32', '34'], inStockSizes: const ['26', '28', '30', '32', '34'], colors: [_c('#4A6079')], imgLabel: 'PRODUCT PHOTO - "HOSEA" Wide Leg Denim Pant', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/wc676.jpg?v=1770268208', productUrl: 'https://unze.com.pk/products/hosea-wide-leg-denim-pant-4'),
  Product(id: 'p63', title: '"KRISHIV" Basic Drop Shoulder T-Shirt', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 1,050', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['2 Y', '3 Y', '4 Y', '5-6 Y', '7-8 Y', '9-10 Y', '11-12Y', '13-14Y'], inStockSizes: const ['5-6 Y', '7-8 Y', '9-10 Y', '11-12Y'], colors: [_c('#CCB59B'), _c('#DFE3E1'), _c('#625F58')], imgLabel: 'PRODUCT PHOTO - "KRISHIV" Basic Drop Shoulder T-Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/kc698_b2193412-088c-426a-856c-ac8218ac3196.jpg?v=1773741069', productUrl: 'https://unze.com.pk/products/krishiv-basic-drop-shoulder-t-shirt'),
  Product(id: 'p64', title: 'Men "FLOYD" Premium Leather Lace Up Formal Shoes', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 20,000', oldPrice: '', category: 'Pret', occasion: 'Formal', sizes: const ['UK 6 - US 7 - EU 40', 'UK 7 - US 8 - EU 41', 'UK 8 - US 9 - EU 42', 'UK 9 - US 10 - EU 43', 'UK 10 - US 11 - EU 44', 'UK 11 - US 12 - EU 45', 'UK 12 - US 13 - EU 46'], inStockSizes: const ['UK 9 - US 10 - EU 43', 'UK 10 - US 11 - EU 44'], colors: [_c('#EBEBEB'), _c('#565657'), _c('#313130')], imgLabel: 'PRODUCT PHOTO - Men "FLOYD" Premium Leather Lace Up Form', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/gs9854a_c09a929e-761d-4b34-a9d5-625d99cfd023.jpg?v=1770647278', productUrl: 'https://unze.com.pk/products/men-floyd-leather-lace-up-formal-shoes'),
  Product(id: 'p65', title: '"EZRIA" Trendy Casual Denim Cargo Pant', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 1,800', oldPrice: '', category: 'Bottoms', occasion: 'Casual', sizes: const ['2 Y', '3 Y', '4 Y', '5-6 Y', '7-8 Y', '9-10 Y', '11-12Y', '13-14Y'], inStockSizes: const ['5-6 Y', '7-8 Y', '9-10 Y', '11-12Y'], colors: [_c('#4A6079')], imgLabel: 'PRODUCT PHOTO - "EZRIA" Trendy Casual Denim Cargo Pant', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/gc309.jpg?v=1760508021', productUrl: 'https://unze.com.pk/products/ezria-trendy-casual-denim-cargo-pant-3'),
  Product(id: 'p66', title: 'Women "DEVON" Easy to Carry Tote Bag', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 8,399', oldPrice: '', category: 'Accessories', occasion: 'Casual', sizes: const ['One Size'], inStockSizes: const ['One Size'], colors: [_c('#A58C73'), _c('#AA5735'), _c('#976E56')], imgLabel: 'PRODUCT PHOTO - Women "DEVON" Easy to Carry Tote Bag', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/bg9329_d624f672-52af-4c13-b168-eb8450a7340b.jpg?v=1763452190', productUrl: 'https://unze.com.pk/products/women-devon-easy-to-carry-tote-bag-2'),
  Product(id: 'p67', title: '"FLURIN" Comfort Regular Fit T-Shirt', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 1,995', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#CDCFCE'), _c('#A6876F'), _c('#B1A8A1')], imgLabel: 'PRODUCT PHOTO - "FLURIN" Comfort Regular Fit T-Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/mc2353.jpg?v=1757079059', productUrl: 'https://unze.com.pk/products/flurin-comfort-regular-fit-t-shirt-2'),
  Product(id: 'p68', title: '"ALKAS" Casual  Straight Fit Chino', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 2,240', oldPrice: '', category: 'Shalwar Kameez', occasion: 'Casual', sizes: const ['28', '30', '32', '34', '36', '38'], inStockSizes: const ['30', '32', '34', '36', '38'], colors: [_c('#D5D5D0'), _c('#5A5958'), _c('#9A6653')], imgLabel: 'PRODUCT PHOTO - "ALKAS" Casual  Straight Fit Chino', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/mc2410_0215ebd5-6365-4ce7-b5a1-84483e229c6c.jpg?v=1748863881', productUrl: 'https://unze.com.pk/products/alkas-casual-straight-fit-chino-1'),
  Product(id: 'p69', title: '"GIONA" Comfort Regular Fit T-Shirt', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 1,000', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#D7E0E5'), _c('#4971A2'), _c('#9A6A5B')], imgLabel: 'PRODUCT PHOTO - "GIONA" Comfort Regular Fit T-Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/mc2253.jpg?v=1747824944', productUrl: 'https://unze.com.pk/products/giona-comfort-regular-fit-t-shirt-2'),
  Product(id: 'p70', title: 'Women\'s "EILEEN" Casual Flat Slippers', brand: 'Unze London', brandId: 'unze_london', emerging: false, price: 'Rs. 3,999', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['UK 3 - US 5 - EU 36', 'UK 4 - US 6 - EU 37', 'UK 5 - US 7 - EU 38', 'UK 6 - US 8 - EU 39', 'UK 7 - US 9 - EU 40', 'UK 8 - US 10 - EU 41'], inStockSizes: const ['UK 3 - US 5 - EU 36', 'UK 4 - US 6 - EU 37', 'UK 5 - US 7 - EU 38', 'UK 6 - US 8 - EU 39', 'UK 8 - US 10 - EU 41'], colors: [_c('#AEA9A2'), _c('#D1C4BC'), _c('#988777')], imgLabel: 'PRODUCT PHOTO - Women\'s "EILEEN" Casual Flat Slippers', imageUrl: 'https://cdn.shopify.com/s/files/1/0523/9875/1922/files/l41454_3f811b29-a801-4acb-a9cc-fc3ef6fb7c24.jpg?v=1741190433', productUrl: 'https://unze.com.pk/products/womens-eileen-casual-flat-slippers-1'),
  Product(id: 'p71', title: 'Girls Jogger Trouser', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 1,500', oldPrice: '', category: 'Bottoms', occasion: 'Everyday', sizes: const ['2 Y', '3 Y', '4 Y', '5-6 Y'], inStockSizes: const ['2 Y', '3 Y', '4 Y', '5-6 Y'], colors: [_c('#5B7355')], imgLabel: 'PRODUCT PHOTO - Girls Jogger Trouser', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/g3_c3a3df9a-8d07-4016-82a8-e7c5e32a1595.jpg?v=1789016692', productUrl: 'https://engine.com.pk/products/vtu105-lgr'),
  Product(id: 'p72', title: 'Men Basic Straight Trouser', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 5,499', oldPrice: '', category: 'Bottoms', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Men Basic Straight Trouser', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/1E6A5392.jpg?v=1787574530', productUrl: 'https://engine.com.pk/products/mu6048-bk1'),
  Product(id: 'p73', title: 'Men Regular Fit Casual Shirt', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 2,750', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Men Regular Fit Casual Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/J1_0045b6dd-6bd7-48b2-94e9-7ca7173e26ea.jpg?v=1786627961', productUrl: 'https://engine.com.pk/products/fc6021-blk'),
  Product(id: 'p74', title: 'Men Slim Fit Pant', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 3,000', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['S-30', 'S-32', 'S-34', 'S-36', 'S-38'], inStockSizes: const ['S-30', 'S-32'], colors: [_c('#22304A')], imgLabel: 'PRODUCT PHOTO - Men Slim Fit Pant', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/FP6014-NVY_1.jpg?v=1784695748', productUrl: 'https://engine.com.pk/products/fp6014-nvy'),
  Product(id: 'p75', title: 'Men T Shirt', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 1,250', oldPrice: '', category: 'Kurta', occasion: 'Festive', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'L'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Men T Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/1E6A5554.jpg?v=1783336577', productUrl: 'https://engine.com.pk/products/mt6132-blk'),
  Product(id: 'p76', title: 'Boys Cargo Trouser', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 1,250', oldPrice: '', category: 'Bottoms', occasion: 'Festive', sizes: const ['6-9 M', '9-12 M', '12-18 M', '18-24 M'], inStockSizes: const ['6-9 M', '9-12 M', '12-18 M', '18-24 M'], colors: [_c('#6B4A32')], imgLabel: 'PRODUCT PHOTO - Boys Cargo Trouser', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/IU6034-BRN_1.jpg?v=1782022602', productUrl: 'https://engine.com.pk/products/iu6034-brn'),
  Product(id: 'p77', title: 'Girls T Shirt', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 750', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['2 Y', '3 Y', '4 Y', '5-6 Y'], inStockSizes: const ['2 Y', '3 Y'], colors: [_c('#4A3B52')], imgLabel: 'PRODUCT PHOTO - Girls T Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/TT6090-PRP_1.jpg?v=1780979325', productUrl: 'https://engine.com.pk/products/tt6090-prp'),
  Product(id: 'p78', title: 'Men T Shirt', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 1,250', oldPrice: '', category: 'Kurta', occasion: 'Festive', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S'], colors: [_c('#AE9F96'), _c('#282627'), _c('#645853')], imgLabel: 'PRODUCT PHOTO - Men T Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/MT-6104-DGY_2__JPG.jpg?v=1778667899', productUrl: 'https://engine.com.pk/products/mt6104-dne'),
  Product(id: 'p79', title: 'Boys T Shirt', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 600', oldPrice: '', category: 'Kurta', occasion: 'Festive', sizes: const ['7-8 Y', '9-10 Y', '11-12 Y', '13-14 Y'], inStockSizes: const ['9-10 Y'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - Boys T Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/VKT415-WHT_1.jpg?v=1776747085', productUrl: 'https://engine.com.pk/products/vkt415-wht'),
  Product(id: 'p80', title: 'Women Plain Dress', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 3,000', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Women Plain Dress', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/1E6A0905_b38c517e-4f14-4afa-ae33-1bbf378c1dde.jpg?v=1774861379', productUrl: 'https://engine.com.pk/products/lo6021-blk'),
  Product(id: 'p81', title: 'Girls Flared Trouser', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 750', oldPrice: '', category: 'Bottoms', occasion: 'Festive', sizes: const ['6-9 M', '9-12 M', '12-18 M', '18-24 M'], inStockSizes: const ['6-9 M'], colors: [_c('#D8C7A8')], imgLabel: 'PRODUCT PHOTO - Girls Flared Trouser', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/IU6006-BGE_1.jpg?v=1772520294', productUrl: 'https://engine.com.pk/products/iu6006-bge'),
  Product(id: 'p82', title: 'Boys Casual Shirt', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 1,200', oldPrice: '', category: 'Kurta', occasion: 'Festive', sizes: const ['7-8 Y', '9-10 Y', '11-12 Y', '13-14 Y'], inStockSizes: const ['7-8 Y', '9-10 Y', '11-12 Y', '13-14 Y'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Boys Casual Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/VTC058-LBL_1_6965edbf-4f6a-4922-b0ff-e90e227f4e03.jpg?v=1770104977', productUrl: 'https://engine.com.pk/products/vkc052-lbl'),
  Product(id: 'p83', title: 'Women Suit', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 5,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['XL'], colors: [_c('#6B4A32')], imgLabel: 'PRODUCT PHOTO - Women Suit', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/LE-5115-BRN_1.jpg?v=1766727438', productUrl: 'https://engine.com.pk/products/le5115-brn'),
  Product(id: 'p84', title: 'Men Button Down', brand: 'Engine', brandId: 'engine', emerging: false, price: 'Rs. 1,900', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#F3EDE3')], imgLabel: 'PRODUCT PHOTO - Men Button Down', imageUrl: 'https://cdn.shopify.com/s/files/1/0553/3774/6621/files/MT5189-OWT_5.jpg?v=1761803471', productUrl: 'https://engine.com.pk/products/mt5189-owt'),
  Product(id: 'p85', title: 'Behraan Top', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 3,450', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XL'], colors: [_c('#95AAA5'), _c('#709596'), _c('#231A14')], imgLabel: 'PRODUCT PHOTO - Behraan Top', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/products/W.SS22.298.T-1_9e8d8a27-c686-474c-b610-b0be5361b870.jpg?v=1736338575', productUrl: 'https://www.lulusar.com/products/behraan-top'),
  Product(id: 'p86', title: 'Suraat Top & Jacket', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 5,500', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['M'], colors: [_c('#FAE7F4'), _c('#98A7AB'), _c('#D3ADA8')], imgLabel: 'PRODUCT PHOTO - Suraat Top & Jacket', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/products/W.SS20.604.T-1.jpg?v=1736337869', productUrl: 'https://www.lulusar.com/products/suraat-top-jacket'),
  Product(id: 'p87', title: 'Birzum Tunic', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 2,550', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS'], colors: [_c('#AFA594'), _c('#E7E3DB'), _c('#998965')], imgLabel: 'PRODUCT PHOTO - Birzum Tunic', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/products/W.FW22.235.T-1.jpg?v=1736337101', productUrl: 'https://www.lulusar.com/products/birzum-tunic'),
  Product(id: 'p88', title: 'Oversized White Tunic', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 2,070', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - Oversized White Tunic', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.SS23.328.T-1.jpg?v=1736336141', productUrl: 'https://www.lulusar.com/products/oversized-white-tunic'),
  Product(id: 'p89', title: 'Mulaan Pants', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 1,500', oldPrice: '', category: 'Bottoms', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S'], colors: [_c('#E5DFD1'), _c('#9A2A48'), _c('#6A1B27')], imgLabel: 'PRODUCT PHOTO - Mulaan Pants', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.FW23.384.P-1.jpg?v=1736335539', productUrl: 'https://www.lulusar.com/products/mulaan-pants'),
  Product(id: 'p90', title: 'Sargalik Pants', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 4,000', oldPrice: '', category: 'Bottoms', occasion: 'Eid', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS'], colors: [_c('#ECE7D9'), _c('#D5CBB6'), _c('#6F614F')], imgLabel: 'PRODUCT PHOTO - Sargalik Pants', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.SS24.030.P-1.jpg?v=1736335216', productUrl: 'https://www.lulusar.com/products/sargalik-pants'),
  Product(id: 'p91', title: 'Berzin Pants', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 1,950', oldPrice: '', category: 'Bottoms', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S'], colors: [_c('#E1D5C8'), _c('#CBAE9A'), _c('#B59278')], imgLabel: 'PRODUCT PHOTO - Berzin Pants', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.SS24.618.P-1.jpg?v=1736334698', productUrl: 'https://www.lulusar.com/products/berzin-pants'),
  Product(id: 'p92', title: 'Palsa Stole', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 4,000', oldPrice: '', category: 'Dupatta', occasion: 'Formal', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#632B30'), _c('#F1D099'), _c('#8B5B60')], imgLabel: 'PRODUCT PHOTO - Palsa Stole', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.FW24.271.T-1.jpg?v=1736334283', productUrl: 'https://www.lulusar.com/products/palsa-stole'),
  Product(id: 'p93', title: 'Soral Top', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 2,100', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'XL'], colors: [_c('#D9D4CC'), _c('#ADA497'), _c('#605B55')], imgLabel: 'PRODUCT PHOTO - Soral Top', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.SS25.405.T-1.jpg?v=1744351827', productUrl: 'https://www.lulusar.com/products/soral-top'),
  Product(id: 'p94', title: 'Mocha Tunic', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 4,000', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'XL'], colors: [_c('#DCD8CC'), _c('#B3A68F'), _c('#9F9074')], imgLabel: 'PRODUCT PHOTO - Mocha Tunic', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.SS25.650.T-1.jpg?v=1753424338', productUrl: 'https://www.lulusar.com/products/mocha-tunic'),
  Product(id: 'p95', title: 'Paldo Dupatta', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 2,500', oldPrice: '', category: 'Dupatta', occasion: 'Everyday', sizes: const ['One Size'], inStockSizes: const ['One Size'], colors: [_c('#CC5F2E'), _c('#A7704E'), _c('#779C93')], imgLabel: 'PRODUCT PHOTO - Paldo Dupatta', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.FW25.085.T-1.jpg?v=1759473056', productUrl: 'https://www.lulusar.com/products/paldo-dupatta'),
  Product(id: 'p96', title: 'Daraal Jacket', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 4,500', oldPrice: '', category: 'Pret', occasion: 'Formal', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL'], colors: [_c('#E5E1D8'), _c('#230E11'), _c('#52252E')], imgLabel: 'PRODUCT PHOTO - Daraal Jacket', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.FW26.021.T-1.jpg?v=1767335900', productUrl: 'https://www.lulusar.com/products/daraal-jacket'),
  Product(id: 'p97', title: 'Morak Pants', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 4,000', oldPrice: '', category: 'Bottoms', occasion: 'Eid', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL'], colors: [_c('#D7D6D2'), _c('#511B28'), _c('#B3AAA3')], imgLabel: 'PRODUCT PHOTO - Morak Pants', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.SS26.174.P-1.jpg?v=1777023539', productUrl: 'https://www.lulusar.com/products/morak-pants'),
  Product(id: 'p98', title: 'Soft Drape Top', brand: 'Lulusar', brandId: 'lulusar', emerging: true, price: 'Rs. 2,750', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL'], colors: [_c('#CCC5BA'), _c('#B4ACA0'), _c('#A08976')], imgLabel: 'PRODUCT PHOTO - Soft Drape Top', imageUrl: 'https://cdn.shopify.com/s/files/1/0611/8585/1568/files/W.SS26.737.T-1.jpg?v=1785483360', productUrl: 'https://www.lulusar.com/products/soft-drape-top'),
  Product(id: 'p99', title: 'MF-06 (shirt)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 7,450', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'L'], colors: [_c('#AC9D91'), _c('#8F705D'), _c('#231B12')], imgLabel: 'PRODUCT PHOTO - MF-06 (shirt)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/gbbb_81de9a24-a140-40c0-8c81-4deeafe8ca4f.jpg?v=1764150001', productUrl: 'https://vanya.pk/products/mf-06-shirt'),
  Product(id: 'p100', title: 'MZ-13 (Wrap)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 5,450', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M'], colors: [_c('#1E241C'), _c('#AA8E6D'), _c('#967250')], imgLabel: 'PRODUCT PHOTO - MZ-13 (Wrap)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/44_4d27d92b-3378-40ae-a9ca-d044dd660733.jpg?v=1764150167', productUrl: 'https://vanya.pk/products/mz-13-wrap'),
  Product(id: 'p101', title: 'FF-29 (shirt)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 3,577', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L'], colors: [_c('#A1675B'), _c('#980924'), _c('#CBAA94')], imgLabel: 'PRODUCT PHOTO - FF-29 (shirt)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/hfjkjg_e244d581-c966-4ed1-b99a-2208a8fbf27b.jpg?v=1764149752', productUrl: 'https://vanya.pk/products/ff-29-shirt'),
  Product(id: 'p102', title: 'FF-39 (Shirt)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 5,450', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L'], colors: [_c('#1D1004'), _c('#56300E'), _c('#6B501D')], imgLabel: 'PRODUCT PHOTO - FF-39 (Shirt)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/1_0009_MTB02750_1.jpg?v=1764582752', productUrl: 'https://vanya.pk/products/ff-39-shirt-1'),
  Product(id: 'p103', title: 'FR-07R (Shirt)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 5,450', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['M'], colors: [_c('#D1ADA7'), _c('#A69FAA'), _c('#ACB1D0')], imgLabel: 'PRODUCT PHOTO - FR-07R (Shirt)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/urf6_5043f244-4dc2-446c-bee5-a17f16224591.jpg?v=1764149776', productUrl: 'https://vanya.pk/products/fr-07-shirt'),
  Product(id: 'p104', title: 'DL-06 (Shirt)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 5,450', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#D7CFD1'), _c('#CCB2A2'), _c('#99705C')], imgLabel: 'PRODUCT PHOTO - DL-06 (Shirt)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/ehbe_0e88e420-cd5a-47a3-a82e-f755a80582f7.jpg?v=1764149910', productUrl: 'https://vanya.pk/products/dl-06-shirt'),
  Product(id: 'p105', title: 'WE-06 (Shirt)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 5,450', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['M', 'L'], colors: [_c('#1D1C1B'), _c('#D9B5A2'), _c('#8F6D5F')], imgLabel: 'PRODUCT PHOTO - WE-06 (Shirt)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/4a_7_3bb50aff-0d32-44e1-ae8e-e9a46fa60b36.jpg?v=1764150209', productUrl: 'https://vanya.pk/products/we-06-shirt'),
  Product(id: 'p106', title: 'FF-34 (Shirt)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 7,450', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'L', 'XL'], colors: [_c('#8E6759'), _c('#D8E0E0'), _c('#ADCBD2')], imgLabel: 'PRODUCT PHOTO - FF-34 (Shirt)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/kmhjl_jhu_d34ec3af-9558-4adb-a836-19c01629b8bd.jpg?v=1764149746', productUrl: 'https://vanya.pk/products/ff-34-shirt'),
  Product(id: 'p107', title: 'VD-13 (Shirt)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 5,450', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S'], colors: [_c('#AC032F'), _c('#E7E1DA'), _c('#CCA897')], imgLabel: 'PRODUCT PHOTO - VD-13 (Shirt)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/VD-13_5cd4b4e8-1caa-4f2d-a2ff-4b2e087a992f.jpg?v=1764149800', productUrl: 'https://vanya.pk/products/vd-13-shirt'),
  Product(id: 'p108', title: 'FR-02 (Shirt)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 3,950', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'XL'], colors: [_c('#D6B2A7'), _c('#CA9E5E'), _c('#621A14')], imgLabel: 'PRODUCT PHOTO - FR-02 (Shirt)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/yhduyhu_351821f8-8469-4c52-ba28-f37f6bca3da0.jpg?v=1764149782', productUrl: 'https://vanya.pk/products/fr-02-shirt'),
  Product(id: 'p109', title: 'RE-13 (Shirt+Trouser)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 8,450', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['M', 'L'], colors: [_c('#D2AF9C'), _c('#E6DBCF'), _c('#AD8D74')], imgLabel: 'PRODUCT PHOTO - RE-13 (Shirt+Trouser)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/9_e1f56984-1df9-4af6-aa64-4e2e9da468a8.jpg?v=1764150780', productUrl: 'https://vanya.pk/products/re-13-1-2pc'),
  Product(id: 'p110', title: 'SN-06 (Shirt+trouser )', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 8,450', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS'], colors: [_c('#EADACE'), _c('#25141F'), _c('#CEAB8F')], imgLabel: 'PRODUCT PHOTO - SN-06 (Shirt+trouser )', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/1_ce8a4399-aa1b-4450-83b6-c080e5100aa9.jpg?v=1764150611', productUrl: 'https://vanya.pk/products/sn-06-1-2pc'),
  Product(id: 'p111', title: 'WB-22 (Shirt)', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 4,650', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'L'], colors: [_c('#D19A73'), _c('#9E6065'), _c('#6E3053')], imgLabel: 'PRODUCT PHOTO - WB-22 (Shirt)', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/hdxhhd_d5a4b0b5-e558-4c31-9c0c-a77eda72512d.jpg?v=1764149855', productUrl: 'https://vanya.pk/products/wb-22-shirt'),
  Product(id: 'p112', title: 'SM-17 (Shirt+Trouser )', brand: 'Vanya', brandId: 'vanya', emerging: true, price: 'Rs. 8,450', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M'], colors: [_c('#E2C8BA'), _c('#685C57'), _c('#A89691')], imgLabel: 'PRODUCT PHOTO - SM-17 (Shirt+Trouser )', imageUrl: 'https://cdn.shopify.com/s/files/1/0019/7217/4947/files/1_0068_1C0A6046_1a207690-1da3-42f4-9cac-58a4a2ec9a06.jpg?v=1764150566', productUrl: 'https://vanya.pk/products/sm-17-1-2pc'),
  Product(id: 'p113', title: 'Queen\'s Promise', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 16,450', oldPrice: 'Rs. 22,950', category: 'Unstitched', occasion: 'Festive', sizes: const ['Unstitched', 'XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['Unstitched', 'S', 'M', 'L'], colors: [_c('#D8C7A8')], imgLabel: 'PRODUCT PHOTO - Queen\'s Promise', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/Queen_sPromise_1.jpg?v=1788459926', productUrl: 'https://mushq.com/products/queens-promise'),
  Product(id: 'p114', title: 'Carmine Jewel', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 16,450', oldPrice: 'Rs. 22,950', category: 'Unstitched', occasion: 'Festive', sizes: const ['Unstitched', 'XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Carmine Jewel', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/CarmineJewel_1.jpg?v=1788460648', productUrl: 'https://mushq.com/products/carmine-jewel'),
  Product(id: 'p115', title: 'Rouge Sapphire', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 16,450', oldPrice: 'Rs. 22,950', category: 'Unstitched', occasion: 'Festive', sizes: const ['Unstitched', 'XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['Unstitched', 'S', 'M', 'L'], colors: [_c('#2F6E6A')], imgLabel: 'PRODUCT PHOTO - Rouge Sapphire', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/RougeSapphire_1.jpg?v=1788461384', productUrl: 'https://mushq.com/products/rouge-sapphire'),
  Product(id: 'p116', title: 'Scene Stealer', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 10,950', oldPrice: 'Rs. 17,450', category: 'Unstitched', occasion: 'Festive', sizes: const ['Unstitched', 'S', 'M', 'L'], inStockSizes: const ['Unstitched', 'M', 'L'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Scene Stealer', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/1_b1f63e99-f518-44f5-97a8-4a4c46e859cc.jpg?v=1788365101', productUrl: 'https://mushq.com/products/scene-stealer'),
  Product(id: 'p117', title: 'Effortlessly Me', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 10,950', oldPrice: 'Rs. 17,450', category: 'Unstitched', occasion: 'Festive', sizes: const ['Unstitched', 'S', 'M', 'L'], inStockSizes: const ['Unstitched', 'S', 'M', 'L'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Effortlessly Me', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/1_b08d3665-8623-42b8-86a0-22e4d5e230aa.jpg?v=1788364634', productUrl: 'https://mushq.com/products/effortlessly-me'),
  Product(id: 'p118', title: 'Solare', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 10,470', oldPrice: 'Rs. 15,270', category: 'Unstitched', occasion: 'Everyday', sizes: const ['Unstitched', 'XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS'], colors: [_c('#D8C7A8')], imgLabel: 'PRODUCT PHOTO - Solare', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/Solare_1.jpg?v=1760430989', productUrl: 'https://mushq.com/products/solare'),
  Product(id: 'p119', title: 'Verona', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 36,950', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Verona', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/Verona_2.jpg?v=1786704204', productUrl: 'https://mushq.com/products/verona'),
  Product(id: 'p120', title: 'Whispering Ivy', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 11,950', oldPrice: 'Rs. 18,450', category: 'Unstitched', occasion: 'Casual', sizes: const ['Unstitched', 'S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#6B6B3D')], imgLabel: 'PRODUCT PHOTO - Whispering Ivy', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/WhisperingIvy_1.jpg?v=1783160196', productUrl: 'https://mushq.com/products/whispering-ivy'),
  Product(id: 'p121', title: 'Ethereal Eden', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 11,950', oldPrice: 'Rs. 18,450', category: 'Unstitched', occasion: 'Casual', sizes: const ['Unstitched', 'S', 'M', 'L'], inStockSizes: const ['M', 'L'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Ethereal Eden', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/EtherealEden_2.jpg?v=1783159530', productUrl: 'https://mushq.com/products/ethereal-eden'),
  Product(id: 'p122', title: 'Out of Line', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 3,870', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'L'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Out of Line', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/OutofLine_1.jpg?v=1772097124', productUrl: 'https://mushq.com/products/out-of-line'),
  Product(id: 'p123', title: 'Cardamine', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 47,500', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#9CA399'), _c('#6E7163'), _c('#8A8879')], imgLabel: 'PRODUCT PHOTO - Cardamine', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/1_1000x_12f6cc9b-fc5d-4de4-9237-277887385909.webp?v=1787663306', productUrl: 'https://mushq.com/products/cardamine'),
  Product(id: 'p124', title: 'Rumsha', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 47,950', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M'], colors: [_c('#D8C7A8')], imgLabel: 'PRODUCT PHOTO - Rumsha', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/Rumsha_1.jpg?v=1767606066', productUrl: 'https://mushq.com/products/rumsha'),
  Product(id: 'p125', title: 'Calista', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 375,000', oldPrice: '', category: 'Pret', occasion: 'Wedding', sizes: const ['Custom Order'], inStockSizes: const ['Custom Order'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Calista', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/1_ca714b8b-6b0d-4533-8bc9-0d416e3b33df.webp?v=1764678197', productUrl: 'https://mushq.com/products/calista'),
  Product(id: 'p126', title: 'Evangeline', brand: 'Mushq', brandId: 'mushq', emerging: true, price: 'Rs. 425,000', oldPrice: '', category: 'Pret', occasion: 'Wedding', sizes: const ['Custom Order'], inStockSizes: const ['Custom Order'], colors: [_c('#9C7C8A')], imgLabel: 'PRODUCT PHOTO - Evangeline', imageUrl: 'https://cdn.shopify.com/s/files/1/0539/7318/8776/files/MBRIN240107C-1_1000x_3796fee5-6514-4ce5-aad6-a227ef278882.webp?v=1764679860', productUrl: 'https://mushq.com/products/evangeline'),
  Product(id: 'p127', title: 'BASIC PLAIN TIGHTS', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 1,995', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)', 'XXL (18)'], inStockSizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)', 'XXL (18)'], colors: [_c('#D8C7A8')], imgLabel: 'PRODUCT PHOTO - BASIC PLAIN TIGHTS', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/Wat2301_0001_DSCF7856A_c5d82117-5b5b-4ab4-b204-17af82ed093c.jpg?v=1787634535', productUrl: 'https://www.zeenwoman.com/products/basic-plain-tights-wat26-01-beige'),
  Product(id: 'p128', title: 'PRINTED VISCOSE CREPE STITCHED 2 PIECE SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 6,990', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)'], inStockSizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - PRINTED VISCOSE CREPE STITCHED 2 PIECE S', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/0008_WLM26336Front.jpg?v=1784527886', productUrl: 'https://www.zeenwoman.com/products/printed-viscose-crepe-stitched-2-piece-suit-wlm26336-blue'),
  Product(id: 'p129', title: 'PRINTED CAMBRIC STITCHED SHIRT BOTTOM SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 6,490', oldPrice: '', category: 'Pret', occasion: 'Casual', sizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)'], inStockSizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)'], colors: [_c('#E4A9BE')], imgLabel: 'PRODUCT PHOTO - PRINTED CAMBRIC STITCHED SHIRT BOTTOM SU', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/WLM26435.jpg?v=1783747196', productUrl: 'https://www.zeenwoman.com/products/printed-cambric-stitched-shirt-bottom-suit-wlm26435-light-pink'),
  Product(id: 'p130', title: 'PRINTED RAW SILK UNSTITCHED SHIRT BOTTOM SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 3,490', oldPrice: '', category: 'Unstitched', occasion: 'Casual', sizes: const ['One Size'], inStockSizes: const ['One Size'], colors: [_c('#D2D2D2'), _c('#B0A097'), _c('#8F7265')], imgLabel: 'PRODUCT PHOTO - PRINTED RAW SILK UNSTITCHED SHIRT BOTTOM', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/WEM2609.jpg_1.jpg?v=1785324714', productUrl: 'https://www.zeenwoman.com/products/printed-raw-silk-unstitched-shirt-bottom-suit-wem2609-multi'),
  Product(id: 'p131', title: 'EMBROIDERED CAMBRIC STITCHED 3 PIECE SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 10,490', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)'], inStockSizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - EMBROIDERED CAMBRIC STITCHED 3 PIECE SUI', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/Premium_stitched_3-piece_black_cambric_suit.webp?v=1781527739', productUrl: 'https://www.zeenwoman.com/products/printed-embroidered-cambric-stitched-3-piece-suit-wlm36468-black'),
  Product(id: 'p132', title: 'EMBROIDERED SLUB LAWN STITCHED 3 PIECE SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 10,490', oldPrice: '', category: 'Pret', occasion: 'Eid', sizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)'], inStockSizes: const ['L (14)', 'XL (16)'], colors: [_c('#F3EDE3')], imgLabel: 'PRODUCT PHOTO - EMBROIDERED SLUB LAWN STITCHED 3 PIECE S', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/WLM36286.jpg?v=1778223160', productUrl: 'https://www.zeenwoman.com/products/embroidered-slub-lawn-stitched-3-piece-suit-wlm36286-almondine'),
  Product(id: 'p133', title: 'EMBROIDERED CHIFFON STITCHED 3 PIECE SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 17,990', oldPrice: '', category: 'Pret', occasion: 'Eid', sizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)'], inStockSizes: const ['S (10)', 'M (12)', 'L (14)', 'XL (16)'], colors: [_c('#B8D8C7')], imgLabel: 'PRODUCT PHOTO - EMBROIDERED CHIFFON STITCHED 3 PIECE SUI', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/WZM35982.jpg?v=1776765184', productUrl: 'https://www.zeenwoman.com/products/embroidered-chiffon-stitched-3-piece-suit-wzm35982-mint-green'),
  Product(id: 'p134', title: 'DYED POPLIN CHIKANKARI STITCHED 2 PIECE SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 8,990', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)'], inStockSizes: const ['M (12)'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - DYED POPLIN CHIKANKARI STITCHED 2 PIECE', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/WLM25709.jpg?v=1775200883', productUrl: 'https://www.zeenwoman.com/products/dyed-poplin-chikankari-stitched-2-piece-suit-wlm25709-white'),
  Product(id: 'p135', title: 'PRINTED POLY CAMBRIC STITCHED 2 PIECE SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 5,490', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)'], inStockSizes: const ['S (10)', 'M (12)', 'L (14)', 'XL (16)'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - PRINTED POLY CAMBRIC STITCHED 2 PIECE SU', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/Casual_stitched_2-piece_blue_poly_cambric_suit.jpg?v=1781529725', productUrl: 'https://www.zeenwoman.com/products/printed-poly-cambric-stitched-2-piece-suit-wlm26300-blue'),
  Product(id: 'p136', title: 'EMBROIDERED TENCEL STITCHED 2 PIECE SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 7,490', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['8 (XS)', '10 (S)', '12 (M)', '14 (L)', '16 (XL)'], inStockSizes: const ['8 (XS)', '10 (S)', '12 (M)', '14 (L)', '16 (XL)'], colors: [_c('#5B7355')], imgLabel: 'PRODUCT PHOTO - EMBROIDERED TENCEL STITCHED 2 PIECE SUIT', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/WAM25812_06dccf5f-f48c-4442-88cc-b53d468c7c41.jpg?v=1772257940', productUrl: 'https://www.zeenwoman.com/products/embroidered-tencel-stitched-2-piece-suit-wam25812-pine-green'),
  Product(id: 'p137', title: 'EMBROIDERED CAMBRIC STITCHED 2 PIECE SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 7,290', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['8 (XS)', '10 (S)', '12 (M)', '14 (L)', '16 (XL)'], inStockSizes: const ['8 (XS)', '10 (S)', '12 (M)', '14 (L)', '16 (XL)'], colors: [_c('#F0C9A8')], imgLabel: 'PRODUCT PHOTO - EMBROIDERED CAMBRIC STITCHED 2 PIECE SUI', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/WLM26221.jpg?v=1771562349', productUrl: 'https://www.zeenwoman.com/products/embroidered-cambric-stitched-2-piece-suit-wlm26221-peach'),
  Product(id: 'p138', title: 'EMBROIDERED RAW SILK STITCHED 3 PIECE SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 16,990', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)'], inStockSizes: const ['XS (8)', 'S (10)', 'M (12)', 'L (14)', 'XL (16)'], colors: [_c('#2F6E6A')], imgLabel: 'PRODUCT PHOTO - EMBROIDERED RAW SILK STITCHED 3 PIECE SU', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/WZM35241_bb10344a-c82b-497c-ac96-0510ace14533.jpg?v=1775459293', productUrl: 'https://www.zeenwoman.com/products/stitched-embroidered-raw-silk-3-piece-suit-wzm35241-blue'),
  Product(id: 'p139', title: 'PRINTED CAMBRIC UNSTITCHED 3 PIECE SUIT', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 5,490', oldPrice: '', category: 'Unstitched', occasion: 'Casual', sizes: const ['One Size'], inStockSizes: const ['One Size'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - PRINTED CAMBRIC UNSTITCHED 3 PIECE SUIT', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/WFM35522-4.jpg?v=1774613293', productUrl: 'https://www.zeenwoman.com/products/unstitched-3-piece-suit-wfm35522-black'),
  Product(id: 'p140', title: 'DIGITAL PRINTED SCARF', brand: 'Zeen', brandId: 'zeen', emerging: true, price: 'Rs. 2,495', oldPrice: '', category: 'Dupatta', occasion: 'Everyday', sizes: const ['One Size'], inStockSizes: const ['One Size'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - DIGITAL PRINTED SCARF', imageUrl: 'https://cdn.shopify.com/s/files/1/0320/4405/6716/files/WPST5214.jpg?v=1763012372', productUrl: 'https://www.zeenwoman.com/products/digital-printed-scarf-wpst5214-black'),
  Product(id: 'p141', title: 'Aurelia (Three Piece)', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 620', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#9A7150'), _c('#563116'), _c('#724D31')], imgLabel: 'PRODUCT PHOTO - Aurelia (Three Piece)', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/files/8026578F-D935-4B11-931E-630DD44CB266.png?v=1784320642', productUrl: 'https://zaaviay.com/products/aurelia-three-piece'),
  Product(id: 'p142', title: 'Scarlet Nights (Three Piece)', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 350', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'Customized'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'Customized'], colors: [_c('#D4B095'), _c('#CB2518'), _c('#DA625A')], imgLabel: 'PRODUCT PHOTO - Scarlet Nights (Three Piece)', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/files/6C1A5B3A-600B-47C4-9BDB-28C4FD9D60D6.jpg?v=1770693984', productUrl: 'https://zaaviay.com/products/scarlet-nights'),
  Product(id: 'p143', title: 'Kala Doriya (Ready To Wear - Three Piece)', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 410', oldPrice: '', category: 'Pret', occasion: 'Wedding', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#9B6E53'), _c('#542F1A'), _c('#D59963')], imgLabel: 'PRODUCT PHOTO - Kala Doriya (Ready To Wear - Three Piece', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/products/02-min_8aedea07-c423-4989-9e26-a1f5ae03f0e7.jpg?v=1677574230', productUrl: 'https://zaaviay.com/products/kala-doriya-three-piece-1'),
  Product(id: 'p144', title: 'Aaru (Two Piece)', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 280', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#1C1A21'), _c('#9F9533'), _c('#64552F')], imgLabel: 'PRODUCT PHOTO - Aaru (Two Piece)', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/files/DSC01853.png?v=1684920399', productUrl: 'https://zaaviay.com/products/aaru-two-piece'),
  Product(id: 'p145', title: 'Vanya (Three Piece)', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 290', oldPrice: '', category: 'Kurta', occasion: 'Eid', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#621E24'), _c('#1F1F24'), _c('#8F2D32')], imgLabel: 'PRODUCT PHOTO - Vanya (Three Piece)', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/files/DSC03574-EDIT-2.jpg?v=1709815809', productUrl: 'https://zaaviay.com/products/vanya-three-piece'),
  Product(id: 'p146', title: 'Arooj (Three Piece)', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 300', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#4D271A'), _c('#976B5C'), _c('#665A55')], imgLabel: 'PRODUCT PHOTO - Arooj (Three Piece)', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/files/AROOJ.png?v=1697024473', productUrl: 'https://zaaviay.com/products/arooj-three-piece'),
  Product(id: 'p147', title: 'INSIYA (Three Piece)', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 290', oldPrice: '', category: 'Kurta', occasion: 'Eid', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#E5CAAF'), _c('#B1CBC9'), _c('#E9E1D3')], imgLabel: 'PRODUCT PHOTO - INSIYA (Three Piece)', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/files/DSC06397.png?v=1692615748', productUrl: 'https://zaaviay.com/products/insiya-three-piece'),
  Product(id: 'p148', title: 'Mimi (THREE PIECE)', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 250', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#CB2D39'), _c('#A1684E'), _c('#A82328')], imgLabel: 'PRODUCT PHOTO - Mimi (THREE PIECE)', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/products/Mimi_1.png?v=1677576285', productUrl: 'https://zaaviay.com/products/mimi-three-piece'),
  Product(id: 'p149', title: 'Enchanted', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 907', oldPrice: '', category: 'Pret', occasion: 'Wedding', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#A96653'), _c('#D7916D'), _c('#B1B1D9')], imgLabel: 'PRODUCT PHOTO - Enchanted', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/products/27edit.png?v=1677575608', productUrl: 'https://zaaviay.com/products/dress-7'),
  Product(id: 'p150', title: 'Ayleen', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 690', oldPrice: '', category: 'Pret', occasion: 'Wedding', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#E9E6D1'), _c('#D5CDB3'), _c('#AEAB95')], imgLabel: 'PRODUCT PHOTO - Ayleen', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/products/AYLEEN_4.png?v=1689845178', productUrl: 'https://zaaviay.com/products/ayleen'),
  Product(id: 'p151', title: 'Gal Mithi Mithi (Ready To Wear - Three Piece)', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 270', oldPrice: '', category: 'Pret', occasion: 'Formal', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#CF140A'), _c('#582915'), _c('#2A0F09')], imgLabel: 'PRODUCT PHOTO - Gal Mithi Mithi (Ready To Wear - Three P', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/products/01-min_ce5f938b-7f1f-4c4f-a1ae-e72ea6418a24.jpg?v=1677574347', productUrl: 'https://zaaviay.com/products/gal-mithi-mithi-three-piece'),
  Product(id: 'p152', title: 'Ghazal', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 1,500', oldPrice: '', category: 'Pret', occasion: 'Wedding', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#591915'), _c('#2B120F'), _c('#9E0E20')], imgLabel: 'PRODUCT PHOTO - Ghazal', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/products/04_60b115e0-5cb6-4dcc-9317-964c556a3657.jpg?v=1689845479', productUrl: 'https://zaaviay.com/products/ghazal-1'),
  Product(id: 'p153', title: 'Ranihaar (Three Piece)-Restocked', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 270', oldPrice: '', category: 'Pret', occasion: 'Formal', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#2A0D12'), _c('#521A22'), _c('#976152')], imgLabel: 'PRODUCT PHOTO - Ranihaar (Three Piece)-Restocked', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/products/04-min_e16840a2-6618-493d-9a8f-0f486c9f864c.jpg?v=1677572352', productUrl: 'https://zaaviay.com/products/ranihaar-three-piece'),
  Product(id: 'p154', title: 'Rizah (Three Piece)-Restocked', brand: 'Zaaviay', brandId: 'zaaviay', emerging: true, price: 'Rs. 290', oldPrice: '', category: 'Pret', occasion: 'Formal', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#201614'), _c('#591D16'), _c('#A95547')], imgLabel: 'PRODUCT PHOTO - Rizah (Three Piece)-Restocked', imageUrl: 'https://cdn.shopify.com/s/files/1/0726/7962/0911/products/04_80fccea6-d847-41a8-bffe-92a6ed672794.jpg?v=1677571463', productUrl: 'https://zaaviay.com/products/rizah-two-piece'),
  Product(id: 'p155', title: 'Additional Dupatta', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 25', oldPrice: '', category: 'Dupatta', occasion: 'Everyday', sizes: const ['One Size'], inStockSizes: const ['One Size'], colors: [_c('#DADDD6'), _c('#B1AC9A'), _c('#CAC7B6')], imgLabel: 'PRODUCT PHOTO - Additional Dupatta', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/files/46_Off_White.webp?v=1787314143', productUrl: 'https://suffuse.pk/products/additional-dupatta'),
  Product(id: 'p156', title: 'Anaira', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 1,748', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#CDCCC5'), _c('#6D8F94'), _c('#23251F')], imgLabel: 'PRODUCT PHOTO - Anaira', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/files/26Anaira.jpg?v=1752762885', productUrl: 'https://suffuse.pk/products/anaira'),
  Product(id: 'p157', title: 'SERENA', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 466', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL'], colors: [_c('#D2D6D0'), _c('#A9A49B'), _c('#696159')], imgLabel: 'PRODUCT PHOTO - SERENA', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/files/Outfit-10-_1.jpg?v=1710412262', productUrl: 'https://suffuse.pk/products/serena'),
  Product(id: 'p158', title: 'NOUSHA', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 1,980', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#ADA193'), _c('#9F8976'), _c('#E5E1DB')], imgLabel: 'PRODUCT PHOTO - NOUSHA', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/1_fb2dc2f6-3142-4396-900f-5c0b063e3d08.png?v=1646661018', productUrl: 'https://suffuse.pk/products/nousha'),
  Product(id: 'p159', title: 'IVORY BREEZE', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 190', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#F7EDDF')], imgLabel: 'PRODUCT PHOTO - IVORY BREEZE', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/1_3a6a2ddd-069b-4a63-9d0c-4ce5859ac611.png?v=1619268044', productUrl: 'https://suffuse.pk/products/ivory-breeze'),
  Product(id: 'p160', title: 'ROSE FLARE', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 216', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#C98F82')], imgLabel: 'PRODUCT PHOTO - ROSE FLARE', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/1_b9e20825-f9f6-4e55-be34-f99e5645ba36.png?v=1619266252', productUrl: 'https://suffuse.pk/products/rose-flare'),
  Product(id: 'p161', title: 'DUSTY TEAL', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 331', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#2F6E6A')], imgLabel: 'PRODUCT PHOTO - DUSTY TEAL', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/DSC00267.png?v=1605796987', productUrl: 'https://suffuse.pk/products/dusty-teal'),
  Product(id: 'p162', title: 'Fleur Mint', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 255', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#B8D8C7')], imgLabel: 'PRODUCT PHOTO - Fleur Mint', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/1Q0A9271.jpg?v=1605796019', productUrl: 'https://suffuse.pk/products/fleur-mint'),
  Product(id: 'p163', title: 'GARNET', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 226', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#A5A796'), _c('#DEDAD3'), _c('#CEC6B4')], imgLabel: 'PRODUCT PHOTO - GARNET', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/1Q0A7302.png?v=1605794543', productUrl: 'https://suffuse.pk/products/garnet'),
  Product(id: 'p164', title: 'SCARLET', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 1,865', oldPrice: 'Rs. 2,440', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#DDC7AE'), _c('#A1675A'), _c('#AE8C73')], imgLabel: 'PRODUCT PHOTO - SCARLET', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/IMG_0090.png?v=1605796423', productUrl: 'https://suffuse.pk/products/scarlet'),
  Product(id: 'p165', title: 'Fantasia', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 2,070', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#ABAB98'), _c('#DCDBD0'), _c('#9E8E77')], imgLabel: 'PRODUCT PHOTO - Fantasia', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/1Q0A8884.png?v=1605795424', productUrl: 'https://suffuse.pk/products/iris-pink'),
  Product(id: 'p166', title: 'LAYLA CHOLI', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 1,065', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#6F574B'), _c('#B0A892'), _c('#523232')], imgLabel: 'PRODUCT PHOTO - LAYLA CHOLI', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/727A5175.png?v=1605794824', productUrl: 'https://suffuse.pk/products/layla-choli'),
  Product(id: 'p167', title: 'POWDER PINK', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 1,015', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S/M', 'M/L'], inStockSizes: const ['S/M', 'M/L'], colors: [_c('#E4A9BE')], imgLabel: 'PRODUCT PHOTO - POWDER PINK', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/1Q0A5631.jpg?v=1605788484', productUrl: 'https://suffuse.pk/products/powder-pink'),
  Product(id: 'p168', title: 'SILVER KAFTAN', brand: 'Suffuse', brandId: 'suffuse', emerging: true, price: 'Rs. 1,812', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S/M', 'M/L'], inStockSizes: const ['S/M', 'M/L'], colors: [_c('#C4C0BA')], imgLabel: 'PRODUCT PHOTO - SILVER KAFTAN', imageUrl: 'https://cdn.shopify.com/s/files/1/1146/5868/products/Q0A4040.jpg?v=1605788089', productUrl: 'https://suffuse.pk/products/silver-kaftan'),
  Product(id: 'p169', title: 'KHUMAR RED - 30ml', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 2,400', oldPrice: '', category: 'Accessories', occasion: 'Everyday', sizes: const ['30ml'], inStockSizes: const ['30ml'], colors: [_c('#9F1733')], imgLabel: 'PRODUCT PHOTO - KHUMAR RED - 30ml', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/KhumarRed_1.jpg?v=1778485817', productUrl: 'https://www.junaidjamshed.com/products/khumar-red-30ml'),
  Product(id: 'p170', title: 'Purple Embroidered Liminal Unstitched 3Pc', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 7,490', oldPrice: '', category: 'Unstitched', occasion: 'Casual', sizes: const ['3 Piece'], inStockSizes: const ['3 Piece'], colors: [_c('#4A3B52')], imgLabel: 'PRODUCT PHOTO - Purple Embroidered Liminal Unstitched 3P', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/JLU-26-4323_3.jpg?v=1786354101', productUrl: 'https://www.junaidjamshed.com/products/purple-embroidered-liminal-unstitched-3pc-jlu264323u'),
  Product(id: 'p171', title: 'Black Antibacterial Trunk', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 1,490', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Black Antibacterial Trunk', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/Resized_1_328b4a7b-dfda-48c4-8c97-74d067c63f7c.jpg?v=1785234085', productUrl: 'https://www.junaidjamshed.com/products/black-antibacterial-trunk-jjuwabtrunka'),
  Product(id: 'p172', title: 'Plum Lawn Embroidered Kurta', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 5,490', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL'], colors: [_c('#E4DFDA'), _c('#5F1B2E'), _c('#330B14')], imgLabel: 'PRODUCT PHOTO - Plum Lawn Embroidered Kurta', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/JSS-26-693_7.jpg?v=1781521748', productUrl: 'https://www.junaidjamshed.com/products/plum-lawn-embroidered-kurta-jss26693s'),
  Product(id: 'p173', title: 'BLUE PLAIN WAISTCOAT', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 8,990', oldPrice: '', category: 'Waistcoat', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - BLUE PLAIN WAISTCOAT', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/48355jjvc_1.jpg?v=1782803227', productUrl: 'https://www.junaidjamshed.com/products/blue-plain-waistcoat-jjvca48355'),
  Product(id: 'p174', title: 'LIGHT GREEN LAWN PRINTED STITCHED 2PC', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 4,990', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['12 Y', '14 Y', '16 Y', '18 Y'], inStockSizes: const ['12 Y', '14 Y', '16 Y', '18 Y'], colors: [_c('#5B7355')], imgLabel: 'PRODUCT PHOTO - LIGHT GREEN LAWN PRINTED STITCHED 2PC', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/JTST-26-584_4.jpg?v=1778310210', productUrl: 'https://www.junaidjamshed.com/products/light-green-lawn-printed-stitched-2pc-jtst26584s'),
  Product(id: 'p175', title: 'BLACK PLAIN KURTA TROUSERS', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 7,190', oldPrice: '', category: 'Kurta', occasion: 'Festive', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - BLACK PLAIN KURTA TROUSERS', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/47506-1_1_7a7ffee6-5ee5-4f36-84da-435e6b5b259d.webp?v=1777371460', productUrl: 'https://www.junaidjamshed.com/products/black-plain-kurta-trousers-jjkpa47506r3ap'),
  Product(id: 'p176', title: 'BROWN COTTON PLAIN KAMEEZ SHALWAR', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 8,990', oldPrice: '', category: 'Shalwar Kameez', occasion: 'Casual', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#6B4A32')], imgLabel: 'PRODUCT PHOTO - BROWN COTTON PLAIN KAMEEZ SHALWAR', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/60125kskp_1.jpg?v=1777193398', productUrl: 'https://www.junaidjamshed.com/products/brown-cotton-plain-kameez-shalwar-jjksa60125'),
  Product(id: 'p177', title: 'MEHNDI COTTON CASUAL KURTA', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 4,290', oldPrice: 'Rs. 4,690', category: 'Kurta', occasion: 'Wedding', sizes: const ['2 Y', '4 Y', '6 Y', '8 Y', '10 Y'], inStockSizes: const ['2 Y', '4 Y', '6 Y', '8 Y', '10 Y'], colors: [_c('#EDEDEC'), _c('#5D4A37'), _c('#302821')], imgLabel: 'PRODUCT PHOTO - MEHNDI COTTON CASUAL KURTA', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/JCK-33919_1.jpg?v=1777308019', productUrl: 'https://www.junaidjamshed.com/products/mehndi-cotton-casual-kurta-jcka33919'),
  Product(id: 'p178', title: 'MAROON COTTON KAMEEZ SHALWAR | JJIKS-S-90439', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 1,533', oldPrice: 'Rs. 1,673', category: 'Shalwar Kameez', occasion: 'Everyday', sizes: const ['8 M', '12 M', '18 M'], inStockSizes: const ['8 M'], colors: [_c('#7A1F2B')], imgLabel: 'PRODUCT PHOTO - MAROON COTTON KAMEEZ SHALWAR | JJIKS-S-9', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/90439_1_8506e9a3-1f98-4553-9132-55af066aa3c5.jpg?v=1776978819', productUrl: 'https://www.junaidjamshed.com/products/maroon-cotton-kameez-shalwar-jjiks-s-90439'),
  Product(id: 'p179', title: 'MULTICOLOR LAWN PRINTED KURTA', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 1,490', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S'], colors: [_c('#A9565D'), _c('#A12A27'), _c('#654F34')], imgLabel: 'PRODUCT PHOTO - MULTICOLOR LAWN PRINTED KURTA', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/jss-25-312_2_1e868108-2133-4e70-b647-44f87583a370.jpg?v=1776976830', productUrl: 'https://www.junaidjamshed.com/products/multicolor-lawn-printed-kurti-jjlk-s-jss-25-312-fb-essential-12'),
  Product(id: 'p180', title: 'LIGHT PURPLE SEMI-FORMAL KAMEEZ SHALWAR', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 4,290', oldPrice: 'Rs. 4,690', category: 'Shalwar Kameez', occasion: 'Formal', sizes: const ['2 Y', '4 Y', '6 Y', '8 Y', '10 Y'], inStockSizes: const ['2 Y', '4 Y'], colors: [_c('#4A3B52')], imgLabel: 'PRODUCT PHOTO - LIGHT PURPLE SEMI-FORMAL KAMEEZ SHALWAR', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/39526jcks_1_f8463ff1-6f37-4066-b795-d8bdcf151602.jpg?v=1776975652', productUrl: 'https://www.junaidjamshed.com/products/light-purple-semi-formal-kameez-shalwar-jcksa39526'),
  Product(id: 'p181', title: 'MULTICOLOR BANGLES', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 1,350', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['2 Inches', '2.25 Inches', '2.5 Inches'], inStockSizes: const ['2 Inches'], colors: [_c('#ADA296'), _c('#C5B9AD'), _c('#69605A')], imgLabel: 'PRODUCT PHOTO - MULTICOLOR BANGLES', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/jjbn-26-030_2__5_cd4c86f6-9ca1-4760-9ca6-ab581b9e0674.jpg?v=1776975974', productUrl: 'https://www.junaidjamshed.com/products/multicolor-bangles-bn26035'),
  Product(id: 'p182', title: 'PINK PRINTED LAWN UNSTITCHED 2PC', brand: 'J. Junaid Jamshed', brandId: 'junaid_jamshed', emerging: false, price: 'Rs. 2,312', oldPrice: '', category: 'Unstitched', occasion: 'Casual', sizes: const ['2 Piece'], inStockSizes: const ['2 Piece'], colors: [_c('#E4A9BE')], imgLabel: 'PRODUCT PHOTO - PINK PRINTED LAWN UNSTITCHED 2PC', imageUrl: 'https://cdn.shopify.com/s/files/1/0702/2487/1584/files/jds-25-1131_1_2aaa5acb-761a-4525-af64-c1f4d9a415d7.jpg?v=1776975787', productUrl: 'https://www.junaidjamshed.com/products/pink-printed-lawn-unstitched-2pc-jds251131u'),
  Product(id: 'p183', title: 'Black Dyed Stylised 2PC', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 4,543', oldPrice: '', category: 'Pret', occasion: 'Wedding', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Black Dyed Stylised 2PC', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/WKL2231Black_1_c1a5a3ca-5285-40e7-aba3-ebc3bf0f1c9c.webp?v=1789033703', productUrl: 'https://diners.com.pk/products/wkl2231-2pc-black'),
  Product(id: 'p184', title: 'Embroidered Khaddar-Olive Teens 2PC', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 4,990', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['12Y', '14Y', '16Y', '18Y'], inStockSizes: const ['12Y', '16Y', '18Y'], colors: [_c('#6B6B3D')], imgLabel: 'PRODUCT PHOTO - Embroidered Khaddar-Olive Teens 2PC', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/WTK2058-OLIVE-01.webp?v=1788407318', productUrl: 'https://diners.com.pk/products/wtk2058-olive'),
  Product(id: 'p185', title: 'Stripes Formal Autograph Shirt', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 4,790', oldPrice: '', category: 'Kurta', occasion: 'Formal', sizes: const ['14.5', '15', '15.5', '16', '16.5', '17', '17.5', '18'], inStockSizes: const ['14.5', '15', '15.5', '16', '16.5', '17', '17.5', '18', '18.5'], colors: [_c('#939FB3'), _c('#CDD6DB'), _c('#1F1E19')], imgLabel: 'PRODUCT PHOTO - Stripes Formal Autograph Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/AH41722-Multi-01.webp?v=1787571611', productUrl: 'https://diners.com.pk/products/ah41722-multi'),
  Product(id: 'p186', title: 'Tights For Girls SKU: KGT-0085-PEACH', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 610', oldPrice: 'Rs. 660', category: 'Bottoms', occasion: 'Festive', sizes: const ['2Y', '3Y', '4Y', '5Y', '6Y', '7Y', '10Y', '11Y'], inStockSizes: const ['2Y'], colors: [_c('#F0C9A8')], imgLabel: 'PRODUCT PHOTO - Tights For Girls SKU: KGT-0085-PEACH', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/products/KGT-0085-Peach-RS-1190-01.jpg?v=1686088462', productUrl: 'https://diners.com.pk/products/tights-for-girls-sku-kgt-0085-peach'),
  Product(id: 'p187', title: 'Embroidered 2PC', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 4,893', oldPrice: '', category: 'Pret', occasion: 'Wedding', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL'], colors: [_c('#E6E2DB'), _c('#B6C6E6'), _c('#CFC4B9')], imgLabel: 'PRODUCT PHOTO - Embroidered 2PC', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/WKL2112-2PC_4.webp?v=1788405939', productUrl: 'https://diners.com.pk/products/wkl2112-2pc-lilac'),
  Product(id: 'p188', title: 'Premium Light Blue Wash & Wear Unstitched Fabric', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 5,690', oldPrice: '', category: 'Unstitched', occasion: 'Festive', sizes: const ['Unstitched'], inStockSizes: const ['Unstitched'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Premium Light Blue Wash & Wear Unstitche', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/SSE-010-L-Blue-05.webp?v=1781695629', productUrl: 'https://diners.com.pk/products/sse-010-l-blue'),
  Product(id: 'p189', title: 'Blue Check Formal Shirt (Half Sleeves)', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 2,990', oldPrice: '', category: 'Kurta', occasion: 'Formal', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Blue Check Formal Shirt (Half Sleeves)', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/AD41321-Blue-01.webp?v=1778938649', productUrl: 'https://diners.com.pk/products/ad41321-blue'),
  Product(id: 'p190', title: 'Printed Unstitched 3PC', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 2,790', oldPrice: '', category: 'Unstitched', occasion: 'Casual', sizes: const ['Unstitched'], inStockSizes: const ['Unstitched'], colors: [_c('#E5E0D7'), _c('#CFC5B9'), _c('#9B8875')], imgLabel: 'PRODUCT PHOTO - Printed Unstitched 3PC', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/WU32197_1.webp?v=1788406226', productUrl: 'https://diners.com.pk/products/wu32197-sea-green'),
  Product(id: 'p191', title: 'Dyed Shirt', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 1,995', oldPrice: '', category: 'Pret', occasion: 'Wedding', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#E4DFD9'), _c('#D8CDB7'), _c('#B0A89C')], imgLabel: 'PRODUCT PHOTO - Dyed Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/WKL1767-Ivory-01.webp?v=1788408438', productUrl: 'https://diners.com.pk/products/wkl1767-ivory'),
  Product(id: 'p192', title: 'Brown Cotton Shalwar Kameez', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 7,194', oldPrice: '', category: 'Shalwar Kameez', occasion: 'Wedding', sizes: const ['XS', 'S', 'M', 'L', 'XL'], inStockSizes: const ['XS', 'S', 'M', 'L'], colors: [_c('#6B4A32')], imgLabel: 'PRODUCT PHOTO - Brown Cotton Shalwar Kameez', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/EG3733-BROWN-02.webp?v=1770016615', productUrl: 'https://diners.com.pk/products/eg3733-brown'),
  Product(id: 'p193', title: 'Graphic Printed Boys Combos', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 2,795', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['2Years', '3Years', '4Years', '5Years'], inStockSizes: const ['2Years'], colors: [_c('#2D9EE3'), _c('#A6A09A'), _c('#212022')], imgLabel: 'PRODUCT PHOTO - Graphic Printed Boys Combos', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/products/KBJ-0033-BLUE-RS-5590-01.jpg?v=1686085741', productUrl: 'https://diners.com.pk/products/boys-combos-15'),
  Product(id: 'p194', title: 'Beige Smart Fit Jogger Pants', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 3,843', oldPrice: '', category: 'Bottoms', occasion: 'Wedding', sizes: const ['30', '32', '34', '36', '38'], inStockSizes: const ['32'], colors: [_c('#D8C7A8')], imgLabel: 'PRODUCT PHOTO - Beige Smart Fit Jogger Pants', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/BD3126-BEIDGE-01.webp?v=1760790904', productUrl: 'https://diners.com.pk/products/bd3126-beige'),
  Product(id: 'p195', title: 'Black Men\'s Belt', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 2,303', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['34', '36', '38', '40', '42', '44', '46'], inStockSizes: const ['40'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Black Men\'s Belt', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/IE76-Black-01.webp?v=1756986481', productUrl: 'https://diners.com.pk/products/ie76-black'),
  Product(id: 'p196', title: 'Royal Blue Teens Kurta Pajama', brand: 'Diners', brandId: 'diners', emerging: false, price: 'Rs. 3,594', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['12Y', '14Y', '16Y', '18Y'], inStockSizes: const ['14Y', '16Y', '18Y'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Royal Blue Teens Kurta Pajama', imageUrl: 'https://cdn.shopify.com/s/files/1/0752/0442/8072/files/DTKP32234-Royalblue-01.webp?v=1750920606', productUrl: 'https://diners.com.pk/products/dtkp-32234-royal-blue'),
  Product(id: 'p197', title: 'Embroidered Satin Suit - EWTKED6-86195-3P', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 12,000', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#F0C9A8')], imgLabel: 'PRODUCT PHOTO - Embroidered Satin Suit - EWTKED6-86195-3', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/86195-_1_thumbnail.jpg?v=1789016432', productUrl: 'https://edenrobe.com/products/embroidered-satin-suit-ewtked6-86195-3p'),
  Product(id: 'p198', title: 'Embroidered Viscose Waistcoat - EMTWCE6-36017', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 8,000', oldPrice: '', category: 'Waistcoat', occasion: 'Festive', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#5B7355')], imgLabel: 'PRODUCT PHOTO - Embroidered Viscose Waistcoat - EMTWCE6-', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/EMTWCE6-36017_12_34cb5be5-d743-47a6-8f0d-fb41fdcf0503.webp?v=1786510608', productUrl: 'https://edenrobe.com/products/mens-mint-green-waist-coat-emtwce6-36017'),
  Product(id: 'p199', title: 'Embroidered Cambric Co-Ord Set - EGTKED6-74036ST', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 8,000', oldPrice: '', category: 'Co-ord', occasion: 'Everyday', sizes: const ['02-3y', '04y', '05y', '06y', '07-8y', '09-10y', '11-12y', '13-14y'], inStockSizes: const ['02-3y', '04y', '05y', '06y', '07-8y', '09-10y', '11-12y', '13-14y'], colors: [_c('#D9B44A')], imgLabel: 'PRODUCT PHOTO - Embroidered Cambric Co-Ord Set - EGTKED6', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/EGTKED6-74036ST_2.webp?v=1784008430', productUrl: 'https://edenrobe.com/products/embroidered-cambric-shirt-trouser-egtked6-74036st'),
  Product(id: 'p200', title: 'Embroidered Cotton Silk Kurta Pajama - ECBTKP5-005', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 12,500', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['02-3y', '04y', '05y', '06y', '07-8y', '09-10y', '11-12y', '13-14y'], inStockSizes: const ['02-3y', '04y', '05y', '06y', '07-8y', '09-10y', '11-12y', '13-14y'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Embroidered Cotton Silk Kurta Pajama - E', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/ECBTKP5-005_1.webp?v=1778735125', productUrl: 'https://edenrobe.com/products/boys-black-kurta-pajama-ecbtkp5-005'),
  Product(id: 'p201', title: 'Pocket Square - EAMPS6-008', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 800', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['One Size'], inStockSizes: const ['One Size'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Pocket Square - EAMPS6-008', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/0N9A7314EAMPS5-008.webp?v=1775453355', productUrl: 'https://edenrobe.com/products/mens-black-pocket-square-eamps6-008'),
  Product(id: 'p202', title: 'Embroidered Viscose Suit - EWTKED6-84084-3P', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 7,000', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS', 'S'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Embroidered Viscose Suit - EWTKED6-84084', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/84084_1_1efdb363-932b-460b-912f-171219e215bb.webp?v=1773577635', productUrl: 'https://edenrobe.com/products/pret-embroidered-viscose-suit-ewtked6-84084-3p'),
  Product(id: 'p203', title: 'Embroidered Lawn Suit - EWTKE5-83008-3P', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 6,000', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['XS'], colors: [_c('#5B7355')], imgLabel: 'PRODUCT PHOTO - Embroidered Lawn Suit - EWTKE5-83008-3P', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/EWTKE5-830083P_3_thumbnail.webp?v=1769769887', productUrl: 'https://edenrobe.com/products/pret-embroidered-lawn-suit-ewtke5-83008-3p'),
  Product(id: 'p204', title: 'Blazer - EMTB5-6896', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 13,000', oldPrice: '', category: 'Pret', occasion: 'Festive', sizes: const ['36', '38', '40', '42', '44'], inStockSizes: const ['36', '38', '40', '42', '44'], colors: [_c('#33302E')], imgLabel: 'PRODUCT PHOTO - Blazer - EMTB5-6896', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/EMBT5-6896_7.webp?v=1767158212', productUrl: 'https://edenrobe.com/products/mens-charcoal-blazer-emtb5-6896'),
  Product(id: 'p205', title: 'Woolen Striped Polo Sweater - EMTSWT5-026', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 7,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'L', 'XL', 'XXL'], colors: [_c('#F2E4D2')], imgLabel: 'PRODUCT PHOTO - Woolen Striped Polo Sweater - EMTSWT5-02', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/EMTSWT5-026_6_thumbnail.webp?v=1763101970', productUrl: 'https://edenrobe.com/products/mens-cream-sweater-emtswt5-026'),
  Product(id: 'p206', title: 'Embroidered Khaddar Suit - EWU5V11-32009-3P', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 7,000', oldPrice: '', category: 'Unstitched', occasion: 'Festive', sizes: const ['One Size'], inStockSizes: const ['One Size'], colors: [_c('#4A3B52')], imgLabel: 'PRODUCT PHOTO - Embroidered Khaddar Suit - EWU5V11-32009', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/EWU5V11-32009S_1.jpg?v=1760012525', productUrl: 'https://edenrobe.com/products/unstitched-purple-emroidered-khaddar-3-piece-ewu5v11-32009-3p'),
  Product(id: 'p207', title: 'Embroidered Waistcoat - EMTWC5-35964', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 7,000', oldPrice: '', category: 'Waistcoat', occasion: 'Festive', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['S', 'M', 'L', 'XL', 'XXL'], colors: [_c('#8C8783')], imgLabel: 'PRODUCT PHOTO - Embroidered Waistcoat - EMTWC5-35964', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/0N9A0286EMTWC5-35964thumbnail.jpg?v=1764759933', productUrl: 'https://edenrobe.com/products/mens-grey-waist-coat-emtwc5-35964'),
  Product(id: 'p208', title: 'Zipper Polo - EBTPS24-006', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 800', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['02-3y', '04y', '05y', '06y', '07-8y', '09-10y', '11-12y', '13-14y'], inStockSizes: const ['13-14y'], colors: [_c('#D9B44A')], imgLabel: 'PRODUCT PHOTO - Zipper Polo - EBTPS24-006', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/0N9A3505_EBTPS24-006.webp?v=1753093664', productUrl: 'https://edenrobe.com/products/boys-yellow-polo-shirt-ebtps24-006'),
  Product(id: 'p209', title: 'Check Blazer - EMTB24-6878', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 9,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['36', '38', '40', '42', '44', '46'], inStockSizes: const ['40', '42'], colors: [_c('#22304A')], imgLabel: 'PRODUCT PHOTO - Check Blazer - EMTB24-6878', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/files/EMTB24-6878_2_thumbnail.webp?v=1753095512', productUrl: 'https://edenrobe.com/products/mens-navy-blazer-emtb24-6878'),
  Product(id: 'p210', title: 'Graphic Pullover Hoodie - EGTH22-011', brand: 'Edenrobe', brandId: 'edenrobe', emerging: false, price: 'Rs. 2,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['02-3y', '04y', '04-5y', '05y', '06y', '07-8y', '09-10y', '11-12y'], inStockSizes: const ['02-3y', '04-5y', '06y', '07-8y', '09-10y', '11-12y', '13-14y'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - Graphic Pullover Hoodie - EGTH22-011', imageUrl: 'https://cdn.shopify.com/s/files/1/0841/3796/7889/products/22_G_GirlsHoodies_EGTH22-011_1_603c0d26-e1ff-4de2-92e7-f890954acddc.jpg?v=1701472585', productUrl: 'https://edenrobe.com/products/girl-s-white-hoodie-egth22-011'),
  Product(id: 'p211', title: 'SMART FIT LINEN LIMITED EDITION SHIRT SKY BLUE', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 2,648', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['Small', 'Medium', 'Large', 'XL'], inStockSizes: const ['Medium', 'Large', 'XL'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - SMART FIT LINEN LIMITED EDITION SHIRT SK', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/25LES13-BLU_1_7e62be82-bb41-46bd-993a-95afc47adc95.jpg?v=1789028016', productUrl: 'https://charcoal.com.pk/products/smart-fit-linen-limited-edition-shirt-sky-blue'),
  Product(id: 'p212', title: 'REGULAR COLLAR CASUAL SHIRT LIGHT GREY', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 4,196', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['Small', 'Medium', 'Large', 'XL', 'XXL'], inStockSizes: const ['Medium', 'Large', 'XL'], colors: [_c('#8C8783')], imgLabel: 'PRODUCT PHOTO - REGULAR COLLAR CASUAL SHIRT LIGHT GREY', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC00456.webp?v=1784712204', productUrl: 'https://charcoal.com.pk/products/regular-collar-casual-shirt-light-grey'),
  Product(id: 'p213', title: 'Formal Belt', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 6,695', oldPrice: '', category: 'Pret', occasion: 'Formal', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#EEEEEE'), _c('#4D5769'), _c('#2D3A4D')], imgLabel: 'PRODUCT PHOTO - Formal Belt', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC09909.webp?v=1781868904', productUrl: 'https://charcoal.com.pk/products/formal-belt-90'),
  Product(id: 'p214', title: 'Poly Silk Tie Set', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 2,495', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#EEEEEE'), _c('#879BA4'), _c('#5F7A85')], imgLabel: 'PRODUCT PHOTO - Poly Silk Tie Set', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC07517.1.webp?v=1780392514', productUrl: 'https://charcoal.com.pk/products/tie-set-96'),
  Product(id: 'p215', title: 'SELF TEXTURED KURTA PAJAMA - PREMIUM COLLECTION BLACK', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 7,346', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'Small', 'Medium', 'Large', 'XL'], inStockSizes: const ['XS', 'Small', 'Medium', 'XL'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - SELF TEXTURED KURTA PAJAMA - PREMIUM COL', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC03688_efd2c2c2-01f5-438b-9140-ad26b9065bb1.webp?v=1778494326', productUrl: 'https://charcoal.com.pk/products/kurta-pajama-black-12'),
  Product(id: 'p216', title: 'REGULAR FIT CROSS POCKET PANT NAVY MELANGE', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 3,248', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['30', '32', '34', '36', '38'], inStockSizes: const ['30', '32', '34', '36'], colors: [_c('#22304A')], imgLabel: 'PRODUCT PHOTO - REGULAR FIT CROSS POCKET PANT NAVY MELAN', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC05707.1.webp?v=1774865834', productUrl: 'https://charcoal.com.pk/products/casual-pant-regular-fit-navy-melange'),
  Product(id: 'p217', title: 'Polo Collar  Sweater Black', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 6,296', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['Small', 'Medium', 'Large', 'XL', 'XXL'], inStockSizes: const ['Medium', 'Large', 'XL', 'XXL'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Polo Collar  Sweater Black', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC06328.webp?v=1769148568', productUrl: 'https://charcoal.com.pk/products/polo-collar-sweater-black'),
  Product(id: 'p218', title: 'SMART FIT FULLSLEEVE SUEDE BOMBER JACKET RUST', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 7,498', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['Small', 'Medium', 'Large', 'XL', 'XXL'], inStockSizes: const ['Small', 'Medium'], colors: [_c('#B5583A')], imgLabel: 'PRODUCT PHOTO - SMART FIT FULLSLEEVE SUEDE BOMBER JACKET', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC07173copy.webp?v=1764921549', productUrl: 'https://charcoal.com.pk/products/smart-fit-fullsleeve-suede-bomber-jacket-rust-1'),
  Product(id: 'p219', title: 'Ribbed Knit Henley Sweater Brown', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 4,498', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['Small', 'Medium', 'Large', 'XL', 'XXL'], inStockSizes: const ['Large', 'XL', 'XXL'], colors: [_c('#6B4A32')], imgLabel: 'PRODUCT PHOTO - Ribbed Knit Henley Sweater Brown', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC05505.webp?v=1762588037', productUrl: 'https://charcoal.com.pk/products/ribbed-knit-henley-sweater-brown'),
  Product(id: 'p220', title: 'KNITTED TIPPING COLLAR POLO BEIGE', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 3,248', oldPrice: '', category: 'Kurta', occasion: 'Casual', sizes: const ['Small', 'Medium', 'Large', 'XL', 'XXL'], inStockSizes: const ['Small', 'XXL'], colors: [_c('#D8C7A8')], imgLabel: 'PRODUCT PHOTO - KNITTED TIPPING COLLAR POLO BEIGE', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/f8.webp?v=1757310965', productUrl: 'https://charcoal.com.pk/products/knitted-tipping-collar-polo-beige'),
  Product(id: 'p221', title: 'PLAIN REGULAR TAPERED  BI-STRETCH PANT WHITE', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 2,998', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['30', '32', '34', '36', '38'], inStockSizes: const ['30', '36'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - PLAIN REGULAR TAPERED  BI-STRETCH PANT W', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC03428_cc6a5558-1d90-45d4-a1ca-ae23c3fead5c.jpg?v=1757312393', productUrl: 'https://charcoal.com.pk/products/plain-regular-tapered-bi-stretch-pant-white'),
  Product(id: 'p222', title: 'SLIM FIT TEXTURED PANT NAVY', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 3,248', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['30', '32', '34', '36', '38'], inStockSizes: const ['32'], colors: [_c('#22304A')], imgLabel: 'PRODUCT PHOTO - SLIM FIT TEXTURED PANT NAVY', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC00442_831fccb6-643f-46a6-acc8-570b5fb20f0b.jpg?v=1753963415', productUrl: 'https://charcoal.com.pk/products/slim-fit-textured-pant-navy'),
  Product(id: 'p223', title: 'JACQUARD COTTON KURTA - SIGNATURE COLLECTION WHITE', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 5,246', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['XS', 'Small', 'Medium', 'Large', 'XL'], inStockSizes: const ['XS', 'Small'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - JACQUARD COTTON KURTA - SIGNATURE COLLEC', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC02945_b7f6a793-5553-4eb6-b7db-b951a757937e.jpg?v=1757314990', productUrl: 'https://charcoal.com.pk/products/jacquard-cotton-kurta-signature-collection-white'),
  Product(id: 'p224', title: 'SLIM FIT JOGGER TROUSER BLACK', brand: 'Charcoal', brandId: 'charcoal', emerging: false, price: 'Rs. 3,098', oldPrice: '', category: 'Bottoms', occasion: 'Everyday', sizes: const ['30', '32', '34', '36', '38'], inStockSizes: const ['32', '34', '36', '38'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - SLIM FIT JOGGER TROUSER BLACK', imageUrl: 'https://cdn.shopify.com/s/files/1/0419/6171/7922/files/DSC06594.jpg?v=1742370582', productUrl: 'https://charcoal.com.pk/products/casual-jogger-trouser-black-2'),
  Product(id: 'p225', title: 'Basic Woolen Fudgsickle Traditional Shawl', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 2,500', oldPrice: '', category: 'Shawl', occasion: 'Everyday', sizes: const ['One Size'], inStockSizes: const ['One Size'], colors: [_c('#B3A994'), _c('#53332B'), _c('#2D181B')], imgLabel: 'PRODUCT PHOTO - Basic Woolen Fudgsickle Traditional Shaw', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/Gemini_Generated_Image_6agejn6agejn6age.png?v=1767853769', productUrl: 'https://amiradnan.com/products/basic-woolen-fudgsickle-traditional-shawl-copy'),
  Product(id: 'p226', title: 'PV Cloud Dancer Slim Fit Plain Kurta Pajama', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 8,000', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['L'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - PV Cloud Dancer Slim Fit Plain Kurta Paj', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscoseCloudDancerSlimFitSuit_1_5a2f1e35-f0dc-40fe-8b7b-9223faf190ab.jpg?v=1745843908', productUrl: 'https://amiradnan.com/products/poly-viscose-cloud-dancer-slim-fit-suit-2'),
  Product(id: 'p227', title: 'PV Maluki Vanilla Ice Classic Fit Plain Kameez Shalwar', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 8,000', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL', 'XXL'], inStockSizes: const ['M'], colors: [_c('#CCB49C'), _c('#DBD4CC'), _c('#9E6A67')], imgLabel: 'PRODUCT PHOTO - PV Maluki Vanilla Ice Classic Fit Plain', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/BasicPolyViscoseMalukiVanillaIceClassicFitSuitBOSKIKAMEEZSHALWAR_3.jpg?v=1738410315', productUrl: 'https://amiradnan.com/products/basic-poly-viscose-maluki-vanilla-ice-classic-fit-suit-1'),
  Product(id: 'p228', title: 'PV Cloud Dancer Slim Fit Plain Kurta Pajama', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 5,000', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['XL'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - PV Cloud Dancer Slim Fit Plain Kurta Paj', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/products/FG0002264CLOUDDANCER1.jpg?v=1675250011', productUrl: 'https://amiradnan.com/products/basic-poly-viscose-cloud-dancer-slim-fit-suit'),
  Product(id: 'p229', title: 'Slim Fit Band Collar Plain Kameez Shalwar', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 10,000', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['L'], colors: [_c('#6B4A32')], imgLabel: 'PRODUCT PHOTO - Slim Fit Band Collar Plain Kameez Shalwa', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/SlimFitBandCollarPlainSuit_4644b116-1a74-43da-bd4e-d0a5f81211b7.jpg?v=1786945269', productUrl: 'https://amiradnan.com/products/slim-fit-band-collar-plain-suit-1'),
  Product(id: 'p230', title: 'Poly Viscos Ensign Blue Classic Fit EMB Suit', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 17,500', oldPrice: '', category: 'Shalwar Kameez', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Poly Viscos Ensign Blue Classic Fit EMB', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscosEnsignBlueClassicFitEMBSuit_3.jpg?v=1780488970', productUrl: 'https://amiradnan.com/products/poly-viscos-ensign-blue-classic-fit-emb-suit'),
  Product(id: 'p231', title: 'Off-white satin sherwani with cut-dana hand embroidery', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 410,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#FBF7F0')], imgLabel: 'PRODUCT PHOTO - Off-white satin sherwani with cut-dana h', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/Off-whitesatinsherwaniwithcut-danahandembroidery_5.jpg?v=1775452846', productUrl: 'https://amiradnan.com/products/off-white-satin-sherwani-with-cut-dana-hand-embroidery'),
  Product(id: 'p232', title: 'Premium Jamawar Rust Traditional Waistcoat', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 22,500', oldPrice: '', category: 'Waistcoat', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#B5583A')], imgLabel: 'PRODUCT PHOTO - Premium Jamawar Rust Traditional Waistco', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PremiumJamawarRustTraditionalWaistcoat_835258f2-9492-41ea-921d-afad16c6ba3e.png?v=1783679267', productUrl: 'https://amiradnan.com/products/premium-jamawar-rust-traditional-waistcoat'),
  Product(id: 'p233', title: 'PV Dark Brown Slim Fit Plain Kameez Shalwar', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 9,750', oldPrice: '', category: 'Kurta', occasion: 'Eid', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#6B4A32')], imgLabel: 'PRODUCT PHOTO - PV Dark Brown Slim Fit Plain Kameez Shal', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscoseDarkBrownSlimFitSuit_c3d11594-3d78-4d93-b4de-f723f7d13378.jpg?v=1786945165', productUrl: 'https://amiradnan.com/products/poly-viscose-dark-brown-slim-fit-suit-1'),
  Product(id: 'p234', title: 'Jamawar Navy Blazer Slightly Defected Plain Jacket', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 35,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#22304A')], imgLabel: 'PRODUCT PHOTO - Jamawar Navy Blazer Slightly Defected Pl', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/JamawarNavyBlazerSlightlyDefectedPlainJacket_1.jpg?v=1763381568', productUrl: 'https://amiradnan.com/products/jamawar-navy-blazer-slightly-defected-plain-jacket'),
  Product(id: 'p235', title: 'Jamawar Purple Traditional Waistcoat', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 12,500', oldPrice: '', category: 'Waistcoat', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M'], colors: [_c('#4A3B52')], imgLabel: 'PRODUCT PHOTO - Jamawar Purple Traditional Waistcoat', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/JamawarPurpleTraditionalWaistcoat_3_04963dc3-b704-4d20-bfe3-53e16feb99e3.jpg?v=1745987881', productUrl: 'https://amiradnan.com/products/classic-jamawar-purple-traditional-waistcoat-3'),
  Product(id: 'p236', title: 'Henley Pocket Black T-Shirt', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 2,500', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Henley Pocket Black T-Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/BasicJerseyHenleyPocketBlackT-Shirt_3.jpg?v=1717072365', productUrl: 'https://amiradnan.com/products/basic-jersey-black-t-shirt-2'),
  Product(id: 'p237', title: 'Men\'s Blue Jersey Round Neck T-Shirt', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 2,500', oldPrice: '', category: 'Kurta', occasion: 'Everyday', sizes: const ['S', 'M', 'L', 'XL'], inStockSizes: const ['S', 'M', 'L', 'XL'], colors: [_c('#3A5A80')], imgLabel: 'PRODUCT PHOTO - Men\'s Blue Jersey Round Neck T-Shirt', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/BasicJerseyRoundNeckBlueT-Shirt_4_83e859b9-07a7-484a-a516-564a6762894c.jpg?v=1717065827', productUrl: 'https://amiradnan.com/products/basic-jersey-blue-t-shirt-1'),
  Product(id: 'p238', title: 'Black and White Chiffon Sari', brand: 'Amir Adnan', brandId: 'amir_adnan', emerging: false, price: 'Rs. 60,000', oldPrice: '', category: 'Pret', occasion: 'Everyday', sizes: const ['S', 'M', 'L'], inStockSizes: const ['S', 'M', 'L'], colors: [_c('#171515')], imgLabel: 'PRODUCT PHOTO - Black and White Chiffon Sari', imageUrl: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/8085066D-37A0-4544-9086-865A92E8090F.jpg?v=1700725972', productUrl: 'https://amiradnan.com/products/black-and-white-chiffon-sari'),
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

class TailorRate {
  final String item;
  final String price;
  final String time;
  const TailorRate(this.item, this.price, this.time);
}

class Tailor {
  final String id;
  final String name;
  final String specialtyTitle;
  final String city;
  final String location;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final int startingPrice;
  final int turnaroundDays;
  final List<String> specialties;
  final List<TailorRate> rateCard;
  final String about;
  final bool verified;
  final String phone;

  const Tailor({
    required this.id,
    required this.name,
    required this.specialtyTitle,
    required this.city,
    required this.location,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.startingPrice,
    required this.turnaroundDays,
    required this.specialties,
    required this.rateCard,
    required this.about,
    this.verified = true,
    required this.phone,
  });
}

class StitchingRequest {
  final String id;
  final String outfitTitle;
  final String gender;
  final String fabricSource;
  final String tailorName;
  final String tailorCity;
  final String status;
  final int stageIndex;
  final int price;
  final String orderDate;
  final String estimatedDelivery;
  final String trackingCode;
  final String measurementNotes;

  StitchingRequest({
    required this.id,
    required this.outfitTitle,
    required this.gender,
    required this.fabricSource,
    required this.tailorName,
    required this.tailorCity,
    required this.status,
    required this.stageIndex,
    required this.price,
    required this.orderDate,
    required this.estimatedDelivery,
    required this.trackingCode,
    this.measurementNotes = 'Reference suit pickup arranged',
  });
}

class WardrobeItem {
  final String id;
  final String name;
  final String category;
  final List<String> tags;
  String status; // 'stitched' | 'unstitched' | 'with_tailor'
  final String imageUrl;
  String? tailorName;
  String? tailorEta;
  final DateTime createdAt;

  WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.tags,
    required this.status,
    this.imageUrl = '',
    this.tailorName,
    this.tailorEta,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isStitched => status == 'stitched';
  bool get isUnstitched => status == 'unstitched';
  bool get isWithTailor => status == 'with_tailor';

  String get statusBadge {
    switch (status) {
      case 'unstitched':
        return 'Needs Tailor';
      case 'with_tailor':
        return 'With Tailor';
      default:
        return 'Ready';
    }
  }
}

const kTailors = <Tailor>[
  Tailor(
    id: 't1',
    name: 'Master Rafiq & Sons',
    specialtyTitle: 'Master Artisan in Men\'s Kurta & Boski Silk',
    city: 'Lahore',
    location: 'Gulberg III & Old Anarkali',
    experienceYears: 24,
    rating: 4.9,
    reviewCount: 148,
    startingPrice: 2800,
    turnaroundDays: 4,
    specialties: ['Men\'s Kurta Shalwar', 'Pure Boski', 'Embroidered Waistcoat', 'Reference Fit Copy'],
    rateCard: [
      TailorRate('Standard Kurta Shalwar', 'Rs. 2,800', '3-4 days'),
      TailorRate('Pure Boski / Silk Suit', 'Rs. 3,500', '4-5 days'),
      TailorRate('Bespoke Embroidered Waistcoat', 'Rs. 4,200', '5-6 days'),
      TailorRate('Handcrafted Sherwani', 'Rs. 9,500', '7-10 days'),
    ],
    about: 'Master Rafiq has tailored for dignitaries, artists, and three generations of Lahore families. Known for razor-sharp collar finishes, hand-stitched buttonholes, and exact replication of your favorite reference suit.',
    phone: '+92 300 4289122',
  ),
  Tailor(
    id: 't2',
    name: 'Noor Bridal & Couture Studio',
    specialtyTitle: 'High-End Women\'s Pret & Formal Embellishment',
    city: 'Karachi',
    location: 'Clifton Block 4 & Tariq Road',
    experienceYears: 16,
    rating: 4.9,
    reviewCount: 210,
    startingPrice: 4500,
    turnaroundDays: 6,
    specialties: ['Luxury Lawn to Pret', 'Formal Gowns', 'Zari & Tilla Setting', 'Lining & Finishing'],
    rateCard: [
      TailorRate('3-Piece Formal Suit with Lining', 'Rs. 4,500', '5-6 days'),
      TailorRate('Festive Kurti & Trouser', 'Rs. 3,800', '4 days'),
      TailorRate('Bridal / Heavy Embroidered Suit', 'Rs. 8,500', '7-10 days'),
      TailorRate('Organza / Net Dupatta Tassels', 'Rs. 1,500', '2 days'),
    ],
    about: 'Karachi\'s premier bespoke women\'s atelier specializing in transforming designer unstitched lawn, net, and chiffon cuts into pristine ready-to-wear silhouettes with custom piping, laces, and hand-tassels.',
    phone: '+92 321 8294401',
  ),
  Tailor(
    id: 't3',
    name: 'Ustaad Aslam Master Cutter',
    specialtyTitle: 'Specialist in Prince Coats & Bespoke Waistcoats',
    city: 'Islamabad',
    location: 'F-10 Markaz & Blue Area',
    experienceYears: 28,
    rating: 4.8,
    reviewCount: 92,
    startingPrice: 3200,
    turnaroundDays: 3,
    specialties: ['Prince Coats', 'Festive Waistcoats', 'Fine Egyptian Latha', 'Home Pickup'],
    rateCard: [
      TailorRate('Tailored Kurta Shalwar', 'Rs. 3,200', '3 days'),
      TailorRate('Bespoke Waistcoat / Jawahar', 'Rs. 4,500', '4 days'),
      TailorRate('Royal Prince Coat', 'Rs. 7,800', '5-6 days'),
      TailorRate('Collar & Cuff Monogramming', 'Rs. 800', '1 day'),
    ],
    about: 'Trained under British bespoke tailoring standards with master expertise in Pakistani formal attire. Famous for anatomical shoulder cuts, structured chest canvas, and complimentary doorstep reference suit pickup in the twin cities.',
    phone: '+92 333 5183392',
  ),
  Tailor(
    id: 't4',
    name: 'Gulberg Express Stitching',
    specialtyTitle: 'Express 48-Hour Everyday & Workwear Pret',
    city: 'Lahore',
    location: 'MM Alam Road, Gulberg II',
    experienceYears: 14,
    rating: 4.7,
    reviewCount: 184,
    startingPrice: 2400,
    turnaroundDays: 2,
    specialties: ['48hr Express Delivery', 'Unstitched Lawn to Pret', 'Daily Casuals', 'Trouser Styling'],
    rateCard: [
      TailorRate('Express 2-Piece Lawn Suit', 'Rs. 2,400', '48 hours'),
      TailorRate('3-Piece Printed/Embroidered Suit', 'Rs. 3,000', '2-3 days'),
      TailorRate('Culottes / Tulip / Straight Pant', 'Rs. 1,200', '24 hours'),
      TailorRate('Urgent 24h Rush Stitching', 'Rs. 3,800', '24 hours'),
    ],
    about: 'The ideal solution when Eid or an event is right around the corner. Clean modern cuts, computerized stitch tension, and guaranteed on-time delivery across Lahore within 48 hours of fabric receipt.',
    phone: '+92 301 4928173',
  ),
  Tailor(
    id: 't5',
    name: 'Saddar Craftsmanship Guild',
    specialtyTitle: 'Heritage Sherwanis & Traditional Formal Wear',
    city: 'Rawalpindi',
    location: 'Bank Road, Saddar Cantt',
    experienceYears: 35,
    rating: 5.0,
    reviewCount: 68,
    startingPrice: 5000,
    turnaroundDays: 7,
    specialties: ['Heritage Sherwani', 'Raw Silk Achkan', 'Groom Attire', 'Pure Karandi Suits'],
    rateCard: [
      TailorRate('Handmade Sherwani with Inner Suit', 'Rs. 12,000', '7-10 days'),
      TailorRate('Pure Karandi / Wool Winter Suit', 'Rs. 4,500', '5 days'),
      TailorRate('Embroidered Velvet Shawl Finish', 'Rs. 3,000', '3 days'),
      TailorRate('Ceremonial Pagri / Turban Styling', 'Rs. 2,500', '2 days'),
    ],
    about: 'Decades of royal craft heritage in the historic Saddar cantonment. Specializes in luxury groom attire, heavily detailed pocket flaps, hand-sewn button loops, and pure raw silk creations.',
    phone: '+92 345 5581900',
  ),
  Tailor(
    id: 't6',
    name: 'Al-Zahra Pret Lab',
    specialtyTitle: 'Trendy Cuts, Lawn Finishes & Piping Artistry',
    city: 'Faisalabad',
    location: 'D-Ground, Peoples Colony',
    experienceYears: 11,
    rating: 4.8,
    reviewCount: 76,
    startingPrice: 2200,
    turnaroundDays: 3,
    specialties: ['Lawn Stitching', 'Contemporary Pakistani Cuts', 'Lace Finishing', 'Affordable Pret'],
    rateCard: [
      TailorRate('Standard 3-Piece Lawn Stitching', 'Rs. 2,200', '3 days'),
      TailorRate('A-Line / Flared Kurti with Laces', 'Rs. 1,800', '2 days'),
      TailorRate('Embroidered Trouser / Gharara Pant', 'Rs. 1,400', '2 days'),
      TailorRate('Bulk Order (3+ suits, 15% off)', 'Rs. 5,600', '4 days'),
    ],
    about: 'A fresh, dynamic stitching studio located in the textile heart of Pakistan. They bring magazine lookbook designs to life with immaculate neckline finishes, hem inlays, and trendy sleeve cuts.',
    phone: '+92 304 7716629',
  ),
];

Tailor tailorById(String id) =>
    kTailors.firstWhere((t) => t.id == id, orElse: () => kTailors.first);

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
  String imageSearchRefId = 'p16';

  final prefCategories = <String>{};
  final prefStyles = <String>{};
  final prefBrands = <String>{};
  final prefBudget = <String>{};
  final prefColors = <String>{};
  final prefSizes = <String>{};

  final filterCategories = <String>{};
  final filterBudget = <String>{};
  final filterColors = <String>{};
  final filterSizes = <String>{};
  bool filterEmergingOnly = false;
  String sortOption = 'Recommended';

  final savedLooks = <SavedLook>[
    SavedLook('look1', 'Wedding Guest, Maroon & Gold', ['p1', 'p11', 'p10']),
  ];
  String selectedTailorId = 't1';
  final stitchingRequests = <StitchingRequest>[
    StitchingRequest(
      id: 'REQ-8492',
      outfitTitle: 'Festive Raw Silk Kurta Shalwar',
      gender: 'Men',
      fabricSource: 'J. Junaid Jamshed Pure Latha',
      tailorName: 'Master Rafiq & Sons',
      tailorCity: 'Lahore',
      status: 'Hand & Machine Stitching',
      stageIndex: 2,
      price: 3500,
      orderDate: 'Sep 4, 2026',
      estimatedDelivery: 'Sep 10, 2026',
      trackingCode: 'LBS-LHR-9823',
      measurementNotes: 'Reference suit picked up from Gulberg III',
    ),
    StitchingRequest(
      id: 'REQ-7911',
      outfitTitle: '3-Piece Embroidered Lawn Suit with Organza Dupatta',
      gender: 'Women',
      fabricSource: 'Sana Safinaz Luxury Lawn 2026',
      tailorName: 'Gulberg Express Stitching',
      tailorCity: 'Lahore',
      status: 'Cutting & Marking',
      stageIndex: 1,
      price: 4200,
      orderDate: 'Sep 6, 2026',
      estimatedDelivery: 'Sep 11, 2026',
      trackingCode: 'LBS-LHR-7741',
      measurementNotes: 'Standard Medium + 2 inches shirt length',
    ),
  ];

  void addStitchingRequest(StitchingRequest req) {
    stitchingRequests.insert(0, req);
    notifyListeners();
  }

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

  final wardrobeItems = <WardrobeItem>[
    WardrobeItem(
      id: 'w1',
      name: 'Rust Embroidered Cotton Kurta',
      category: 'Kurta',
      tags: ['cotton', 'casual', 'traditional'],
      status: 'stitched',
      imageUrl: 'https://cdn.shopify.com/s/files/1/0740/1753/8280/files/SS26ESE427P2T_1.jpg?v=1788411485',
    ),
    WardrobeItem(
      id: 'w2',
      name: '3-Piece Printed Lawn Suit (Fabric)',
      category: 'Unstitched Fabric',
      tags: ['lawn', 'festive', 'eid'],
      status: 'unstitched',
      imageUrl: 'https://cdn.shopify.com/s/files/1/0740/1753/8280/files/H262-006B-2BS.jpg?v=1783410619',
    ),
    WardrobeItem(
      id: 'w3',
      name: 'Charcoal Raw Silk Kurta Shalwar',
      category: 'Shalwar Kameez',
      tags: ['silk', 'formal', 'wedding'],
      status: 'with_tailor',
      tailorName: 'Master Rafiq & Sons',
      tailorEta: 'Sep 14, 2026',
      imageUrl: 'https://cdn.shopify.com/s/files/1/0706/3253/8159/files/Men-Suits-Color-Black-Blended-Regular-Fit-SK-WCS25-005-Half-Front.jpg?v=1764403213',
    ),
    WardrobeItem(
      id: 'w4',
      name: 'Pastel Organza Embroidered Dupatta',
      category: 'Dupatta',
      tags: ['silk', 'festive', 'eid'],
      status: 'stitched',
      imageUrl: 'https://cdn.shopify.com/s/files/1/0740/1753/8280/files/Gemini_Generated_Image_bkaggybkaggybkag.jpg?v=1787229241',
    ),
    WardrobeItem(
      id: 'w5',
      name: 'Pure Karandi Winter Fabric',
      category: 'Unstitched Fabric',
      tags: ['traditional', 'formal'],
      status: 'unstitched',
      imageUrl: 'https://cdn.shopify.com/s/files/1/0706/3253/8159/files/3PCKhaddarEmbroideredSuitIPSTD-55085_front.jpg?v=1765865988',
    ),
  ];

  void addWardrobeItem(WardrobeItem item) {
    wardrobeItems.insert(0, item);
    notifyListeners();
  }

  void removeWardrobeItem(String id) {
    wardrobeItems.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void markWardrobeItemReady(String id) {
    final idx = wardrobeItems.indexWhere((i) => i.id == id);
    if (idx != -1) {
      wardrobeItems[idx].status = 'stitched';
      wardrobeItems[idx].tailorName = null;
      wardrobeItems[idx].tailorEta = null;
      notifyListeners();
    }
  }

  void updateWardrobeItemStatus(String id, String newStatus, {String? tailorName, String? tailorEta}) {
    final idx = wardrobeItems.indexWhere((i) => i.id == id);
    if (idx != -1) {
      wardrobeItems[idx].status = newStatus;
      if (tailorName != null) wardrobeItems[idx].tailorName = tailorName;
      if (tailorEta != null) wardrobeItems[idx].tailorEta = tailorEta;
      notifyListeners();
    }
  }

  List<WardrobeItem> get readyWardrobeItems => wardrobeItems.where((i) => i.isStitched).toList();
  List<WardrobeItem> get unstitchedWardrobeItems => wardrobeItems.where((i) => i.isUnstitched).toList();
  List<WardrobeItem> get withTailorWardrobeItems => wardrobeItems.where((i) => i.isWithTailor).toList();
}
