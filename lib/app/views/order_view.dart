import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/dashboard_controller.dart';
import '../models/order_model.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class OrderView extends GetView<DashboardController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = 0.obs;
    final fmt = NumberFormat('#,##,###', 'en_IN');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('ઓર્ડર',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.pendingOrdersCount} pending',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
        ],
      ),
      body: Column(children: [
        // Tab pills
        Obx(() => Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(children: [
                _pill('બધા', 0, selectedTab),
                const SizedBox(width: 8),
                _pill('Pending', 1, selectedTab),
                const SizedBox(width: 8),
                _pill('Delivered', 2, selectedTab),
              ]),
            )),

        Expanded(
          child: Obx(() {
            List<OrderModel> list;
            switch (selectedTab.value) {
              case 1:
                list = controller.orders
                    .where((o) => o.status == 'pending')
                    .toList()
                    .reversed
                    .toList();
                break;
              case 2:
                list = controller.orders
                    .where((o) => o.status == 'delivered')
                    .toList()
                    .reversed
                    .toList();
                break;
              default:
                list = controller.orders.reversed.toList();
            }

            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.dark.primaryColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.receipt_long_outlined,
                          size: 48, color: AppTheme.dark.primaryColor),
                    ),
                    const SizedBox(height: 16),
                    Text('કોઈ ઓર્ડર નથી',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    Text('+ બટન થી નવો ઓર્ડર ઉમેરો',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.grey.shade500)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: list.length,
              itemBuilder: (_, i) => _orderCard(list[i], fmt, isDark),
            );
          }),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.addOrder),
        icon: const Icon(Icons.add_rounded),
        label: Text('નવો ઓર્ડર',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.dark.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _pill(String label, int idx, RxInt selected) {
    final active = selected.value == idx;
    return GestureDetector(
      onTap: () => selected.value = idx,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: active ? AppTheme.dark.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          // border: Border.all(
          //     color: active
          //         ? AppTheme.primaryColor
          //         : Colors.grey.withOpacity(0.3)),
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: active ? Colors.white : Colors.grey.shade600)),
      ),
    );
  }

  Widget _orderCard(OrderModel o, NumberFormat fmt, bool isDark) {
    final isDelivered = o.status == 'delivered';
    final dateStr = DateFormat('dd MMM, hh:mm a').format(o.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.dark.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color:
                isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.dark.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Text(
                  o.customerName.isNotEmpty
                      ? o.customerName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.dark.primaryColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.customerName,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(o.customerPhone,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey.shade500)),
                  ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('₹${fmt.format(o.totalAmount.toInt())}',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.dark.primaryColor)),
              Text(dateStr,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: Colors.grey.shade400)),
            ]),
          ]),
        ),

        // Divider + bottom action row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color:
                isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.dark.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('${o.quantity}× ${o.productName}',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppTheme.dark.primaryColor)),
            ),
            const Spacer(),
            if (!isDelivered)
              GestureDetector(
                onTap: () => controller.markOrderDelivered(o.id),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Deliver ✓',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('✓ Delivered',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500)),
              ),
          ]),
        ),
      ]),
    );
  }
}
