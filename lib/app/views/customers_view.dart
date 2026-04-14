import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/biz_controller.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class CustomersView extends GetView<BizController> {
  const CustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt    = NumberFormat('#,##,###', 'en_IN');
    final search = ''.obs;
    final dark   = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark ? C.s800 : Colors.white,
        title: Text('Customers', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: C.g50, borderRadius: BorderRadius.circular(10)),
              child: Text('${controller.customers.length} Total',
                  style: GoogleFonts.poppins(fontSize: 12, color: C.g700, fontWeight: FontWeight.w600)),
            ),
          )),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: TextField(
            onChanged: (v) => search.value = v,
            decoration: InputDecoration(
              hintText: 'Search customers...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              prefixIconColor: C.g700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          final vips = controller.customers.where((c) => c.isVip).length;
          if (vips == 0) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [C.g600, Color(0xFF8A6A00)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                const Text('👑', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text('$vips VIP Customers  ·  ₹10,000+ purchase',
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
              ]),
            ),
          );
        }),
        const SizedBox(height: 8),
        Expanded(child: Obx(() {
          final list = controller.customers
              .where((c) =>
                  c.name.toLowerCase().contains(search.value.toLowerCase()) ||
                  c.phone.contains(search.value))
              .toList()
            ..sort((a, b) => b.totalPurchase.compareTo(a.totalPurchase));

          if (list.isEmpty) return Center(child: Text('No customers found', style: GoogleFonts.poppins(color: C.s500)));

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _card(list[i], fmt, dark, i),
          );
        })),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.addCustomer),
        icon: const Icon(Icons.person_add_rounded),
        label: Text('Add Customer', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: C.g700, foregroundColor: Colors.white,
      ),
    );
  }

  Widget _card(CustomerModel c, NumberFormat fmt, bool dark, int rank) {
    final initials = c.name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();
    final colors   = [C.g700, C.teal, C.indigo, Colors.purple, Colors.deepOrange];
    final color    = colors[c.name.codeUnitAt(0) % colors.length];
    final medalColors = [C.g500, C.s400, const Color(0xFFCD7F32)];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? C.s750 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: c.isVip ? C.g500.withOpacity(0.5) : (dark ? C.s700 : C.s200),
          width: c.isVip ? 1.5 : 1,
        ),
      ),
      child: Row(children: [
        Stack(children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
              border: c.isVip ? Border.all(color: C.g500, width: 2) : null,
            ),
            child: Center(child: Text(initials,
                style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w700, fontSize: 17))),
          ),
          if (rank < 3)
            Positioned(bottom: 0, right: 0, child: Container(
              width: 20, height: 20,
              decoration: BoxDecoration(color: medalColors[rank], shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5)),
              child: Center(child: Text('${rank + 1}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
            )),
        ]),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(c.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15), overflow: TextOverflow.ellipsis)),
            if (c.isVip) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [C.g500, C.g700]),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('👑 VIP', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ]),
          Text(c.phone, style: GoogleFonts.poppins(fontSize: 12, color: C.s500)),
          if (c.address != null) Text(c.address!, style: GoogleFonts.poppins(fontSize: 12, color: C.s500)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('\u20B9${fmt.format(c.totalPurchase.toInt())}',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.g700)),
          Text('${c.totalOrders} orders', style: GoogleFonts.poppins(fontSize: 11, color: C.s500)),
        ]),
      ]),
    );
  }
}
