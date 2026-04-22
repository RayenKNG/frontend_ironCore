import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../widgets/app_button.dart';
import '../../catalog/models/product_model.dart';

class CartScreen extends StatefulWidget {
  final List<ProductModel> cartItems;
  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    for (final p in widget.cartItems) {
      _quantities[p.id] = 1;
    }
  }

  String _formatPrice(double price) =>
      'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  double get _subtotal => widget.cartItems.fold(
      0, (sum, p) => sum + p.price * (_quantities[p.id] ?? 1));

  int get _shippingCost =>
      _subtotal >= AppConstants.freeShippingMin ? 0 : AppConstants.shippingCost;

  double get _total => _subtotal + _shippingCost;

  @override
  Widget build(BuildContext context) {
    if (widget.cartItems.isEmpty) return _buildEmpty();

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      appBar: AppBar(
        backgroundColor: AppTheme.bgSurface,
        title: Text('Keranjang (${widget.cartItems.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // ── Cart items list ──────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppConstants.pagePad),
              itemCount: widget.cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _buildCartItem(widget.cartItems[i]),
            ),
          ),

          // ── Summary ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppConstants.pagePad),
            decoration: const BoxDecoration(
              color: AppTheme.bgSurface,
              border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
            ),
            child: Column(
              children: [
                _summaryRow('Subtotal', _formatPrice(_subtotal)),
                const SizedBox(height: 8),
                _summaryRow(
                  'Ongkos Kirim',
                  _shippingCost == 0 ? 'GRATIS' : _formatPrice(_shippingCost.toDouble()),
                  valueColor: _shippingCost == 0 ? AppTheme.green : null,
                ),
                const Divider(color: AppTheme.border, height: 20),
                _summaryRow('Total', _formatPrice(_total), isBold: true),
                const SizedBox(height: 14),
                AppButton(
                  label: 'CHECKOUT',
                  onPressed: _onCheckout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(ProductModel p) {
    final qty = _quantities[p.id] ?? 1;
    return Container(
      padding: const EdgeInsets.all(AppConstants.cardPad),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: AppTheme.bgElement,
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Center(child: Text(p.imageEmoji, style: const TextStyle(fontSize: 32))),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(p.category, style: const TextStyle(fontSize: 11, color: AppTheme.textHint)),
                const SizedBox(height: 6),
                Text(_formatPrice(p.price * qty),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.primary)),
              ],
            ),
          ),

          // Qty controls
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.bgBase,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _qtyButton(Icons.remove, () {
                      if (qty > 1) setState(() => _quantities[p.id] = qty - 1);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('$qty',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary)),
                    ),
                    _qtyButton(Icons.add, () => setState(() => _quantities[p.id] = qty + 1)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setState(() {
                  _quantities.remove(p.id);
                  widget.cartItems.remove(p);
                }),
                child: const Text('Hapus',
                    style: TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: AppTheme.bgElement,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: AppTheme.textSecondary),
    ),
  );

  Widget _summaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    final style = isBold
        ? const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)
        : const TextStyle(fontSize: 13, color: AppTheme.textSecondary);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value,
            style: style.copyWith(color: valueColor ?? (isBold ? AppTheme.primary : null))),
      ],
    );
  }

  void _onCheckout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Pesanan berhasil diproses!'),
          ],
        ),
        backgroundColor: AppTheme.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildEmpty() => Scaffold(
    backgroundColor: AppTheme.bgBase,
    appBar: AppBar(
      backgroundColor: AppTheme.bgSurface,
      title: const Text('Keranjang'),
      automaticallyImplyLeading: false,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 72, color: AppTheme.textHint),
          const SizedBox(height: 16),
          const Text('Keranjang kosong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          const Text('Tambahkan produk dari katalog',
              style: TextStyle(fontSize: 14, color: AppTheme.textHint)),
        ],
      ),
    ),
  );
}
