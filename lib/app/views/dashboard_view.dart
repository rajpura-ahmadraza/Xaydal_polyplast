import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/biz_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class DashboardView extends GetView<BizController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##,###', 'en_IN');
    final auth = Get.find<AuthController>();
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Obx(() => CustomScrollView(slivers: [
            // ── Premium SliverAppBar ──────────────────────────────
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: dark ? C.s800 : C.g700,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: dark
                          ? [C.s800, C.s900]
                          : [C.g600, const Color(0xFF8A6A00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(top: -40, right: -40, child: _ring(180, 0.06)),
                    Positioned(bottom: 0, left: -20, child: _ring(110, 0.05)),
                    SafeArea(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(children: [
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Obx(() => Text(
                                        'Hello, ${auth.userName.value.isEmpty ? 'Owner' : auth.userName.value} 👋',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.white70))),
                                    Obx(() => Text(
                                        auth.userBiz.value.isEmpty
                                            ? 'Plastic Business'
                                            : auth.userBiz.value,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white))),
                                  ])),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                      colors: [C.g300, C.g500]),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 2),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.12)),
                              ),
                              child: Row(children: [
                                const Icon(Icons.trending_up_rounded,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                    'This Month: \u20B9${fmt.format(controller.monthEarning.toInt())}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.greenAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text('+12%',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ]),
                            ),
                          ]),
                    )),
                  ]),
                ),
              ),
              title: Text('Dashboard',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17)),
              actions: [
                IconButton(
                    icon: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white),
                    onPressed: () {}),
              ],
            ),

            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Metric Cards ──────────────────────────────────
                    Row(children: [
                      _metric(
                          "Today's Earning",
                          '\u20B9${fmt.format(controller.todayEarning.toInt())}',
                          Icons.today_rounded,
                          C.g700,
                          dark),
                      const SizedBox(width: 12),
                      _metric('Total Orders', '${controller.orders.length}',
                          Icons.receipt_long_rounded, C.teal, dark),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      _metric('Pending Orders', '${controller.pendingCount}',
                          Icons.hourglass_top_rounded, C.orange, dark),
                      const SizedBox(width: 12),
                      _metric('Customers', '${controller.customers.length}',
                          Icons.people_rounded, C.indigo, dark),
                    ]),

                    // ── Low Stock Alert ───────────────────────────────
                    if (controller.lowStock.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: C.orangeBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: C.orange.withOpacity(0.3)),
                        ),
                        child: Row(children: [
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: C.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.warning_amber_rounded,
                                  color: C.orange, size: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('Low Stock Alert!',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: C.orange)),
                                Text(
                                    controller.lowStock
                                        .map((p) =>
                                            '${p.name} (${p.stock} left)')
                                        .join(', '),
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: C.orange),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2),
                              ])),
                        ]),
                      ),
                    ],

                    // ── Quick Actions ─────────────────────────────────
                    const SizedBox(height: 22),
                    Text('Quick Actions',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(children: [
                      _action('New Order', Icons.add_shopping_cart_rounded,
                          C.g700, () => Get.toNamed(AppRoutes.addOrder), dark),
                      const SizedBox(width: 10),
                      _action('Add Product', Icons.add_box_rounded, C.teal,
                          () => Get.toNamed(AppRoutes.addProduct), dark),
                      const SizedBox(width: 10),
                      _action(
                          'Add Customer',
                          Icons.person_add_rounded,
                          C.indigo,
                          () => Get.toNamed(AppRoutes.addCustomer),
                          dark),
                    ]),

                    // ── Stock Overview ────────────────────────────────
                    const SizedBox(height: 22),
                    _sectionHeader('Stock Overview', 'View All'),
                    const SizedBox(height: 12),
                    ...controller.products.map((p) => _productRow(p, dark)),

                    // ── Recent Orders ─────────────────────────────────
                    const SizedBox(height: 22),
                    _sectionHeader('Recent Orders', 'View All'),
                    const SizedBox(height: 12),
                    ...controller.recent.map((o) => _orderRow(o, fmt, dark)),
                  ]),
            )),
          ])),
    );
  }

  Widget _metric(
          String label, String value, IconData icon, Color color, bool dark) =>
      Expanded(
          child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? C.s750 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: dark ? C.s700 : C.s200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18)),
            const Spacer(),
            Container(
                width: 6,
                height: 6,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
          ]),
          const SizedBox(height: 12),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 21, fontWeight: FontWeight.w700)),
          Text(label, style: GoogleFonts.poppins(fontSize: 11, color: C.s500)),
        ]),
      ));

  Widget _action(String label, IconData icon, Color color, VoidCallback onTap,
          bool dark) =>
      Expanded(
          child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: dark ? C.s750 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: dark ? C.s700 : C.s200),
          ),
          child: Column(children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 22)),
            const SizedBox(height: 6),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 11, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ]),
        ),
      ));

  Widget _sectionHeader(String title, String action) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          Text(action,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: C.g700, fontWeight: FontWeight.w500)),
        ],
      );

  Widget _productRow(ProductModel p, bool dark) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: dark ? C.s750 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: dark ? C.s700 : C.s200),
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [C.g200, C.g100]),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Center(child: Text('🪣', style: TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(p.name,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 4),
                ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (p.stock / (p.minStock * 5)).clamp(0.0, 1.0),
                      minHeight: 5,
                      backgroundColor: dark ? C.s700 : C.s200,
                      valueColor: AlwaysStoppedAnimation(
                          p.isLowStock ? C.orange : C.g700),
                    )),
                const SizedBox(height: 2),
                Text('${p.stock} pcs  ·  \u20B9${p.price.toInt()}/pc',
                    style: GoogleFonts.poppins(fontSize: 11, color: C.s500)),
              ])),
          const SizedBox(width: 10),
          _chip(p.isLowStock ? 'Low' : 'OK', p.isLowStock ? C.orange : C.green),
        ]),
      );

  Widget _orderRow(OrderModel o, NumberFormat fmt, bool dark) {
    final delivered = o.status == 'delivered';
    final color = delivered
        ? C.green
        : o.status == 'pending'
            ? C.orange
            : C.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: dark ? C.s750 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dark ? C.s700 : C.s200),
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(
              delivered ? Icons.check_circle_rounded : Icons.pending_rounded,
              color: color,
              size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(o.customerName,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 14)),
          Text('${o.quantity}× ${o.productName}',
              style: GoogleFonts.poppins(fontSize: 12, color: C.s500)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('\u20B9${fmt.format(o.totalAmount.toInt())}',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w700, color: C.g700)),
          _chip(o.status[0].toUpperCase() + o.status.substring(1), color),
        ]),
      ]),
    );
  }

  Widget _chip(String t, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
        child: Text(t,
            style: GoogleFonts.poppins(
                fontSize: 11, fontWeight: FontWeight.w600, color: c)),
      );

  Widget _ring(double size, double opacity) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: Colors.white.withOpacity(opacity), width: 1)));
}
