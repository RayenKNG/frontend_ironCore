class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String imageEmoji;   // placeholder; replace with imageUrl in production
  final String badge;        // 'sale' | 'new' | 'hot' | 'limited' | ''
  final int stock;
  final List<ProductSpec> specs;
  final List<String> tags;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageEmoji,
    this.badge = '',
    required this.stock,
    required this.specs,
    required this.tags,
  });

  double get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return ((1 - price / originalPrice!) * 100).roundToDouble();
  }

  double get savings => (originalPrice ?? price) - price;

  bool get isLowStock => stock <= 20;
  bool get isOutOfStock => stock == 0;

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id:            map['id'] as String,
    name:          map['name'] as String,
    category:      map['category'] as String,
    description:   map['description'] as String,
    price:         (map['price'] as num).toDouble(),
    originalPrice: map['originalPrice'] != null ? (map['originalPrice'] as num).toDouble() : null,
    rating:        (map['rating'] as num).toDouble(),
    reviewCount:   map['reviewCount'] as int,
    imageEmoji:    map['imageEmoji'] as String,
    badge:         map['badge'] as String? ?? '',
    stock:         map['stock'] as int,
    specs:         (map['specs'] as List).map((s) => ProductSpec.fromMap(s)).toList(),
    tags:          List<String>.from(map['tags'] as List),
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'category': category, 'description': description,
    'price': price, 'originalPrice': originalPrice, 'rating': rating,
    'reviewCount': reviewCount, 'imageEmoji': imageEmoji, 'badge': badge,
    'stock': stock,
    'specs': specs.map((s) => s.toMap()).toList(),
    'tags': tags,
  };
}

class ProductSpec {
  final String key;
  final String value;

  const ProductSpec({required this.key, required this.value});

  factory ProductSpec.fromMap(Map<String, dynamic> m) =>
      ProductSpec(key: m['key'] as String, value: m['value'] as String);

  Map<String, dynamic> toMap() => {'key': key, 'value': value};
}

