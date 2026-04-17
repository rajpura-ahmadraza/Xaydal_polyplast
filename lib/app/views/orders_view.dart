import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/biz_controller.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class OrdersView extends GetView<BizController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = 0.obs;
    final fmt = NumberFormat('#,##,###', 'en_IN');
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tabs = ['All', 'Pending', 'Delivered', 'Cancelled'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark ? C.s800 : Colors.white,
        title: Text('Orders',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: C.g50, borderRadius: BorderRadius.circular(10)),
                  child: Text('${controller.orders.length} Total',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: C.g700,
                          fontWeight: FontWeight.w600)),
                ),
              )),
        ],
      ),
      body: Column(children: [
        // ── Tab Filter ────────────────────────────────────────
        Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                  children: List.generate(tabs.length, (i) {
                final sel = tab.value == i;
                return GestureDetector(
                  onTap: () => tab.value = i,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                    decoration: BoxDecoration(
                      color: sel ? C.g700 : (dark ? C.s750 : Colors.white),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                          color: sel ? C.g700 : (dark ? C.s700 : C.s300)),
                    ),
                    child: Text(tabs[i],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: sel ? Colors.white : (dark ? C.s400 : C.s600),
                        )),
                  ),
                );
              })),
            )),

        Expanded(child: Obx(() {
          final list = controller.orders.reversed.where((o) {
            if (tab.value == 0) return true;
            if (tab.value == 1) return o.status == 'pending';
            if (tab.value == 2) return o.status == 'delivered';
            return o.status == 'cancelled';
          }).toList();

          if (list.isEmpty) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 60, color: dark ? C.s600 : C.s400),
                  const SizedBox(height: 12),
                  Text('No orders found',
                      style: GoogleFonts.poppins(fontSize: 15, color: C.s500)),
                ]));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _card(list[i], fmt, dark, context),
          );
        })),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.addOrder),
        icon: const Icon(Icons.add_rounded),
        label: Text('New Order',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: C.g700,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _card(
      OrderModel o, NumberFormat fmt, bool dark, BuildContext context) {
    final isPending = o.status == 'pending';
    final isDelivered = o.status == 'delivered';
    final color = isDelivered
        ? C.green
        : isPending
            ? C.orange
            : C.red;
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(o.date);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? C.s750 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dark ? C.s700 : C.s200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(
              isDelivered
                  ? Icons.check_circle_rounded
                  : isPending
                      ? Icons.hourglass_top_rounded
                      : Icons.cancel_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(o.customerName,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                Text(o.customerPhone,
                    style: GoogleFonts.poppins(fontSize: 12, color: C.s500)),
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\u20B9${fmt.format(o.totalAmount.toInt())}',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700, color: C.g700)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(o.status[0].toUpperCase() + o.status.substring(1),
                  style: GoogleFonts.poppins(
                      fontSize: 11, fontWeight: FontWeight.w600, color: color)),
            ),
          ]),
        ]),
        const SizedBox(height: 12),
        Divider(height: 1, color: dark ? C.s700 : C.s200),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.inventory_2_outlined, size: 14, color: C.s500),
          const SizedBox(width: 4),
          Text('${o.quantity}× ${o.productName}',
              style: GoogleFonts.poppins(fontSize: 12, color: C.s600)),
          const Spacer(),
          const Icon(Icons.schedule_outlined, size: 14, color: C.s500),
          const SizedBox(width: 4),
          Text(dateStr,
              style: GoogleFonts.poppins(fontSize: 11, color: C.s500)),
        ]),
        if (o.notes != null && o.notes!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.notes_rounded, size: 14, color: C.s500),
            const SizedBox(width: 4),
            Expanded(
                child: Text(o.notes!,
                    style: GoogleFonts.poppins(fontSize: 12, color: C.s500))),
          ]),
        ],
        if (isPending) ...[
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: _btn('Mark as Delivered', C.green,
                    () => controller.markDelivered(o.id))),
            const SizedBox(width: 10),
            Expanded(
                child: _btn(
                    'Cancel Order', C.red, () => controller.cancelOrder(o.id),
                    outline: true)),
          ]),
        ],
      ]),
    );
  }

  void _confirmDialog({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String confirmLabel,
    required Color confirmColor,
    required IconData icon,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: confirmColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: confirmColor, size: 20),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 15)),
        ]),
        content: Text(subtitle,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Radd karo',
                style: GoogleFonts.poppins(color: Colors.grey[600])),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            icon: const Icon(Icons.send_rounded, size: 16),
            label: Text(confirmLabel,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(String label, Color color, VoidCallback onTap,
          {bool outline = false}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: outline ? Colors.transparent : color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color),
          ),
          child: Center(
              child: Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: outline ? color : Colors.white))),
        ),
      );
}
