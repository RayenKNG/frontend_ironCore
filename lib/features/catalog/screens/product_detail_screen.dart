import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../widgets/app_button.dart';
import '../models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isWishlisted = false;
  bool _addedToCart  = false;

  ProductModel get p => widget.product;

  String _formatPrice(double price) =>
      'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: CustomScrollView(
        slivers: [
          // ── Hero Image ───────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.bgCard,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.bgBase.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppTheme.textPrimary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.bgBase.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isWishlisted ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: _isWishlisted ? AppTheme.primary : AppTheme.textPrimary,
                  ),
                ),
                onPressed: () => setState(() => _isWishlisted = !_isWishlisted),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppTheme.bgCard,
                child: Center(
                  child: Text(p.imageEmoji, style: const TextStyle(fontSize: 120)),
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.pagePad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + Badge
                  Row(
                    children: [
                      Text(p.category,
                          style: const TextStyle(fontSize: 11, color: AppTheme.primary,
                              fontWeight: FontWeight.w700, letterSpacing: 1)),
                      const Spacer(),
                      if (p.badge.isNotEmpty) _buildBadge(p.badge),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Product name
                  Text(p.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary, height: 1.3)),
                  const SizedBox(height: 10),

                  // Rating row
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(
                        i < p.rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 18, color: AppTheme.gold,
                      )),
                      const SizedBox(width: 6),
                      Text('${p.rating}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      const SizedBox(width: 4),
                      Text('(${p.reviewCount} ulasan)',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  if (p.originalPrice != null)
                    Text(_formatPrice(p.originalPrice!),
                        style: const TextStyle(fontSize: 13, color: AppTheme.textHint,
                            decoration: TextDecoration.lineThrough)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_formatPrice(p.price),
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary)),
                      if (p.discountPercent > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('Hemat ${p.discountPercent.toInt()}%',
                              style: const TextStyle(fontSize: 11, color: AppTheme.green, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Stock indicator
                  _buildStockIndicator(),
                  const SizedBox(height: 20),

                  // Description
                  const Text('Deskripsi Produk',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                  const SizedBox(height: 8),
                  Text(p.description,
                      style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.7)),
                  const SizedBox(height: 20),

                  // Specs grid
                  const Text('Spesifikasi',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.8,
                    children: p.specs.map(_buildSpecCard).toList(),
                  ),
                  const SizedBox(height: 80), // bottom padding for FAB
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Bar ───────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: AppTheme.bgSurface,
          border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
        ),
        child: Row(
          children: [
            // Wishlist button
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.border),
              ),
              child: IconButton(
                icon: Icon(
                  _isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: _isWishlisted ? AppTheme.primary : AppTheme.textSecondary,
                ),
                onPressed: () => setState(() => _isWishlisted = !_isWishlisted),
              ),
            ),
            const SizedBox(width: 12),
            // Add to cart
            Expanded(
              child: AppButton(
                label: _addedToCart ? 'DITAMBAHKAN ✓' : '+ KERANJANG',
                onPressed: p.isOutOfStock ? null : () {
                  widget.onAddToCart();
                  setState(() => _addedToCart = true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String badge) {
    final colors = {
      'sale': AppTheme.primary,
      'hot': AppTheme.orange,
      'new': AppTheme.gold,
      'limited': AppTheme.textHint,
    };
    final labels = {'sale': 'SALE', 'hot': 'HOT', 'new': 'NEW', 'limited': 'LIMITED'};
    final color = colors[badge] ?? AppTheme.textHint;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(labels[badge] ?? badge.toUpperCase(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1)),
    );
  }

  Widget _buildStockIndicator() {
    final pct = (p.stock / 300).clamp(0.0, 1.0);
    final color = p.isLowStock ? AppTheme.primary : p.stock <= 50 ? AppTheme.gold : AppTheme.green;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Stok tersedia', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
            Text('${p.stock} unit${p.isLowStock ? " — Hampir habis!" : ""}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: pct, backgroundColor: AppTheme.bgElement,
            color: color, minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecCard(ProductSpec spec) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(spec.key, style: const TextStyle(fontSize: 9, color: AppTheme.textHint,
              fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 2),
          Text(spec.value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}
