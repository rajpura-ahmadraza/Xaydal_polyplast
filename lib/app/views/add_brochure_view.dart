import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/biz_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class AddBrochureView extends GetView<BizController> {
  const AddBrochureView({super.key});

  @override
  Widget build(BuildContext context) {
    final BrochureItem? existing = Get.arguments as BrochureItem?;
    final isEditing = existing != null;

    final nameCtrl = TextEditingController(text: existing?.bucketName ?? '');
    final sizeCtrl = TextEditingController(text: existing?.sizeInLiters ?? '');
    final bodyCtrl = TextEditingController(text: existing?.bodyWeight ?? '');
    final lidCtrl = TextEditingController(text: existing?.lidWeight ?? '');
    final priceCtrl = TextEditingController(
        text: existing?.sellingPrice.toInt().toString() ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final matCtrl =
        TextEditingController(text: existing?.material ?? 'HDPE Plastic');
    final heightCtrl = TextEditingController(text: existing?.height ?? '');
    final handleCtrl = TextEditingController(text: existing?.handle ?? '');

    final formKey = GlobalKey<FormState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final auth = Get.find<AuthController>();

    // Multiple selected images (new picks)
    final selectedImages = <File>[].obs;
    // Existing images (from editing) still shown
    final existingImageUrls = (existing?.imageUrls ?? <String>[]).obs;

    Future<void> pickImages() async {
      final picker = ImagePicker();
      final List<XFile> picked = await picker.pickMultiImage();
      if (picked.isNotEmpty) {
        selectedImages.addAll(picked.map((x) => File(x.path)));
      }
    }

    return Scaffold(
      backgroundColor: dark ? C.s900 : C.s100,
      appBar: AppBar(
        backgroundColor: dark ? C.s800 : Colors.white,
        title: Text(
          isEditing ? 'Edit Catalog Item' : 'Add to Catalog',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── MULTIPLE IMAGE PICKER ──────────────────────────
            Obx(() {
              final allFiles = selectedImages.toList();
              final allUrls = existingImageUrls.toList();
              final totalCount = allUrls.length + allFiles.length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grid of selected images + add button
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Existing images (editing)
                      ...allUrls.asMap().entries.map((e) => _imageTile(
                            dark,
                            child: Image.file(File(e.value), fit: BoxFit.cover),
                            onRemove: () => existingImageUrls.removeAt(e.key),
                          )),
                      // Newly selected images
                      ...allFiles.asMap().entries.map((e) => _imageTile(
                            dark,
                            child: Image.file(e.value, fit: BoxFit.cover),
                            onRemove: () => selectedImages.removeAt(e.key),
                          )),
                      // Add more button
                      GestureDetector(
                        onTap: pickImages,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: dark ? C.s750 : C.g50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: dark ? C.s600 : C.g300,
                                width: 1.5,
                                style: BorderStyle.solid),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  size: 26, color: dark ? C.g400 : C.g500),
                              const SizedBox(height: 4),
                              Text(
                                totalCount == 0 ? 'Add Photo' : 'Add More',
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: dark ? C.g400 : C.g600),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (totalCount > 0) ...[
                    const SizedBox(height: 6),
                    Text(
                      '$totalCount photo${totalCount > 1 ? 's' : ''} selected',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: dark ? C.g400 : C.g600),
                    ),
                  ],
                ],
              );
            }),

            const SizedBox(height: 16),

            /// ── BUCKET INFORMATION ────────────────────────────
            _section(
                dark, 'Bucket Information', Icons.water_drop_outlined, C.g700, [
              _field(nameCtrl, 'Bucket Name', Icons.label_outline, dark,
                  validator: (v) =>
                      (v?.trim().isEmpty ?? true) ? 'Required' : null),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                    child: _field(
                        sizeCtrl, 'Capacity (L)', Icons.water_outlined, dark)),
                const SizedBox(width: 12),
                Expanded(
                    child: _field(
                        matCtrl, 'Material', Icons.layers_outlined, dark)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                    child: _field(heightCtrl, 'Height (e.g. 28cm)',
                        Icons.height_rounded, dark)),
                const SizedBox(width: 12),
                Expanded(
                    child: _field(
                        handleCtrl, 'Handle', Icons.drag_handle_rounded, dark)),
              ]),
            ]),

            const SizedBox(height: 14),

            /// ── WEIGHT SPECIFICATIONS ─────────────────────────
            _section(
                dark, 'Weight Specifications', Icons.scale_outlined, C.teal, [
              Row(children: [
                Expanded(
                    child: _field(
                        bodyCtrl, 'Body Weight', Icons.scale_outlined, dark)),
                const SizedBox(width: 12),
                Expanded(
                    child: _field(
                        lidCtrl, 'Lid Weight', Icons.layers_outlined, dark)),
              ]),
            ]),

            const SizedBox(height: 14),

            /// ── PRICING ───────────────────────────────────────
            _section(dark, 'Pricing', Icons.currency_rupee_rounded, C.indigo, [
              _field(priceCtrl, 'Selling Price (₹)',
                  Icons.currency_rupee_rounded, dark,
                  type: TextInputType.number, validator: (v) {
                final n = double.tryParse(v ?? '');
                return (n == null || n <= 0) ? 'Enter valid price' : null;
              }),
              const SizedBox(height: 12),
              TextFormField(
                controller: descCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(Icons.notes_rounded, size: 20)),
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
                      borderSide: BorderSide(
                          color: dark ? C.g400 : C.g700, width: 1.5)),
                ),
              ),
            ]),

            const SizedBox(height: 24),

            /// ── SAVE BUTTON ───────────────────────────────────
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Combine existing (editing) + newly picked image paths
                    final allImagePaths = [
                      ...existingImageUrls,
                      ...selectedImages.map((f) => f.path),
                    ];

                    final item = BrochureItem(
                      id: existing?.id ?? '',
                      userId: auth.userId.value,
                      bucketName: nameCtrl.text.trim(),
                      sizeInLiters: sizeCtrl.text.trim(),
                      bodyWeight: bodyCtrl.text.trim(),
                      lidWeight: lidCtrl.text.trim(),
                      sellingPrice: double.tryParse(priceCtrl.text) ?? 0,
                      imageUrls: allImagePaths,
                      description: descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim(),
                      material: matCtrl.text.trim().isEmpty
                          ? 'HDPE Plastic'
                          : matCtrl.text.trim(),
                      height: heightCtrl.text.trim().isEmpty
                          ? null
                          : heightCtrl.text.trim(),
                      handle: handleCtrl.text.trim().isEmpty
                          ? null
                          : handleCtrl.text.trim(),
                    );

                    if (isEditing) {
                      controller.updateBrochureItem(existing.id, item);
                    } else {
                      controller.addBrochureItem(item);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(isEditing ? Icons.save_rounded : Icons.add_rounded,
                      size: 20),
                  const SizedBox(width: 8),
                  Text(isEditing ? 'Update Catalog Item' : 'Add to Catalog',
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Small 80×80 image tile with a remove (×) button
  Widget _imageTile(bool dark,
          {required Widget child, required VoidCallback onRemove}) =>
      Stack(clipBehavior: Clip.none, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(width: 80, height: 80, child: child),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 22,
              height: 22,
              decoration:
                  const BoxDecoration(color: C.red, shape: BoxShape.circle),
              child: const Icon(Icons.close_rounded,
                  size: 14, color: Colors.white),
            ),
          ),
        ),
      ]);

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
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: C.red)),
        ),
      );
}
