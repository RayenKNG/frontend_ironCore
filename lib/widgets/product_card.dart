import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../features/catalog/models/product_model.dart';

/// Reusable product card displayed in the catalog grid.
class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _added = false;

  String _formatPrice(double price) =>
      'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final stockPct = (p.stock / 300).clamp(0.0, 1.0);
    final stockColor = p.isLowStock
        ? AppTheme.primary
        : p.stock <= 50
            ? AppTheme.gold
            : AppTheme.green;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Area ─────────────────────────────────
            Stack(
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.bgElement,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                  ),
                  child: Center(
                    child: Text(p.imageEmoji, style: const TextStyle(fontSize: 64)),
                  ),
                ),
                // Badge
                if (p.badge.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildBadge(p.badge),
                  ),
              ],
            ),

            // ── Body ───────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Text(p.category,
                        style: const TextStyle(fontSize: 9, color: AppTheme.primary,
                            fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                    const SizedBox(height: 3),

                    // Name
                    Text(p.name,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary, height: 1.3),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 12, color: AppTheme.gold),
                        const SizedBox(width: 2),
                        Text('${p.rating}',
                            style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 3),
                        Text('(${p.reviewCount})',
                            style: const TextStyle(fontSize: 10, color: AppTheme.textHint)),
                      ],
                    ),

                    // Stock bar
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Stok ${p.stock}',
                            style: const TextStyle(fontSize: 9, color: AppTheme.textHint)),
                        if (p.isLowStock)
                          const Text('Hampir habis!',
                              style: TextStyle(fontSize: 9, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: stockPct,
                        backgroundColor: AppTheme.bgBase,
                        color: stockColor,
                        minHeight: 3,
                      ),
                    ),

                    const Spacer(),

                    // ── Price + Add Button ────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (p.originalPrice != null)
                                Text(_formatPrice(p.originalPrice!),
                                    style: const TextStyle(fontSize: 10, color: AppTheme.textHint,
                                        decoration: TextDecoration.lineThrough)),
                              Text(_formatPrice(p.price),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                                      color: AppTheme.textPrimary)),
                            ],
                          ),
                        ),
                        // Add to cart button
                        GestureDetector(
                          onTap: () {
                            widget.onAddToCart();
                            setState(() => _added = true);
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) setState(() => _added = false);
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: _added ? AppTheme.green : AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _added ? Icons.check_rounded : Icons.add_rounded,
                              color: Colors.white, size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String badge) {
    final colors = {
      'sale': AppTheme.primary, 'hot': AppTheme.orange,
      'new': AppTheme.gold, 'limited': AppTheme.textHint,
    };
    final labels = {'sale': 'SALE', 'hot': 'HOT', 'new': 'NEW', 'limited': 'LIMITED'};
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: colors[badge] ?? AppTheme.textHint,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(labels[badge] ?? '',
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
              color: Colors.white, letterSpacing: 0.8)),
    );
  }
}