// ── Dummy data (replace with Firestore fetch in production) ──────────────────
final List<ProductModel> dummyProducts = [
  ProductModel(
    id: '1', name: 'Dumbbell Hex Rubber 5kg', category: 'Beban',
    description: 'Dumbbell heksagonal dengan lapisan rubber anti-selip. Desain ergonomis dan nyaman di genggam. Cocok untuk latihan rumahan maupun gym profesional.',
    price: 185000, originalPrice: 230000, rating: 4.9, reviewCount: 312,
    imageEmoji: '🏋️', badge: 'sale', stock: 87,
    specs: [ProductSpec(key:'Berat',value:'5 kg'), ProductSpec(key:'Material',value:'Cast Iron + Rubber'), ProductSpec(key:'Garansi',value:'2 Tahun'), ProductSpec(key:'Warna',value:'Hitam')],
    tags: ['dumbbell','rubber','hex','beban'],
  ),
  ProductModel(
    id: '2', name: 'Barbell Olympic 20kg', category: 'Beban',
    description: 'Barbell olimpik standar dengan knurling grip premium. Kapasitas beban hingga 300kg. Ideal untuk bench press, squat, dan deadlift.',
    price: 890000, rating: 4.8, reviewCount: 98,
    imageEmoji: '⚡', badge: 'hot', stock: 23,
    specs: [ProductSpec(key:'Berat',value:'20 kg'), ProductSpec(key:'Panjang',value:'220 cm'), ProductSpec(key:'Kapasitas',value:'300 kg'), ProductSpec(key:'Bahan',value:'Alloy Steel')],
    tags: ['barbell','olympic','beban'],
  ),
  ProductModel(
    id: '3', name: 'Treadmill Electric Pro X7', category: 'Kardio',
    description: 'Treadmill elektrik dengan motor 3HP, kecepatan 1–18 km/jam, dan 15 program otomatis. Layar LCD besar menampilkan kalori, jarak, dan detak jantung.',
    price: 5490000, originalPrice: 6200000, rating: 4.7, reviewCount: 156,
    imageEmoji: '🏃', badge: 'sale', stock: 12,
    specs: [ProductSpec(key:'Motor',value:'3.0 HP'), ProductSpec(key:'Kecepatan',value:'1–18 km/jam'), ProductSpec(key:'Dimensi',value:'175×75×130 cm'), ProductSpec(key:'Daya',value:'220V / 50Hz')],
    tags: ['treadmill','kardio','elektrik'],
  ),
  ProductModel(
    id: '4', name: 'Pull Up Bar Doorway', category: 'Aksesoris',
    description: 'Bar pull-up yang dapat dipasang di rangka pintu tanpa bor. Material baja anti-karat, kapasitas beban hingga 150kg.',
    price: 275000, originalPrice: 320000, rating: 4.6, reviewCount: 431,
    imageEmoji: '🚪', badge: 'sale', stock: 64,
    specs: [ProductSpec(key:'Material',value:'Alloy Steel'), ProductSpec(key:'Lebar',value:'60–100 cm'), ProductSpec(key:'Kapasitas',value:'150 kg'), ProductSpec(key:'Warna',value:'Chrome')],
    tags: ['pullup','doorway','aksesoris'],
  ),
  ProductModel(
    id: '5', name: 'Bench Press Adjustable FID', category: 'Bench & Rack',
    description: 'Bench press dengan 7 posisi sudut (flat, incline, decline). Rangka baja tebal, bantalan tebal dan nyaman.',
    price: 1750000, rating: 4.9, reviewCount: 87,
    imageEmoji: '🪑', badge: 'new', stock: 31,
    specs: [ProductSpec(key:'Posisi',value:'7 Sudut'), ProductSpec(key:'Kapasitas',value:'280 kg'), ProductSpec(key:'Dimensi',value:'130×50×50 cm'), ProductSpec(key:'Bahan',value:'Heavy Steel')],
    tags: ['bench','press','adjustable'],
  ),
  ProductModel(
    id: '6', name: 'Resistance Band Set (5 Level)', category: 'Aksesoris',
    description: 'Set 5 resistance band dengan level resistansi berbeda (10–60 lb). Material latex premium, tahan lama dan elastis tinggi.',
    price: 145000, originalPrice: 180000, rating: 4.5, reviewCount: 678,
    imageEmoji: '🎽', badge: 'sale', stock: 150,
    specs: [ProductSpec(key:'Level',value:'5 Warna'), ProductSpec(key:'Material',value:'Latex Premium'), ProductSpec(key:'Panjang',value:'208 cm/pcs'), ProductSpec(key:'Isi',value:'5 band + tas')],
    tags: ['band','resistance','set','aksesoris'],
  ),
  ProductModel(
    id: '7', name: 'Kettlebell Cast Iron 16kg', category: 'Beban',
    description: 'Kettlebell cor besi dengan finishing cat epoxy anti-karat. Permukaan bertekstur untuk grip kuat. Cocok untuk swing, snatch, dan Turkish get-up.',
    price: 420000, rating: 4.8, reviewCount: 203,
    imageEmoji: '🏺', badge: 'hot', stock: 45,
    specs: [ProductSpec(key:'Berat',value:'16 kg'), ProductSpec(key:'Material',value:'Cast Iron'), ProductSpec(key:'Finishing',value:'Epoxy Paint'), ProductSpec(key:'Base',value:'Flat')],
    tags: ['kettlebell','16kg','beban'],
  ),
  ProductModel(
    id: '8', name: 'Gym Gloves Pro Grip', category: 'Aksesoris',
    description: 'Sarung tangan gym dengan palm padding tebal dan wrist support. Material microfiber + neoprene. Cocok untuk semua jenis latihan beban.',
    price: 95000, originalPrice: 120000, rating: 4.4, reviewCount: 892,
    imageEmoji: '🧤', badge: 'sale', stock: 200,
    specs: [ProductSpec(key:'Material',value:'Microfiber + Neoprene'), ProductSpec(key:'Ukuran',value:'S / M / L / XL'), ProductSpec(key:'Fitur',value:'Wrist Support'), ProductSpec(key:'Gender',value:'Unisex')],
    tags: ['gloves','grip','aksesoris'],
  ),
  ProductModel(
    id: '9', name: 'Jumping Rope Speed Cable', category: 'Kardio',
    description: 'Tali lompat kecepatan tinggi dengan kabel baja anti-kusut. Handle aluminium CNC dengan bearing presisi. Ideal untuk HIIT dan boxing workout.',
    price: 130000, rating: 4.7, reviewCount: 344,
    imageEmoji: '🥊', badge: 'new', stock: 180,
    specs: [ProductSpec(key:'Material',value:'Steel Cable'), ProductSpec(key:'Handle',value:'Aluminium CNC'), ProductSpec(key:'Panjang',value:'Adjustable 3m'), ProductSpec(key:'Bearing',value:'Presisi')],
    tags: ['jump','rope','speed','kardio'],
  ),
  ProductModel(
    id: '10', name: 'Power Rack Squat Cage', category: 'Bench & Rack',
    description: 'Power rack multifungsi untuk squat, bench press, dan pull-up. Baja tebal 2mm, kapasitas 500kg. Dilengkapi J-hook, safety bar, dan pull-up bar.',
    price: 4200000, originalPrice: 5000000, rating: 4.9, reviewCount: 62,
    imageEmoji: '⚙️', badge: 'sale', stock: 8,
    specs: [ProductSpec(key:'Material',value:'Steel 2mm'), ProductSpec(key:'Kapasitas',value:'500 kg'), ProductSpec(key:'Tinggi',value:'220 cm'), ProductSpec(key:'Lebar',value:'120 cm')],
    tags: ['rack','squat','powerrack'],
  ),
  ProductModel(
    id: '11', name: 'Kaos Gym Dri-Fit IronCore', category: 'Pakaian',
    description: 'Kaos gym dengan teknologi moisture-wicking yang menjaga tubuh tetap kering. Jahitan flatlock anti-lecet. Tersedia 6 warna.',
    price: 185000, originalPrice: 220000, rating: 4.5, reviewCount: 521,
    imageEmoji: '👕', badge: 'sale', stock: 300,
    specs: [ProductSpec(key:'Bahan',value:'Polyester 100%'), ProductSpec(key:'Teknologi',value:'Dri-Fit'), ProductSpec(key:'Ukuran',value:'S–3XL'), ProductSpec(key:'Warna',value:'6 Pilihan')],
    tags: ['kaos','gym','pakaian'],
  ),
  ProductModel(
    id: '12', name: 'Foam Roller Deep Tissue 45cm', category: 'Aksesoris',
    description: 'Foam roller bertekstur EPP density tinggi untuk pijat miofasial. Tahan beban hingga 200kg. Ideal untuk recovery pasca latihan.',
    price: 165000, rating: 4.6, reviewCount: 267,
    imageEmoji: '🫧', badge: 'new', stock: 95,
    specs: [ProductSpec(key:'Material',value:'EPP High Density'), ProductSpec(key:'Panjang',value:'45 cm'), ProductSpec(key:'Diameter',value:'14 cm'), ProductSpec(key:'Kapasitas',value:'200 kg')],
    tags: ['foam','roller','recovery','aksesoris'],
  ),
];
