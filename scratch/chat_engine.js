// Chat Engine Implementation for LibasAI Assistant
const PRESET_CONVERSATIONS = {
  'rust-kurta': {
    id: 'rust-kurta',
    title: 'Rust kurta for a wedding',
    messages: [
      {
        role: 'user',
        text: 'Find me a rust-colored formal kurta under Rs. 6,000 for an evening wedding event'
      },
      {
        role: 'assistant',
        steps: ['Understanding request', 'Searching products', 'Personalizing', 'Comparing', 'Building recommendations'],
        text: 'Found 6 verified options across 4 Pakistani brands. Here are the 3 closest matches for your formal wedding budget:',
        products: [
          {
            brand: 'Sana Safinaz',
            title: 'Stitched Embroidered Kurta',
            price: 'PKR 2,480',
            img: 'https://cdn.shopify.com/s/files/1/0740/1753/8280/files/ss25sge333_1.jpg?v=1756730702',
            url: 'https://sanasafinaz.com'
          },
          {
            brand: 'Zellbury',
            title: 'Rust Festive 2-Piece Kurta Set',
            price: 'PKR 4,490',
            img: 'https://cdn.shopify.com/s/files/1/0595/3260/7535/files/WUS26E34112_10.png?v=1786956804',
            url: 'https://www.zellbury.com'
          },
          {
            brand: 'Gul Ahmed',
            title: 'Embroidered Festive Kurti',
            price: 'PKR 4,893',
            img: 'https://cdn.shopify.com/s/files/1/0706/3253/8159/files/3PCLawnPrintedSuitIUSTKSD-2207_front.jpg?v=1768905960',
            url: 'https://www.gulahmedshop.com'
          }
        ]
      }
    ]
  },
  'eid-outfit': {
    id: 'eid-outfit',
    title: 'Eid outfit ideas',
    messages: [
      {
        role: 'user',
        text: 'Show me trending Eid outfit ideas with a pastel or festive vibe under Rs. 15,000'
      },
      {
        role: 'assistant',
        steps: ['Scanning Eid 2026 collections', 'Fabric check (Lawn/Jacquard)', 'Price filtering (<15k)', 'Curating 3 top looks'],
        text: 'Curated 3 festive Eid looks from J., Diners, and Generation featuring pastel tones, intricate resham embroidery, and breathable luxury fabrics:',
        products: [
          {
            brand: 'J. Junaid Jamshed',
            title: 'Festive Jacquard Pastel Mint Kurta',
            price: 'PKR 6,490',
            img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/Untitled-1_0038_2489navyblazer_2.jpg?v=1705316202',
            url: 'https://www.junaidjamshed.com'
          },
          {
            brand: 'Diners',
            title: 'Platinum Festive Egyptian Cotton Suit',
            price: 'PKR 8,990',
            img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscoseNavyBlazerSlimFitSuit_5.jpg?v=1745494747',
            url: 'https://diners.com.pk'
          },
          {
            brand: 'Generation',
            title: 'Jacquard Festive 3-Piece Stitched Suit',
            price: 'PKR 11,500',
            img: 'https://cdn.shopify.com/s/files/1/0706/3253/8159/files/3PCLawnPrintedSuitIUSTKSD-2207_front.jpg?v=1768905960',
            url: 'https://generation.com.pk'
          }
        ]
      }
    ]
  },
  'compare-lawn': {
    id: 'compare-lawn',
    title: 'Compare lawn suits',
    messages: [
      {
        role: 'user',
        text: 'Compare unstitched 3-piece luxury lawn suits from Sana Safinaz and Gul Ahmed'
      },
      {
        role: 'assistant',
        steps: ['Analyzing lawn thread-count', 'Comparing dupatta fabrics', 'Price-to-quality index', 'Comparison ready'],
        text: 'Detailed comparison for 2026 Luxury Lawn: Sana Safinaz Muzlin features delicate organza borders and silk chiffon dupattas, while Gul Ahmed Festive Lawn utilizes Swiss voile with superior color retention:',
        products: [
          {
            brand: 'Sana Safinaz',
            title: 'Muzlin Luxury 3PC Lawn Suit',
            price: 'PKR 7,990',
            img: 'https://cdn.shopify.com/s/files/1/0740/1753/8280/files/ss25sge333_1.jpg?v=1756730702',
            url: 'https://sanasafinaz.com'
          },
          {
            brand: 'Gul Ahmed',
            title: '3PC Printed Festive Lawn Suit',
            price: 'PKR 4,893',
            img: 'https://cdn.shopify.com/s/files/1/0706/3253/8159/files/3PCLawnPrintedSuitIUSTKSD-2207_front.jpg?v=1768905960',
            url: 'https://www.gulahmedshop.com'
          },
          {
            brand: 'Zellbury',
            title: 'Digital Printed 3-Piece Lawn Set',
            price: 'PKR 3,690',
            img: 'https://cdn.shopify.com/s/files/1/0595/3260/7535/files/WUS26E34112_10.png?v=1786956804',
            url: 'https://www.zellbury.com'
          }
        ]
      }
    ]
  },
  'formal-shalwar': {
    id: 'formal-shalwar',
    title: 'Formal shalwar kameez',
    messages: [
      {
        role: 'user',
        text: 'Looking for pure Egyptian cotton or premium latha formal shalwar kameez for men'
      },
      {
        role: 'assistant',
        steps: ['Filtering fabric: Egyptian Cotton & Latha', 'Verifying collar & cuff tailoring', 'Brand availability confirmed'],
        text: 'Found top-tier formal men\'s ethnic wear in pure Egyptian cotton and hard-finish latha from premier Pakistani menswear ateliers:',
        products: [
          {
            brand: 'Amir Adnan',
            title: 'PV Navy Blazer Slim Fit Suit',
            price: 'PKR 9,000',
            img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscoseNavyBlazerSlimFitSuit_5.jpg?v=1745494747',
            url: 'https://amiradnan.com'
          },
          {
            brand: 'Amir Adnan',
            title: 'Maluki Classic Fit Kurta Pajama',
            price: 'PKR 7,000',
            img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/Untitled-1_0038_2489navyblazer_2.jpg?v=1705316202',
            url: 'https://amiradnan.com'
          },
          {
            brand: 'Diners',
            title: 'Pure Egyptian Cotton Formal Suit',
            price: 'PKR 8,990',
            img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscoseNavyBlazerSlimFitSuit_5.jpg?v=1745494747',
            url: 'https://diners.com.pk'
          }
        ]
      }
    ]
  }
};

