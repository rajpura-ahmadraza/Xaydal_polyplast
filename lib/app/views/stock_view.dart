// ═══════════════════════════════════════════════════════════════
// STOCK VIEW
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/biz_controller.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class StockView extends GetView<BizController> {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark ? C.s800 : Colors.white,
        title: Text('Stock & Inventory',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(children: [
                _sum('Products', '${controller.products.length}',
                    Icons.widgets_rounded, C.teal, dark),
                const SizedBox(width: 10),
                _sum('Total Pieces', '${controller.totalStock}',
                    Icons.inventory_rounded, C.g700, dark),
                const SizedBox(width: 10),
                _sum('Low Stock', '${controller.lowStock.length}',
                    Icons.warning_rounded, C.orange, dark),
              ]),
              const SizedBox(height: 22),
              Text('Bucket Inventory',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              ...controller.products.map((p) => _productCard(p, dark, context)),
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.addProduct),
        icon: const Icon(Icons.add_rounded),
        label: Text('Add Product',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: C.g700,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _sum(
          String label, String val, IconData icon, Color color, bool dark) =>
      Expanded(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: dark ? C.s750 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: dark ? C.s700 : C.s200),
        ),
        child: Column(children: [
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18)),
          const SizedBox(height: 8),
          Text(val,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w700)),
          Text(label,
              style: GoogleFonts.poppins(fontSize: 10, color: C.s500),
              textAlign: TextAlign.center),
        ]),
      ));

  Widget _productCard(ProductModel p, bool dark, BuildContext context) {
    final pct = (p.stock / (p.minStock * 5)).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? C.s750 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: p.isLowStock
                ? C.orange.withOpacity(0.5)
                : (dark ? C.s700 : C.s200)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [C.g200, C.g100]),
                borderRadius: BorderRadius.circular(12)),
            child:
                const Center(child: Text('🪣', style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(p.name,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                    'Size: ${p.size}  ·  Color: ${p.color}  ·  \u20B9${p.price.toInt()}/pc',
                    style: GoogleFonts.poppins(fontSize: 12, color: C.s500)),
              ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: (p.isLowStock ? C.orange : C.green).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(p.isLowStock ? '⚠ Low' : '✓ OK',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: p.isLowStock ? C.orange : C.green)),
          ),
        ]),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${p.stock} pcs in stock',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 13)),
          Text('Min Alert: ${p.minStock} pcs',
              style: GoogleFonts.poppins(fontSize: 12, color: C.s500)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
              value: pct,
              minHeight: 7,
              backgroundColor: dark ? C.s700 : C.s200,
              valueColor:
                  AlwaysStoppedAnimation(p.isLowStock ? C.orange : C.g700)),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child:
                  _btn('+ Add Stock', C.g700, () => _dialog(context, p, true))),
          const SizedBox(width: 10),
          Expanded(
              child: _btn('− Reduce', C.s500, () => _dialog(context, p, false),
                  outline: true)),
        ]),
      ]),
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
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: outline ? color : Colors.white))),
        ),
      );

  void _dialog(BuildContext context, ProductModel p, bool isAdd) {
    final ctrl = TextEditingController();
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(isAdd ? 'Add Stock' : 'Reduce Stock',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('${p.name}  ·  Current: ${p.stock} pcs',
            style: GoogleFonts.poppins(fontSize: 13, color: C.s500)),
        const SizedBox(height: 14),
        TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity (pcs)',
              prefixIcon: Icon(isAdd ? Icons.add_rounded : Icons.remove_rounded,
                  color: isAdd ? C.g700 : C.red),
            )),
      ]),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final q = int.tryParse(ctrl.text) ?? 0;
            if (q > 0) {
              controller.updateStock(p.id, isAdd ? q : -q);
              Get.back();
            }
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: const Text('Save'),
        ),
      ],
    ));
  }
}
