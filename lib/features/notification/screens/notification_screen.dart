import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class NotifItem {
  final String id, icon, title, body, time;
  bool isRead;
  NotifItem({required this.id, required this.icon, required this.title,
      required this.body, required this.time, this.isRead = false});
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotifItem> _notifs = [
    NotifItem(id:'1', icon:'🔥', title:'Flash Sale Dimulai!',
        body:'Diskon hingga 40% untuk semua produk beban. Berlaku hari ini saja!', time:'5 menit lalu'),
    NotifItem(id:'2', icon:'📦', title:'Pesanan Dikirim',
        body:'Pesanan #IC-20241 telah dikirim via JNE. Estimasi tiba 2–3 hari.', time:'2 jam lalu'),
    NotifItem(id:'3', icon:'⭐', title:'Review Produk',
        body:'Bagaimana Dumbbell Hex Rubber yang kamu beli? Beri ulasan sekarang!', time:'1 hari lalu'),
    NotifItem(id:'4', icon:'🎁', title:'Voucher Baru',
        body:'Kamu punya voucher IRON50 senilai Rp50.000 yang akan expired besok.', time:'2 hari lalu', isRead: true),
    NotifItem(id:'5', icon:'🔔', title:'Restock Alert',
        body:'Barbell Olympic 20kg yang kamu wishlist sudah tersedia kembali!', time:'3 hari lalu', isRead: true),
  ];

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      appBar: AppBar(
        backgroundColor: AppTheme.bgSurface,
        title: const Text('Notifikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        automaticallyImplyLeading: false,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: () => setState(() {
                for (final n in _notifs) n.isRead = true;
              }),
              child: const Text('Tandai semua dibaca',
                  style: TextStyle(fontSize: 12, color: AppTheme.primary)),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.primary.withOpacity(0.08),
            child: Row(
              children: [
                const Icon(Icons.notifications_active_outlined,
                    size: 14, color: AppTheme.primary),
                const SizedBox(width: 6),
                Text(
                  'Firebase Cloud Messaging (FCM) — $_unreadCount notif belum dibaca',
                  style: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _notifs.isEmpty
          ? _buildEmpty()
          : ListView.separated(
              padding: const EdgeInsets.all(AppConstants.pagePad),
              itemCount: _notifs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _buildNotifCard(_notifs[i]),
            ),
    );
  }

  Widget _buildNotifCard(NotifItem notif) {
    return GestureDetector(
      onTap: () => setState(() => notif.isRead = true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppConstants.cardPad),
        decoration: BoxDecoration(
          color: notif.isRead ? AppTheme.bgCard : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: notif.isRead ? AppTheme.border : AppTheme.primary.withOpacity(0.4),
            width: notif.isRead ? 0.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: AppTheme.bgElement,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(notif.icon, style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notif.title,
                      style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700,
                        color: notif.isRead ? AppTheme.textSecondary : AppTheme.textPrimary,
                      )),
                  const SizedBox(height: 3),
                  Text(notif.body,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textHint, height: 1.5)),
                  const SizedBox(height: 6),
                  Text(notif.time,
                      style: const TextStyle(fontSize: 10, color: AppTheme.textHint,
                          fontFamily: 'Monospace')),
                ],
              ),
            ),

            // Unread dot
            if (!notif.isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: 8, height: 8, margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.notifications_off_outlined, size: 72, color: AppTheme.textHint),
        SizedBox(height: 16),
        Text('Belum ada notifikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        SizedBox(height: 8),
        Text('Notifikasi Firebase akan muncul di sini',
            style: TextStyle(fontSize: 14, color: AppTheme.textHint)),
      ],
    ),
  );
}
