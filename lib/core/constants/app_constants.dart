class AppConstants {
  // App Info
  static const String appName    = 'IronCore Gym Store';
  static const String appVersion = '2.0.0';
  static const String appTagline = 'Gym Equipment Marketplace';

  // Categories
  static const List<String> categories = [
    'Semua', 'Beban', 'Kardio', 'Aksesoris', 'Bench & Rack', 'Pakaian',
  ];

  // Firebase Collections
  static const String colProducts = 'products';
  static const String colUsers    = 'users';
  static const String colOrders   = 'orders';

  // Free shipping threshold
  static const int freeShippingMin = 300000;
  static const int shippingCost    = 25000;

  // Padding
  static const double pagePad  = 16.0;
  static const double cardPad  = 14.0;
  static const double gapSm    = 8.0;
  static const double gapMd    = 12.0;
  static const double gapLg    = 20.0;
  static const double radiusLg = 14.0;
  static const double radiusMd = 10.0;
  static const double radiusSm = 7.0;
}
