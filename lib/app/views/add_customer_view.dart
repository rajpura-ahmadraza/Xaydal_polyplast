import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/biz_controller.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class AddCustomerView extends GetView<BizController> {
  const AddCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl    = TextEditingController();
    final phoneCtrl   = TextEditingController();
    final addressCtrl = TextEditingController();
    final formKey     = GlobalKey<FormState>();
    final dark        = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? C.s900 : C.s100,
      appBar: AppBar(
        backgroundColor: dark ? C.s800 : Colors.white,
        title: Text('Add Customer', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
                    decoration: BoxDecoration(color: C.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(9)),
                    child: const Icon(Icons.person_add_outlined, color: C.teal, size: 17),
                  ),
                  const SizedBox(width: 10),
                  Text('Customer Information', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 16),

                TextFormField(
                  controller: nameCtrl,
                  decoration: _dec('Full Name', Icons.person_outline, dark),
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Please enter customer name' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: _dec('Phone Number', Icons.phone_outlined, dark),
                  validator: (v) => (v == null || v.length < 10) ? 'Please enter a valid phone number' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: addressCtrl,
                  maxLines: 2,
                  decoration: _dec('Address (Optional)', Icons.location_on_outlined, dark),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // Info card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: dark ? C.s750 : C.g50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: dark ? C.s700 : C.g200),
              ),
              child: Row(children: [
                const Icon(Icons.star_rounded, color: C.g600, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Customers with ₹10,000+ total purchase are automatically marked as VIP.',
                    style: GoogleFonts.poppins(fontSize: 12, color: dark ? C.s400 : C.g700),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.addCustomer(CustomerModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                      address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
                      userId: controller.uid,
                      createdAt: DateTime.now(),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.person_add_rounded, size: 20),
                  const SizedBox(width: 8),
                  const Text('Save Customer'),
                ]),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  InputDecoration _dec(String label, IconData icon, bool dark) => InputDecoration(
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
      );
}
