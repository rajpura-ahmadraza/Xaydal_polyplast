import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/biz_controller.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class AddProductView extends GetView<BizController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl  = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    final minCtrl   = TextEditingController(text: '20');
    final sizeCtrl  = TextEditingController();
    final colorCtrl = TextEditingController(text: 'Silver');
    final formKey   = GlobalKey<FormState>();
    final dark      = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? C.s900 : C.s100,
      appBar: AppBar(
        backgroundColor: dark ? C.s800 : Colors.white,
        title: Text('Add Product', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
            _section(dark, 'Bucket Details', Icons.water_drop_outlined, C.g700, [
              _field(nameCtrl, 'Product Name', Icons.label_outline, dark,
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Please enter product name' : null),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: _field(sizeCtrl, 'Size (5L, 10L...)', Icons.straighten_rounded, dark,
                      validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(colorCtrl, 'Color', Icons.palette_outlined, dark),
                ),
              ]),
            ]),
            const SizedBox(height: 14),

            _section(dark, 'Pricing & Stock', Icons.currency_rupee_rounded, C.teal, [
              _field(priceCtrl, 'Price per piece (₹)', Icons.currency_rupee_rounded, dark,
                  type: TextInputType.number,
                  validator: (v) {
                    final n = double.tryParse(v ?? '');
                    return (n == null || n <= 0) ? 'Please enter a valid price' : null;
                  }),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: _field(stockCtrl, 'Opening Stock', Icons.add_box_outlined, dark,
                      type: TextInputType.number,
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        return (n == null || n < 0) ? 'Required' : null;
                      }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(minCtrl, 'Min Alert Level', Icons.warning_amber_outlined, dark,
                      type: TextInputType.number),
                ),
              ]),
            ]),
            const SizedBox(height: 24),

            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.addProduct(ProductModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text.trim(),
                      price: double.parse(priceCtrl.text),
                      stock: int.parse(stockCtrl.text),
                      size: sizeCtrl.text.trim(),
                      color: colorCtrl.text.trim(),
                      minStock: int.tryParse(minCtrl.text) ?? 20,
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.add_box_rounded, size: 20),
                  const SizedBox(width: 8),
                  const Text('Save Product'),
                ]),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _section(bool dark, String title, IconData icon, Color color, List<Widget> children) =>
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
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(9)),
              child: Icon(icon, color: color, size: 17),
            ),
            const SizedBox(width: 10),
            Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 16),
          ...children,
        ]),
      );

  Widget _field(TextEditingController ctrl, String label, IconData icon, bool dark,
      {TextInputType type = TextInputType.text, String? Function(String?)? validator}) =>
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: dark ? C.g400 : C.g700, width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: C.red)),
        ),
      );
}