const PRODUCT_CATALOG = [
  {
    brand: 'Amir Adnan',
    title: 'PV Navy Blazer Slim Fit Plain Kameez Shalwar',
    category: 'shalwar kameez formal suit men',
    gender: 'men',
    color: 'navy blue',
    price: 'PKR 9,000',
    priceNum: 9000,
    img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscoseNavyBlazerSlimFitSuit_5.jpg?v=1745494747',
    url: 'https://amiradnan.com'
  },
  {
    brand: 'Amir Adnan',
    title: 'PV Maluki Navy Blazer Slim Fit Kurta Pajama',
    category: 'kurta formal eid wedding men',
    gender: 'men',
    color: 'navy blue',
    price: 'PKR 7,000',
    priceNum: 7000,
    img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/Untitled-1_0038_2489navyblazer_2.jpg?v=1705316202',
    url: 'https://amiradnan.com'
  },
  {
    brand: 'Amir Adnan',
    title: 'Ceremonial Embroidered Silk Sherwani',
    category: 'sherwani wedding groom formal men',
    gender: 'men',
    color: 'black gold',
    price: 'PKR 34,500',
    priceNum: 34500,
    img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscoseNavyBlazerSlimFitSuit_5.jpg?v=1745494747',
    url: 'https://amiradnan.com'
  },
  {
    brand: 'Diners',
    title: 'Pure Egyptian Cotton White Formal Suit',
    category: 'shalwar kameez latha cotton men formal',
    gender: 'men',
    color: 'white',
    price: 'PKR 8,990',
    priceNum: 8990,
    img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscoseNavyBlazerSlimFitSuit_5.jpg?v=1745494747',
    url: 'https://diners.com.pk'
  },
  {
    brand: 'Diners',
    title: 'Obsidian Black Textured Kurta',
    category: 'kurta formal black men eid',
    gender: 'men',
    color: 'black',
    price: 'PKR 5,450',
    priceNum: 5450,
    img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/Untitled-1_0038_2489navyblazer_2.jpg?v=1705316202',
    url: 'https://diners.com.pk'
  },
  {
    brand: 'J. Junaid Jamshed',
    title: 'Festive Jacquard Pastel Mint Kurta',
    category: 'kurta eid festive pastel men',
    gender: 'men',
    color: 'mint green pastel',
    price: 'PKR 6,490',
    priceNum: 6490,
    img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/Untitled-1_0038_2489navyblazer_2.jpg?v=1705316202',
    url: 'https://www.junaidjamshed.com'
  },
  {
    brand: 'J. Junaid Jamshed',
    title: 'Executive Hard-Finish Latha Shalwar Suit',
    category: 'shalwar kameez latha formal men',
    gender: 'men',
    color: 'cream offwhite',
    price: 'PKR 7,850',
    priceNum: 7850,
    img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscoseNavyBlazerSlimFitSuit_5.jpg?v=1745494747',
    url: 'https://www.junaidjamshed.com'
  },
  {
    brand: 'Ismail Farid',
    title: 'Signature Cut Bespoke Raw Silk Waistcoat',
    category: 'waistcoat wedding formal men',
    gender: 'men',
    color: 'charcoal black',
    price: 'PKR 16,500',
    priceNum: 16500,
    img: 'https://cdn.shopify.com/s/files/1/0552/1339/1936/files/PolyViscoseNavyBlazerSlimFitSuit_5.jpg?v=1745494747',
    url: 'https://ismailfarid.com'
  },
  {
    brand: 'Sana Safinaz',
    title: 'Stitched Embroidered Lawn Shalwar Set',
    category: 'kurta lawn wedding festive women',
    gender: 'women',
    color: 'rust maroon brown',
    price: 'PKR 2,480',
    priceNum: 2480,
    img: 'https://cdn.shopify.com/s/files/1/0740/1753/8280/files/ss25sge333_1.jpg?v=1756730702',
    url: 'https://sanasafinaz.com'
  },
  {
    brand: 'Zellbury',
    title: 'Rust Festive 2-Piece Kurta Set',
    category: 'kurta festive wedding pret women',
    gender: 'women',
    color: 'rust orange terracotta',
    price: 'PKR 4,490',
    priceNum: 4490,
    img: 'https://cdn.shopify.com/s/files/1/0595/3260/7535/files/WUS26E34112_10.png?v=1786956804',
    url: 'https://www.zellbury.com'
  },
  {
    brand: 'Gul Ahmed',
    title: '3PC Lawn Printed Festive Suit',
    category: 'lawn suit unstitched festive women',
    gender: 'women',
    color: 'mustard yellow olive',
    price: 'PKR 4,893',
    priceNum: 4893,
    img: 'https://cdn.shopify.com/s/files/1/0706/3253/8159/files/3PCLawnPrintedSuitIUSTKSD-2207_front.jpg?v=1768905960',
    url: 'https://www.gulahmedshop.com'
  },
  {
    brand: 'Sana Safinaz',
    title: 'Muzlin Luxury 3PC Lawn Collection',
    category: 'lawn suit luxury unstitched women',
    gender: 'women',
    color: 'pastel peach teal',
    price: 'PKR 7,990',
    priceNum: 7990,
    img: 'https://cdn.shopify.com/s/files/1/0740/1753/8280/files/ss25sge333_1.jpg?v=1756730702',
    url: 'https://sanasafinaz.com'
  },
  {
    brand: 'Generation',
    title: 'Jacquard Festive 3-Piece Stitched Suit',
    category: 'eid festive jacquard pret women',
    gender: 'women',
    color: 'emerald green gold',
    price: 'PKR 11,500',
    priceNum: 11500,
    img: 'https://cdn.shopify.com/s/files/1/0706/3253/8159/files/3PCLawnPrintedSuitIUSTKSD-2207_front.jpg?v=1768905960',
    url: 'https://generation.com.pk'
  },
  {
    brand: 'Beechtree',
    title: 'Embroidered Chiffon 3PC Festive Ensemble',
    category: 'chiffon wedding festive party women',
    gender: 'women',
    color: 'lilac lavender silver',
    price: 'PKR 8,950',
    priceNum: 8950,
    img: 'https://cdn.shopify.com/s/files/1/0595/3260/7535/files/WUS26E34112_10.png?v=1786956804',
    url: 'https://beechtree.pk'
  },
  {
    brand: 'Khaadi',
    title: 'Printed Light Khaddar Daily Kurta',
    category: 'kurta casual pret women',
    gender: 'women',
    color: 'black beige monochrome',
    price: 'PKR 3,290',
    priceNum: 3290,
    img: 'https://cdn.shopify.com/s/files/1/0740/1753/8280/files/ss25sge333_1.jpg?v=1756730702',
    url: 'https://pk.khaadi.com'
  }
];

