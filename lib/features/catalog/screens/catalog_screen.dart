import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/search_input.dart';
import '../../../widgets/category_chip.dart';
import '../models/product_model.dart';
import 'product_detail_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../notification/screens/notification_screen.dart';
import '../../profile/screens/profile_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int _navIndex          = 0;
  String _selectedCat    = 'Semua';
  String _searchQuery    = '';
  String _sortBy         = 'default';
  int _cartCount         = 0;
  List<ProductModel> _cartItems = [];

  List<ProductModel> get _filteredProducts {
    List<ProductModel> list = dummyProducts.where((p) {
      final matchCat = _selectedCat == 'Semua' || p.category == _selectedCat;
      final q = _searchQuery.toLowerCase();
      final matchQ = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.tags.any((t) => t.contains(q));
      return matchCat && matchQ;
    }).toList();

    switch (_sortBy) {
      case 'price-asc':  list.sort((a, b) => a.price.compareTo(b.price)); break;
      case 'price-desc': list.sort((a, b) => b.price.compareTo(a.price)); break;
      case 'rating':     list.sort((a, b) => b.rating.compareTo(a.rating)); break;
      case 'name':       list.sort((a, b) => a.name.compareTo(b.name)); break;
    }
    return list;
  }

  void _addToCart(ProductModel product) {
    setState(() {
      final existing = _cartItems.indexWhere((p) => p.id == product.id);
      if (existing == -1) _cartItems.add(product);
      _cartCount = _cartItems.length;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text('${product.name} ditambahkan ke keranjang')),
          ],
        ),
        backgroundColor: AppTheme.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: IndexedStack(
        index: _navIndex,
        children: [
          _buildCatalogPage(),
          CartScreen(cartItems: _cartItems),
          const NotificationScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Bottom Navigation ────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgSurface,
        border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textHint,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('$_cartCount'),
              isLabelVisible: _cartCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            label: 'Keranjang',
          ),
          const BottomNavigationBarItem(
            icon: Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
            label: 'Notifikasi',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // ── Catalog Page ─────────────────────────────────────────
  Widget _buildCatalogPage() {
    final products = _filteredProducts;

    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        // AppBar
        SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: AppTheme.bgSurface,
          title: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.5),
              children: [
                TextSpan(text: 'IRON', style: TextStyle(color: Colors.white)),
                TextSpan(text: 'CORE', style: TextStyle(color: AppTheme.primary)),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune_rounded, color: AppTheme.textSecondary),
              onPressed: _showSortSheet,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: SearchInput(
                    hint: 'Cari produk gym...',
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                // Category chips
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: AppConstants.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (_, i) {
                      final cat = AppConstants.categories[i];
                      return CategoryChip(
                        label: cat,
                        selected: _selectedCat == cat,
                        onTap: () => setState(() => _selectedCat = cat),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
      body: products.isEmpty
          ? _buildEmpty()
          : GridView.builder(
              padding: const EdgeInsets.all(AppConstants.pagePad),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 0.62,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (_, i) => ProductCard(
                product: products[i],
                onTap: () => _openDetail(products[i]),
                onAddToCart: () => _addToCart(products[i]),
              ),
            ),
    );
  }

  void _openDetail(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
          onAddToCart: () => _addToCart(product),
        ),
      ),
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off_rounded, size: 64, color: AppTheme.textHint),
        const SizedBox(height: 16),
        const Text('Produk tidak ditemukan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        const SizedBox(height: 8),
        Text('Coba kata kunci lain atau ubah filter',
            style: TextStyle(fontSize: 14, color: AppTheme.textHint)),
      ],
    ),
  );

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        final options = [
          ('default', 'Default'), ('price-asc', 'Harga Terendah'),
          ('price-desc', 'Harga Tertinggi'), ('rating', 'Rating Terbaik'), ('name', 'Nama A–Z'),
        ];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Urutkan Produk',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const SizedBox(height: 16),
              ...options.map((opt) => ListTile(
                dense: true,
                title: Text(opt.$2, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
                trailing: _sortBy == opt.$1
                    ? const Icon(Icons.check_rounded, color: AppTheme.primary)
                    : null,
                onTap: () {
                  setState(() => _sortBy = opt.$1);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }
}
