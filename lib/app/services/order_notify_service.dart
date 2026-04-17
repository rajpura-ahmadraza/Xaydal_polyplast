// ════════════════════════════════════════════════════════════════
//  ORDER NOTIFY SERVICE
//  • WhatsApp message customer ne moke
//  • Device pr local notification banavti hai
// ════════════════════════════════════════════════════════════════
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderNotifyService {
  OrderNotifyService._();
  static final OrderNotifyService instance = OrderNotifyService._();

  final _fln = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // ── Initialise (call once from main.dart or binding) ─────────
  Future<void> init() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _fln.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    // Android 13+ → permission request
    if (Platform.isAndroid) {
      final plugin = _fln
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await plugin?.requestNotificationsPermission();
    }

    _initialized = true;
  }

  // ── Show device notification ──────────────────────────────────
  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    Color color = const Color(0xFF4A7C59),
  }) async {
    final android = AndroidNotificationDetails(
      'order_channel',
      'Order Updates',
      channelDescription: 'Order status notifications',
      importance: Importance.high,
      priority: Priority.high,
      color: color,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(body),
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _fln.show(id, title, body,
        NotificationDetails(android: android, iOS: ios));
  }

  // ══════════════════════════════════════════════════════════════
  //  PUBLIC METHODS — call from BizController
  // ══════════════════════════════════════════════════════════════

  /// Called after order is successfully added
  Future<void> onOrderPlaced({
    required String customerName,
    required String customerPhone,
    required String productName,
    required int quantity,
    required double totalAmount,
  }) async {
    // 1. Device notification
    await _showNotification(
      id: 1001,
      title: '🛒 New Order — $customerName',
      body:
          '$quantity× $productName  |  ₹${totalAmount.toInt()}\nPhone: $customerPhone',
      color: const Color(0xFF4A7C59),
    );

    // 2. WhatsApp message dialog
    final msg = '''🛒 *Order Confirmation*

Namaste ${_firstName(customerName)} bhai/ben! 🙏

Tamaro order confirm thaio che:
• Product: *$productName*
• Quantity: *$quantity pcs*
• Total: *₹${totalAmount.toInt()}*

Tame jaldi j aapno order receive karso.
Koi saval hoy to contact karo. 😊

— *Xyadal Bucket*''';

    _showWhatsAppDialog(
      phone: customerPhone,
      message: msg,
      title: 'Order Confirmation',
      subtitle: 'Customer ne WhatsApp message karvu?',
      icon: Icons.shopping_cart_rounded,
      color: const Color(0xFF25D366),
    );
  }

  /// Called after order is marked as delivered
  Future<void> onOrderDelivered({
    required String customerName,
    required String customerPhone,
    required String productName,
    required int quantity,
    required double totalAmount,
  }) async {
    await _showNotification(
      id: 1002,
      title: '✅ Delivered — $customerName',
      body: '$quantity× $productName  |  ₹${totalAmount.toInt()}',
      color: const Color(0xFF2196F3),
    );

    final msg = '''✅ *Order Delivered!*

Namaste ${_firstName(customerName)} bhai/ben! 🙏

Tamaro order *deliver* thay gayo che!

• Product: *$productName*
• Quantity: *$quantity pcs*
• Total: *₹${totalAmount.toInt()}*

Amaro product gamyo to tamaara mitro ne pan janaavo! 🙏
Avar pachi pan order karvano aavjo.

— *Xyadal Bucket*''';

    _showWhatsAppDialog(
      phone: customerPhone,
      message: msg,
      title: 'Order Delivered',
      subtitle: 'Customer ne delivery ni jaankari moko?',
      icon: Icons.local_shipping_rounded,
      color: const Color(0xFF2196F3),
    );
  }

  /// Called after order is cancelled
  Future<void> onOrderCancelled({
    required String customerName,
    required String customerPhone,
    required String productName,
    required int quantity,
  }) async {
    await _showNotification(
      id: 1003,
      title: '❌ Cancelled — $customerName',
      body: '$quantity× $productName order cancel thayo',
      color: const Color(0xFFE53935),
    );

    final msg = '''❌ *Order Cancelled*

Namaste ${_firstName(customerName)} bhai/ben! 🙏

Dukhh sathe janaavie che ke tamaro order *cancel* thayo che.

• Product: *$productName*
• Quantity: *$quantity pcs*

Jaro koi problem hoi to ame madad karva taiyar chie. 
Please contact karo. 🙏

— *Xyadal Bucket*''';

    _showWhatsAppDialog(
      phone: customerPhone,
      message: msg,
      title: 'Order Cancelled',
      subtitle: 'Customer ne cancellation jaankar moko?',
      icon: Icons.cancel_rounded,
      color: const Color(0xFFE53935),
    );
  }

  // ── WhatsApp dialog ──────────────────────────────────────────
  void _showWhatsAppDialog({
    required String phone,
    required String message,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // ── Header ──────────────────────────────────────
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      Text(subtitle,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ]),
              ),
            ]),

            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ── Message preview ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDCF8C6), // WhatsApp bubble green
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                style: const TextStyle(fontSize: 12, height: 1.5, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 16),

            // ── Buttons ──────────────────────────────────────
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Skip', style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    _launchWhatsApp(phone: phone, message: message);
                  },
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('WhatsApp moko',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  // ── Launch WhatsApp ──────────────────────────────────────────
  Future<void> _launchWhatsApp({
    required String phone,
    required String message,
  }) async {
    // Normalize phone: strip non-digits, add 91 if needed
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    final withCode =
        cleaned.startsWith('91') && cleaned.length == 12 ? cleaned : '91$cleaned';

    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$withCode?text=$encoded');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'WhatsApp nathi',
        'Device par WhatsApp install nathi',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String _firstName(String name) => name.trim().split(' ').first;
}
