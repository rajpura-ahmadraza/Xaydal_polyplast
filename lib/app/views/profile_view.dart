import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:plastic_business_app/app/views/full_screen.dart';
import '../controllers/biz_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class ProfileView extends GetView<BizController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##,###', 'en_IN');
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tc = Get.find<ThemeController>();
    final auth = Get.find<AuthController>();
    final tab = 0.obs;
    final tabs = ['Reports', 'Catalog', 'Settings'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark ? C.s800 : Colors.white,
        title: Text('Profile',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: tc.toggle,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: dark ? C.s700 : C.s100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: dark ? C.s600 : C.s200),
                    ),
                    child: Icon(
                        tc.isDark.value
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: C.g700,
                        size: 20),
                  ),
                ),
              )),
        ],
      ),
      body: Column(children: [
        // Profile Card
        Obx(() => Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: dark
                      ? [C.s800, C.s700]
                      : [C.g600, const Color(0xFF8A6A00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(children: [
                Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5), width: 2)),
                    child: const Center(
                        child: Text('👑', style: TextStyle(fontSize: 26)))),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                          auth.userName.value.isEmpty
                              ? 'Business Owner'
                              : auth.userName.value,
                          style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text(
                          auth.userBiz.value.isEmpty
                              ? 'Plastic Business'
                              : auth.userBiz.value,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white70)),
                      Text(auth.userEmail.value,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: Colors.white60)),
                    ])),
              ]),
            )),

        // Tabs
        Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                  children: List.generate(tabs.length, (i) {
                final sel = tab.value == i;
                return Expanded(
                    child: GestureDetector(
                  onTap: () => tab.value = i,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: sel ? C.g700 : (dark ? C.s750 : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: sel ? C.g700 : (dark ? C.s700 : C.s200)),
                    ),
                    child: Center(
                        child: Text(tabs[i],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  sel ? Colors.white : (dark ? C.s400 : C.s600),
                            ))),
                  ),
                ));
              })),
            )),
        const SizedBox(height: 12),

        Expanded(child: Obx(() {
          if (tab.value == 0) return _reportsTab(dark, fmt, tc);
          if (tab.value == 1) return _catalogTab(dark, auth);
          return _settingsTab(dark, tc, auth);
        })),
      ]),
    );
  }

  // ── Reports Tab ──────────────────────────────────────────────
  Widget _reportsTab(bool dark, NumberFormat fmt, ThemeController tc) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    return Obx(() => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Row(children: [
              _stat(
                  'Total Revenue',
                  '\u20B9${fmt.format(controller.totalEarning.toInt())}',
                  Icons.account_balance_wallet_rounded,
                  C.g700,
                  dark),
              const SizedBox(width: 12),
              _stat('Delivered', '${controller.deliveredCount}',
                  Icons.task_alt_rounded, C.green, dark),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              _stat('Total Orders', '${controller.orders.length}',
                  Icons.receipt_long_rounded, C.teal, dark),
              const SizedBox(width: 12),
              _stat(
                  'This Month',
                  '\u20B9${fmt.format(controller.monthEarning.toInt())}',
                  Icons.trending_up_rounded,
                  C.indigo,
                  dark),
            ]),
            const SizedBox(height: 20),
            Text('Weekly Earnings',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Container(
              height: 180,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: dark ? C.s750 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: dark ? C.s700 : C.s200)),
              child: BarChart(BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY:
                    (controller.weeklyEarnings.reduce((a, b) => a > b ? a : b) *
                            1.3)
                        .clamp(500.0, double.infinity),
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (v, _) => Text(days[v.toInt()],
                              style: GoogleFonts.poppins(
                                  fontSize: 9, color: C.s500)))),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (v, _) => Text(
                              '\u20B9${(v / 1000).toStringAsFixed(0)}k',
                              style: GoogleFonts.poppins(
                                  fontSize: 9, color: C.s500)))),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: dark ? C.s700 : C.s200, strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (i) {
                  final val = controller.weeklyEarnings[i];
                  return BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: val == 0 ? 0.01 : val,
                      width: 20,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(6)),
                      gradient: LinearGradient(
                          colors: val > 0 ? [C.g400, C.g700] : [C.s300, C.s300],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    )
                  ]);
                }),
              )),
            ),
            const SizedBox(height: 20),
            Text('Monthly Orders',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Container(
              height: 180,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: dark ? C.s750 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: dark ? C.s700 : C.s200)),
              child: LineChart(LineChartData(
                minY: 0,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (v, _) => Text(
                              months[v.toInt().clamp(0, 5)],
                              style: GoogleFonts.poppins(
                                  fontSize: 9, color: C.s500)))),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          getTitlesWidget: (v, _) => Text('${v.toInt()}',
                              style: GoogleFonts.poppins(
                                  fontSize: 9, color: C.s500)))),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: dark ? C.s700 : C.s200, strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                        6,
                        (i) => FlSpot(i.toDouble(),
                            controller.monthlyOrderCount[i].toDouble())),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: C.g700,
                    barWidth: 3,
                    dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                            radius: 4,
                            color: C.g700,
                            strokeWidth: 2,
                            strokeColor: Colors.white)),
                    belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                            colors: [
                              C.g400.withOpacity(0.25),
                              C.g400.withOpacity(0.0)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  )
                ],
              )),
            ),
            const SizedBox(height: 80),
          ],
        ));
  }

  Widget _catalogTab(bool dark, AuthController auth) {
    return StreamBuilder<List<BrochureItem>>(
      stream: controller.brochureStream(),
      builder: (ctx, snap) {
        final items = snap.data ?? [];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                Expanded(
                    child: Text('Bucket Catalog',
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600))),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.addBrochure),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text('Add',
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            if (snap.connectionState == ConnectionState.waiting)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (items.isEmpty)
              const Expanded(child: Center(child: Text("No catalog items yet")))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (_, i) => _catalogCard(items[i], dark),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                ),
              ),
          ]),
        );
      },
    );
  }

  Widget _catalogCard(BrochureItem item, bool dark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? C.s750 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dark ? C.s700 : C.s200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image & Name row
        Row(children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: dark ? C.s700 : C.g50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dark ? C.s600 : C.g200),
            ),

            /// ✅ IMAGE CLICK + FULL SCREEN FIX
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      Get.to(() => FullScreenImage(imagePath: item.imageUrl!));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: item.imageUrl!.startsWith('http')
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child:
                                    Text('🪣', style: TextStyle(fontSize: 30)),
                              ),
                            )
                          : Image.file(
                              File(item.imageUrl!),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child:
                                    Text('🪣', style: TextStyle(fontSize: 30)),
                              ),
                            ),
                    ),
                  )
                : const Center(
                    child: Text('🪣', style: TextStyle(fontSize: 36)),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.bucketName,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 16)),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [C.g500, C.g700]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${item.sizeInLiters} Litres',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
                const SizedBox(height: 4),
                Text('Material: ${item.material ?? 'HDPE Plastic'}',
                    style: GoogleFonts.poppins(fontSize: 11, color: C.s500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\u20B9${item.sellingPrice.toInt()}',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: C.g700)),
              Text('per piece',
                  style: GoogleFonts.poppins(fontSize: 11, color: C.s500)),
            ],
          ),
        ]),

        const SizedBox(height: 14),
        Divider(height: 1, color: dark ? C.s700 : C.s200),
        const SizedBox(height: 12),

        // Specs grid
        Row(children: [
          Expanded(
            child: _specBox('Capacity', '${item.sizeInLiters} L',
                Icons.water_outlined, C.teal, dark),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _specBox('Body Weight', item.bodyWeight,
                Icons.scale_outlined, C.indigo, dark),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _specBox('Lid Weight', item.lidWeight, Icons.layers_outlined,
                C.orange, dark),
          ),
        ]),

        if (item.description != null && item.description!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            item.description!,
            style: GoogleFonts.poppins(fontSize: 12, color: C.s500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        const SizedBox(height: 12),

        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () =>
                  Get.toNamed(AppRoutes.addBrochure, arguments: item),
              icon: const Icon(Icons.edit_outlined, size: 15),
              label: Text('Edit',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: C.g700,
                side: const BorderSide(color: C.g700),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => controller.deleteBrochureItem(item.id),
              icon: const Icon(Icons.delete_outline_rounded, size: 15),
              label: Text('Delete',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: C.red,
                side: const BorderSide(color: C.red),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _specBox(
          String label, String value, IconData icon, Color color, bool dark) =>
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: dark ? C.s800 : C.s100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: dark ? C.s700 : C.s200),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(label,
              style: GoogleFonts.poppins(fontSize: 9, color: C.s500),
              textAlign: TextAlign.center),
        ]),
      );

  // ── Settings Tab ─────────────────────────────────────────────
  Widget _settingsTab(bool dark, ThemeController tc, AuthController auth) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Container(
          decoration: BoxDecoration(
            color: dark ? C.s750 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: dark ? C.s700 : C.s200),
          ),
          child: Column(children: [
            Obx(() => _tile(
                  tc.isDark.value
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  tc.isDark.value
                      ? 'Switch to Light Mode'
                      : 'Switch to Dark Mode',
                  'Toggle app theme',
                  C.g700,
                  trailing: Switch.adaptive(
                      value: tc.isDark.value,
                      onChanged: (_) => tc.toggle(),
                      activeColor: C.g700),
                )),
            Divider(height: 1, color: dark ? C.s700 : C.s200),
            _tile(Icons.business_outlined, 'Business Name', auth.userBiz.value,
                C.teal),
            Divider(height: 1, color: dark ? C.s700 : C.s200),
            _tile(
                Icons.email_outlined, 'Email', auth.userEmail.value, C.indigo),
            Divider(height: 1, color: dark ? C.s700 : C.s200),
            _tile(Icons.info_outline_rounded, 'App Version',
                'v5.0 — Firebase + Gold Edition', C.s500),
            Divider(height: 1, color: dark ? C.s700 : C.s200),
            _tile(Icons.logout_rounded, 'Sign Out', 'Logout from your account',
                C.red,
                onTap: () => auth.logout()),
          ]),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _stat(
          String label, String value, IconData icon, Color color, bool dark) =>
      Expanded(
          child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: dark ? C.s750 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: dark ? C.s700 : C.s200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(9)),
              child: Icon(icon, color: color, size: 17)),
          const SizedBox(height: 10),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.w700)),
          Text(label, style: GoogleFonts.poppins(fontSize: 11, color: C.s500)),
        ]),
      ));

  Widget _tile(IconData icon, String title, String sub, Color color,
          {Widget? trailing, VoidCallback? onTap}) =>
      ListTile(
        onTap: onTap,
        leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20)),
        title: Text(title,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: Text(sub,
            style: GoogleFonts.poppins(fontSize: 12, color: C.s500),
            overflow: TextOverflow.ellipsis),
        trailing: trailing ??
            (onTap != null
                ? Icon(Icons.arrow_forward_ios_rounded, size: 14, color: C.s400)
                : null),
      );
}