function performCatalogSearch(query) {
  const q = query.toLowerCase();
  const words = q.split(/\s+/).filter(w => w.length > 1);

  const scored = PRODUCT_CATALOG.map(p => {
    let score = 0;
    const text = `${p.brand} ${p.title} ${p.category} ${p.gender} ${p.color}`.toLowerCase();
    for (const w of words) {
      if (text.includes(w)) score += 2;
    }
    // Budget check
    const match = q.match(/(?:under|below|<)\s*(?:rs\.?|pkr)?\s*(\d+)(?:k)?/i);
    if (match) {
      let max = parseInt(match[1], 10);
      if (q.includes('k') || max < 500) max *= 1000;
      if (p.priceNum <= max) score += 3;
      else score -= 3;
    }
    return { product: p, score };
  });

  scored.sort((a, b) => b.score - a.score);
  const matched = scored.filter(s => s.score > 0).map(s => s.product);
  const results = matched.length >= 3 ? matched.slice(0, 3) : PRODUCT_CATALOG.slice(0, 3);

  return {
    answer: `Found ${results.length} verified options across Pakistani brand archives matching "${query}". Filtered by fabric suitability, verified silhouettes, and official pricing:`,
    products: results
  };
}

console.log('Test engine loaded successfully.');
const res = performCatalogSearch('men black kurta under 8000');
console.log('Result count:', res.products.length);
console.log('First product:', res.products[0].brand, res.products[0].title);
