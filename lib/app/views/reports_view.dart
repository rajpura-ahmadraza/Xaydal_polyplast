import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../controllers/biz_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../theme/app_theme.dart';

class ReportsView extends GetView<BizController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##,###', 'en_IN');
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tc = Get.find<ThemeController>();
    final auth = Get.find<AuthController>();
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports & Profile',
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
                      color: dark ? AppTheme.darkCard : AppTheme.silver100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              dark ? AppTheme.darkBorder : AppTheme.silver100),
                    ),
                    child: Icon(
                      tc.isDark.value
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: AppTheme.gold700,
                      size: 20,
                    ),
                  ),
                ),
              )),
        ],
      ),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Profile Card ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: dark
                        ? [AppTheme.silver100, AppTheme.silver100]
                        : [AppTheme.gold600, AppTheme.gold600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.5), width: 2),
                    ),
                    child: const Center(
                        child: Text('👑', style: TextStyle(fontSize: 28))),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                            auth.userName.value.isEmpty
                                ? 'Business Owner'
                                : auth.userName.value,
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        Text(
                            auth.userBiz.value.isEmpty
                                ? 'Plastic Business'
                                : auth.userBiz.value,
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text(auth.userEmail.value,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.white60)),
                      ])),
                ]),
              ),
              const SizedBox(height: 14),

              // ── Business Summary ──────────────────────────────────
              Row(children: [
                _statCard(
                    'Total Revenue',
                    '₹${fmt.format(controller.totalEarning.toInt())}',
                    Icons.account_balance_wallet_rounded,
                    AppTheme.gold600,
                    dark),
                const SizedBox(width: 12),
                _statCard('Orders Done', '${controller.deliveredCount}',
                    Icons.task_alt_rounded, AppTheme.gold600, dark),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _statCard('Total Orders', '${controller.orders.length}',
                    Icons.receipt_long_rounded, AppTheme.gold600, dark),
                const SizedBox(width: 12),
                _statCard(
                    'This Month',
                    '₹${fmt.format(controller.monthEarning.toInt())}',
                    Icons.trending_up_rounded,
                    AppTheme.gold600,
                    dark),
              ]),

              // ── Weekly Earnings Chart ─────────────────────────────
              const SizedBox(height: 22),
              _sectionHeader('Weekly Earnings', '(Last 7 days)'),
              const SizedBox(height: 12),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: dark ? AppTheme.darkCard : AppTheme.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: dark ? AppTheme.darkBorder : AppTheme.silver100),
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (controller.weeklyEarnings
                                .reduce((a, b) => a > b ? a : b) *
                            1.3)
                        .clamp(1000, double.infinity),
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (v, _) => Text(days[v.toInt()],
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: AppTheme.silver100)),
                      )),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (v, _) => Text(
                            '₹${(v / 1000).toStringAsFixed(0)}k',
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: AppTheme.silver100)),
                      )),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1000,
                      getDrawingHorizontalLine: (_) => FlLine(
                          color:
                              dark ? AppTheme.darkBorder : AppTheme.silver100,
                          strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(7, (i) {
                      final val = controller.weeklyEarnings[i];
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: val == 0 ? 0.01 : val,
                            width: 22,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                            gradient: LinearGradient(
                              colors: val > 0
                                  ? [AppTheme.gold600, AppTheme.gold600]
                                  : [AppTheme.silver100, AppTheme.silver100],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),

              // ── Monthly Order Chart ───────────────────────────────
              const SizedBox(height: 22),
              _sectionHeader('Monthly Orders', '(Last 6 months)'),
              const SizedBox(height: 12),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: dark ? AppTheme.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: dark ? AppTheme.darkBorder : AppTheme.silver100),
                ),
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (v, _) => Text(
                            months[v.toInt().clamp(0, 5)],
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: AppTheme.silver100)),
                      )),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (v, _) => Text('${v.toInt()}',
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: AppTheme.silver100)),
                      )),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                          color:
                              dark ? AppTheme.darkBorder : AppTheme.silver100,
                          strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                            6,
                            (i) => FlSpot(i.toDouble(),
                                controller.monthlyOrderCount[i].toDouble())),
                        isCurved: true,
                        curveSmoothness: 0.3,
                        color: AppTheme.gold700,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (_, __, ___, ____) =>
                              FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.gold600,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.gold600.withOpacity(0.3),
                              AppTheme.gold600.withOpacity(0.0)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Top Products ──────────────────────────────────────
              const SizedBox(height: 22),
              _sectionHeader('Top Products', 'by stock value'),
              const SizedBox(height: 12),
              ...controller.products.map((p) {
                final value = p.price * p.stock;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: dark ? AppTheme.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: dark ? AppTheme.darkBorder : AppTheme.silver100),
                  ),
                  child: Row(children: [
                    const Text('🪣', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(p.name,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 13)),
                          Text('${p.stock} pcs × ₹${p.price.toInt()}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: AppTheme.silver100)),
                        ])),
                    Text('₹${fmt.format(value.toInt())}',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppTheme.gold700)),
                  ]),
                );
              }),

              // ── Settings / Logout ─────────────────────────────────
              const SizedBox(height: 22),
              _sectionHeader('Settings', ''),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: dark ? AppTheme.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: dark ? AppTheme.darkBorder : AppTheme.silver100),
                ),
                child: Column(children: [
                  Obx(() => _settingTile(
                        tc.isDark.value
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        tc.isDark.value ? 'Light Mode' : 'Dark Mode',
                        'Theme switch karo',
                        AppTheme.gold600,
                        trailing: Switch.adaptive(
                          value: tc.isDark.value,
                          onChanged: (_) => tc.toggle(),
                          activeColor: AppTheme.gold600,
                        ),
                        dark: dark,
                      )),
                  Divider(
                      height: 1,
                      color: dark ? AppTheme.darkBorder : AppTheme.silver100),
                  _settingTile(Icons.info_outline_rounded, 'App Version',
                      'v3.0 — Gold & Silver Edition', Colors.teal,
                      dark: dark),
                  Divider(
                      height: 1,
                      color: dark ? AppTheme.darkBorder : AppTheme.silver100),
                  _settingTile(Icons.logout_rounded, 'Logout',
                      'Account thi logout thao', AppTheme.gold600,
                      onTap: () => Get.find<AuthController>().logout(),
                      dark: dark),
                ]),
              ),
              const SizedBox(height: 40),
            ],
          )),
    );
  }

  Widget _statCard(
          String label, String value, IconData icon, Color color, bool dark) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: dark ? AppTheme.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: dark ? AppTheme.darkBorder : AppTheme.silver100),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18)),
            const SizedBox(height: 10),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppTheme.silver100)),
          ]),
        ),
      );

  Widget _sectionHeader(String title, String sub) => Row(children: [
        Text(title,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(width: 6),
        Text(sub,
            style:
                GoogleFonts.poppins(fontSize: 12, color: AppTheme.silver100)),
      ]);

  Widget _settingTile(IconData icon, String title, String sub, Color color,
          {Widget? trailing, VoidCallback? onTap, required bool dark}) =>
      ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: Text(sub,
            style:
                GoogleFonts.poppins(fontSize: 12, color: AppTheme.silver100)),
        trailing: trailing ??
            (onTap != null
                ? Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppTheme.silver100)
                : null),
      );
}
