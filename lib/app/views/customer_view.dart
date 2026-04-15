import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/dashboard_controller.dart';
import '../models/customer_model.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class CustomerView extends GetView<DashboardController> {
  const CustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##,###', 'en_IN');
    final search = ''.obs;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('ગ્રાહકો',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Obx(() => Text(
                  '${controller.customers.length} total',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.grey.shade400),
                )),
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            onChanged: (v) => search.value = v,
            decoration: InputDecoration(
              hintText: 'ગ્રાહક શોધો...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: Obx(() => search.value.isNotEmpty
                  ? GestureDetector(
                      onTap: () => search.value = '',
                      child: const Icon(Icons.close_rounded))
                  : const SizedBox()),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final filtered = controller.customers
                .where((c) =>
                    c.name.toLowerCase().contains(search.value.toLowerCase()) ||
                    c.phone.contains(search.value))
                .toList()
              ..sort((a, b) => b.totalPurchase.compareTo(a.totalPurchase));

            if (filtered.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.light.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.people_outline_rounded,
                          size: 48, color: AppTheme.light.primaryColor),
                    ),
                    const SizedBox(height: 16),
                    Text('કોઈ ગ્રાહક નથી',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: filtered.length,
              itemBuilder: (_, i) => _customerCard(filtered[i], fmt, isDark),
            );
          }),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.addCustomer),
        icon: const Icon(Icons.person_add_outlined),
        label: Text('ગ્રાહક ઉમેરો',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.light.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _customerCard(CustomerModel c, NumberFormat fmt, bool isDark) {
    final initials =
        c.name.trim().split(' ').map((w) => w[0].toUpperCase()).take(2).join();
    final colors = [
      AppTheme.light.primaryColor,
      Colors.teal,
      Colors.purple,
      Colors.deepOrange,
      Colors.indigo,
    ];
    final color = colors[c.name.codeUnitAt(0) % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.goldColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color:
                isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(initials,
                  style: GoogleFonts.poppins(
                      color: color, fontWeight: FontWeight.w700, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(c.name,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                if (c.isVip) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.goldColor?.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('⭐ VIP',
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppTheme.goldColor,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ]),
              const SizedBox(height: 2),
              Text(c.phone,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey.shade500)),
              if (c.address != null)
                Text(c.address!,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey.shade400)),
            ]),
          ),

          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('₹${fmt.format(c.totalPurchase.toInt())}',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.dark.primaryColor)),
            Text('${c.totalOrders} orders',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: Colors.grey.shade400)),
          ]),
        ]),
      ),
    );
  }
}
