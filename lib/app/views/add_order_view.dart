// ═══════════════════════════════════════════════════════════════
// ADD ORDER VIEW (FIXED)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/biz_controller.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class AddOrderView extends GetView<BizController> {
  const AddOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    // ✅ FIX: use ID instead of full object
    final selProdId = RxnString();

    final formKey = GlobalKey<FormState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final qty = 0.obs;

    return Scaffold(
      backgroundColor: dark ? C.s900 : C.s100,
      appBar: AppBar(
        backgroundColor: dark ? C.s800 : Colors.white,
        title: Text('New Order',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section(
                dark, 'Customer Information', Icons.person_outline, C.g700, [
              _field(nameCtrl, 'Customer Name', Icons.person_outline, dark,
                  validator: (v) => (v?.trim().isEmpty ?? true)
                      ? 'Please enter customer name'
                      : null),
              const SizedBox(height: 12),
              _field(phoneCtrl, 'Phone Number', Icons.phone_outlined, dark,
                  type: TextInputType.phone,
                  validator: (v) => (v == null || v.length < 10)
                      ? 'Please enter a valid phone number'
                      : null),
            ]),
            const SizedBox(height: 14),

            _section(dark, 'Product & Quantity', Icons.inventory_2_outlined,
                C.teal, [
              /// ✅ FIXED DROPDOWN
              Obx(() {
                controller.products
                    .firstWhereOrNull((e) => e.id == selProdId.value);

                return DropdownButtonFormField<String>(
                  value: selProdId.value,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Select Bucket Type',
                    prefixIcon: const Icon(Icons.water_drop_outlined, size: 20),
                    prefixIconColor: dark ? C.g400 : C.g700,
                    filled: true,
                    fillColor: dark ? C.s750 : C.s100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: controller.products.map((p) {
                    return DropdownMenuItem<String>(
                      value: p.id,
                      child: Text(
                        '${p.name}  ·  ₹${p.price.toInt()}/pc  (${p.stock} left)',
                        style: GoogleFonts.poppins(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (id) {
                    selProdId.value = id;
                    qty.value = int.tryParse(qtyCtrl.text) ?? 0;
                  },
                  validator: (v) =>
                      v == null ? 'Please select a product' : null,
                );
              }),

              const SizedBox(height: 12),

              /// Quantity
              Obx(() {
                final selectedProduct = controller.products
                    .firstWhereOrNull((e) => e.id == selProdId.value);

                return TextFormField(
                  controller: qtyCtrl,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => qty.value = int.tryParse(v) ?? 0,
                  decoration: InputDecoration(
                    labelText: 'Quantity (pcs)',
                    prefixIcon: const Icon(Icons.numbers_rounded, size: 20),
                    prefixIconColor: dark ? C.g400 : C.g700,
                    filled: true,
                    fillColor: dark ? C.s750 : C.s100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n <= 0) {
                      return 'Please enter a valid quantity';
                    }
                    if (selectedProduct != null && n > selectedProduct.stock) {
                      return 'Not enough stock (Available: ${selectedProduct.stock})';
                    }
                    return null;
                  },
                );
              }),

              const SizedBox(height: 12),
              _field(notesCtrl, 'Notes (optional)', Icons.notes_rounded, dark),
            ]),
            const SizedBox(height: 14),

            /// ✅ TOTAL CALCULATION
            Obx(() {
              final selectedProduct = controller.products
                  .firstWhereOrNull((e) => e.id == selProdId.value);

              final total = qty.value * (selectedProduct?.price ?? 0);

              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: dark
                        ? [C.s800, C.s900]
                        : [C.g600, const Color(0xFF8A6A00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Total',
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: Colors.white70)),
                        Text(
                          '${qty.value > 0 ? qty.value : "—"} pcs × ₹${selectedProduct?.price.toInt() ?? "—"}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white60),
                        ),
                      ]),
                  const Spacer(),
                  Text('₹${total.toInt()}',
                      style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ]),
              );
            }),

            const SizedBox(height: 24),

            /// SAVE BUTTON
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final p = controller.products
                        .firstWhere((e) => e.id == selProdId.value);

                    final q = int.parse(qtyCtrl.text);

                    controller.addOrder(OrderModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      customerName: nameCtrl.text.trim(),
                      customerPhone: phoneCtrl.text.trim(),
                      productId: p.id,
                      productName: p.name,
                      quantity: q,
                      pricePerUnit: p.price,
                      totalAmount: q * p.price,
                      status: 'pending',
                      date: DateTime.now(),
                      userId: controller.uid,
                      notes: notesCtrl.text.trim().isEmpty
                          ? null
                          : notesCtrl.text.trim(),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_shopping_cart_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('Save Order'),
                    ]),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _section(bool dark, String title, IconData icon, Color color,
          List<Widget> children) =>
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: dark ? C.s750 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: dark ? C.s700 : C.s200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(9)),
                child: Icon(icon, color: color, size: 17)),
            const SizedBox(width: 10),
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 16),
          ...children,
        ]),
      );

  Widget _field(
          TextEditingController ctrl, String label, IconData icon, bool dark,
          {TextInputType type = TextInputType.text,
          String? Function(String?)? validator}) =>
      TextFormField(
        controller: ctrl,
        keyboardType: type,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          prefixIconColor: dark ? C.g400 : C.g700,
          filled: true,
          fillColor: dark ? C.s750 : C.s100,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  BorderSide(color: dark ? C.g400 : C.g700, width: 1.5)),
        ),
      );
}
