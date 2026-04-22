import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/auth_service.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  bool _notifPromo    = true;
  bool _notifOrder    = true;
  bool _notifRestock  = false;
  bool _notifFlash    = true;

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final name = user?.displayName ?? 'IronCore User';
    final email = user?.email ?? 'demo@ironcore.id';
    final initials = _authService.initials;

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      appBar: AppBar(
        backgroundColor: AppTheme.bgSurface,
        title: const Text('Profil',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pagePad),
        children: [
          // ── Profile Header ───────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              border: Border.all(color: AppTheme.border, width: 0.5),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(initials,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      const SizedBox(height: 3),
                      Text(email, style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium_rounded, size: 12, color: AppTheme.gold),
                            SizedBox(width: 4),
                            Text('Member Premium', style: TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Stats ────────────────────────────────────────
          Row(
            children: [
              _statCard('3', 'Pesanan', AppTheme.primary),
              const SizedBox(width: 10),
              _statCard('5', 'Wishlist', AppTheme.gold),
              const SizedBox(width: 10),
              _statCard('4.9', 'Rating', AppTheme.green),
            ],
          ),
          const SizedBox(height: 20),

          // ── Auth Section ─────────────────────────────────
          _sectionTitle('Akun & Autentikasi'),
          _settingsSection([
            _settingRow(Icons.email_outlined, 'Metode Login',
                trailing: Text(user?.providerData.first.providerId == 'google.com'
                    ? 'Google Gmail' : 'Email & Password',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textHint))),
            _settingRow(Icons.verified_user_outlined, 'Firebase Auth',
                trailing: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle, size: 14, color: AppTheme.green),
                  SizedBox(width: 4),
                  Text('Terverifikasi', style: TextStyle(fontSize: 12, color: AppTheme.green)),
                ])),
            _settingRow(Icons.shield_outlined, 'Status Akun',
                trailing: const Text('Aktif', style: TextStyle(fontSize: 12, color: AppTheme.green))),
          ]),
          const SizedBox(height: 16),

          // ── FCM Settings ─────────────────────────────────
          _sectionTitle('Notifikasi Firebase (FCM)'),
          _settingsSection([
            _toggleRow(Icons.local_fire_department_outlined, 'Promo & Flash Sale', _notifFlash,
                (v) => setState(() => _notifFlash = v)),
            _toggleRow(Icons.inventory_2_outlined, 'Update Pesanan', _notifOrder,
                (v) => setState(() => _notifOrder = v)),
            _toggleRow(Icons.campaign_outlined, 'Notifikasi Umum', _notifPromo,
                (v) => setState(() => _notifPromo = v)),
            _toggleRow(Icons.replay_outlined, 'Restock Produk', _notifRestock,
                (v) => setState(() => _notifRestock = v)),
          ]),
          const SizedBox(height: 16),

          // ── Clean Code Info ──────────────────────────────
          _sectionTitle('Clean Code Architecture'),
          _settingsSection([
            _settingRow(Icons.folder_outlined, 'lib/features/auth, catalog, cart...'),
            _settingRow(Icons.account_tree_outlined, 'Pattern: Clean Architecture + BLoC'),
            _settingRow(Icons.recycling_outlined, 'Reusable Widgets: AppButton, AppInput, ProductCard'),
            _settingRow(Icons.code_outlined, 'Firebase: Auth + FCM + Firestore'),
          ]),
          const SizedBox(height: 24),

          // ── Logout ───────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _logout,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.primary.withOpacity(0.5)),
                backgroundColor: AppTheme.primary.withOpacity(0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.logout_rounded, color: AppTheme.primary, size: 18),
              label: const Text('LOGOUT',
                  style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text('${AppConstants.appName} v${AppConstants.appVersion}',
                style: const TextStyle(fontSize: 11, color: AppTheme.textHint)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textHint,
              letterSpacing: 0.5, fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textHint,
        fontWeight: FontWeight.w700, letterSpacing: 1)),
  );

  Widget _settingsSection(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: AppTheme.bgCard,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      border: Border.all(color: AppTheme.border, width: 0.5),
    ),
    child: Column(children: children),
  );

  Widget _settingRow(IconData icon, String label, {Widget? trailing}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
    ),
    child: Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Expanded(child: Text(label,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
        if (trailing != null) trailing,
      ],
    ),
  );

  Widget _toggleRow(IconData icon, String label, bool value, ValueChanged<bool> onChanged) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.textSecondary),
            const SizedBox(width: 12),
            Expanded(child: Text(label,
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.primary,
              inactiveThumbColor: AppTheme.textHint,
              inactiveTrackColor: AppTheme.bgElement,
            ),
          ],
        ),
      );

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        title: const Text('Logout', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text('Kamu yakin ingin keluar dari akun?',
            style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal', style: TextStyle(color: AppTheme.textHint))),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout', style: TextStyle(color: AppTheme.primary))),
        ],
      ),
    );
    if (confirm == true) {
      await _authService.logout();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }
}
