// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../controllers/biz_controller.dart';
// import '../controllers/auth_controller.dart';
// import '../models/models.dart';
// import '../theme/app_theme.dart';

// class AddBrochureView extends GetView<BizController> {
//   const AddBrochureView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Check if editing existing item
//     final BrochureItem? existing = Get.arguments as BrochureItem?;
//     final isEditing = existing != null;

//     final nameCtrl = TextEditingController(text: existing?.bucketName ?? '');
//     final sizeCtrl = TextEditingController(text: existing?.sizeInLiters ?? '');
//     final bodyCtrl = TextEditingController(text: existing?.bodyWeight ?? '');
//     final lidCtrl = TextEditingController(text: existing?.lidWeight ?? '');
//     final priceCtrl = TextEditingController(
//         text: existing?.sellingPrice.toInt().toString() ?? '');
//     final imgCtrl = TextEditingController(text: existing?.imageUrl ?? '');
//     final descCtrl = TextEditingController(text: existing?.description ?? '');
//     final matCtrl =
//         TextEditingController(text: existing?.material ?? 'HDPE Plastic');
//     final formKey = GlobalKey<FormState>();
//     final dark = Theme.of(context).brightness == Brightness.dark;
//     final auth = Get.find<AuthController>();
//     final previewUrl = (existing?.imageUrl ?? '').obs;

//     return Scaffold(
//       backgroundColor: dark ? C.s900 : C.s100,
//       appBar: AppBar(
//         backgroundColor: dark ? C.s800 : Colors.white,
//         title: Text(isEditing ? 'Edit Catalog Item' : 'Add to Catalog',
//             style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//         leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
//             onPressed: () => Get.back()),
//       ),
//       body: Form(
//         key: formKey,
//         autovalidateMode: AutovalidateMode.disabled,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             // Image Preview
//             Obx(() => GestureDetector(
//                   onTap: () {},
//                   child: Container(
//                     height: 160,
//                     decoration: BoxDecoration(
//                       color: dark ? C.s750 : C.g50,
//                       borderRadius: BorderRadius.circular(16),
//                       border:
//                           Border.all(color: dark ? C.s700 : C.g200, width: 1.5),
//                     ),
//                     child: previewUrl.value.isNotEmpty
//                         ? ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.network(previewUrl.value,
//                                 fit: BoxFit.contain,
//                                 errorBuilder: (_, __, ___) => _noImage(dark)))
//                         : _noImage(dark),
//                   ),
//                 )),
//             const SizedBox(height: 14),

//             _section(
//                 dark, 'Bucket Information', Icons.water_drop_outlined, C.g700, [
//               _field(nameCtrl, 'Bucket Name (e.g. 10L Premium Bucket)',
//                   Icons.label_outline, dark,
//                   validator: (v) => (v?.trim().isEmpty ?? true)
//                       ? 'Please enter bucket name'
//                       : null),
//               const SizedBox(height: 12),
//               Row(children: [
//                 Expanded(
//                     child: _field(sizeCtrl, 'Capacity (Litres)',
//                         Icons.water_outlined, dark,
//                         type: TextInputType.number,
//                         validator: (v) =>
//                             (v?.trim().isEmpty ?? true) ? 'Required' : null)),
//                 const SizedBox(width: 12),
//                 Expanded(
//                     child: _field(
//                         matCtrl, 'Material', Icons.layers_outlined, dark)),
//               ]),
//             ]),
//             const SizedBox(height: 14),

//             _section(
//                 dark, 'Weight Specifications', Icons.scale_outlined, C.teal, [
//               Row(children: [
//                 Expanded(
//                     child: _field(bodyCtrl, 'Body Weight (e.g. 220g)',
//                         Icons.scale_outlined, dark,
//                         validator: (v) =>
//                             (v?.trim().isEmpty ?? true) ? 'Required' : null)),
//                 const SizedBox(width: 12),
//                 Expanded(
//                     child: _field(lidCtrl, 'Lid Weight (e.g. 45g)',
//                         Icons.layers_outlined, dark,
//                         validator: (v) =>
//                             (v?.trim().isEmpty ?? true) ? 'Required' : null)),
//               ]),
//             ]),
//             const SizedBox(height: 14),

//             _section(dark, 'Pricing & Media', Icons.currency_rupee_rounded,
//                 C.indigo, [
//               _field(priceCtrl, 'Selling Price (₹)',
//                   Icons.currency_rupee_rounded, dark,
//                   type: TextInputType.number, validator: (v) {
//                 final n = double.tryParse(v ?? '');
//                 return (n == null || n <= 0)
//                     ? 'Please enter a valid price'
//                     : null;
//               }),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: imgCtrl,
//                 onChanged: (v) => previewUrl.value = v.trim(),
//                 decoration: InputDecoration(
//                   labelText: 'Image URL (optional)',
//                   prefixIcon: const Icon(Icons.image_outlined, size: 20),
//                   prefixIconColor: dark ? C.g400 : C.g700,
//                   filled: true,
//                   fillColor: dark ? C.s750 : C.s100,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide.none),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide.none),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide(
//                           color: dark ? C.g400 : C.g700, width: 1.5)),
//                   hintText: 'https://example.com/bucket.jpg',
//                   hintStyle: GoogleFonts.poppins(fontSize: 12, color: C.s400),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: descCtrl,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   labelText: 'Description (optional)',
//                   prefixIcon: const Padding(
//                       padding: EdgeInsets.only(bottom: 40),
//                       child: Icon(Icons.notes_rounded, size: 20)),
//                   prefixIconColor: dark ? C.g400 : C.g700,
//                   filled: true,
//                   fillColor: dark ? C.s750 : C.s100,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide.none),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide.none),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide(
//                           color: dark ? C.g400 : C.g700, width: 1.5)),
//                 ),
//               ),
//             ]),
//             const SizedBox(height: 24),

//             SizedBox(
//               height: 54,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (formKey.currentState!.validate()) {
//                     final item = BrochureItem(
//                       id: existing?.id ?? '',
//                       userId: auth.userId.value,
//                       bucketName: nameCtrl.text.trim(),
//                       sizeInLiters: sizeCtrl.text.trim(),
//                       bodyWeight: bodyCtrl.text.trim(),
//                       lidWeight: lidCtrl.text.trim(),
//                       sellingPrice: double.parse(priceCtrl.text),
//                       imageUrl: imgCtrl.text.trim().isEmpty
//                           ? null
//                           : imgCtrl.text.trim(),
//                       description: descCtrl.text.trim().isEmpty
//                           ? null
//                           : descCtrl.text.trim(),
//                       material: matCtrl.text.trim().isEmpty
//                           ? 'HDPE Plastic'
//                           : matCtrl.text.trim(),
//                     );
//                     if (isEditing) {
//                       controller.updateBrochureItem(existing!.id, item);
//                     } else {
//                       controller.addBrochureItem(item);
//                     }
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14))),
//                 child:
//                     Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                   Icon(isEditing ? Icons.save_rounded : Icons.add_rounded,
//                       size: 20),
//                   const SizedBox(width: 8),
//                   Text(isEditing ? 'Update Catalog Item' : 'Add to Catalog',
//                       style: GoogleFonts.poppins(
//                           fontSize: 15, fontWeight: FontWeight.w600)),
//                 ]),
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _noImage(bool dark) =>
//       Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(Icons.add_photo_alternate_outlined,
//             size: 36, color: dark ? C.s600 : C.g300),
//         const SizedBox(height: 8),
//         Text('Enter image URL below to preview',
//             style: GoogleFonts.poppins(
//                 fontSize: 12, color: dark ? C.s600 : C.g600)),
//       ]);

//   Widget _section(bool dark, String title, IconData icon, Color color,
//           List<Widget> children) =>
//       Container(
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: dark ? C.s750 : Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: dark ? C.s700 : C.s200),
//         ),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Row(children: [
//             Container(
//                 padding: const EdgeInsets.all(7),
//                 decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(9)),
//                 child: Icon(icon, color: color, size: 17)),
//             const SizedBox(width: 10),
//             Text(title,
//                 style: GoogleFonts.poppins(
//                     fontSize: 14, fontWeight: FontWeight.w600)),
//           ]),
//           const SizedBox(height: 16),
//           ...children,
//         ]),
//       );

//   Widget _field(
//           TextEditingController ctrl, String label, IconData icon, bool dark,
//           {TextInputType type = TextInputType.text,
//           String? Function(String?)? validator}) =>
//       TextFormField(
//         controller: ctrl,
//         keyboardType: type,
//         validator: validator,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, size: 20),
//           prefixIconColor: dark ? C.g400 : C.g700,
//           filled: true,
//           fillColor: dark ? C.s750 : C.s100,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide.none),
//           enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide.none),
//           focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide:
//                   BorderSide(color: dark ? C.g400 : C.g700, width: 1.5)),
//           errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(color: C.red)),
//         ),
//       );
// }

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
    final imgCtrl = TextEditingController(text: existing?.imageUrl ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final matCtrl =
        TextEditingController(text: existing?.material ?? 'HDPE Plastic');

    final formKey = GlobalKey<FormState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final auth = Get.find<AuthController>();

    final previewUrl = (existing?.imageUrl ?? '').obs;
    final selectedImage = Rxn<File>();

    // ✅ Image picker function
    Future<void> pickImage() async {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        selectedImage.value = File(image.path);
        previewUrl.value = '';
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
            /// 🔥 IMAGE PREVIEW (UPDATED)
            Obx(() => GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: dark ? C.s750 : C.g50,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: dark ? C.s700 : C.g200, width: 1.5),
                    ),
                    child: selectedImage.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(selectedImage.value!,
                                fit: BoxFit.cover),
                          )
                        : previewUrl.value.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: previewUrl.value.startsWith('http')
                                    ? Image.network(previewUrl.value,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            _noImage(dark))
                                    : Image.file(File(previewUrl.value),
                                        fit: BoxFit.cover),
                              )
                            : _noImage(dark),
                  ),
                )),

            const SizedBox(height: 14),

            _section(
                dark, 'Bucket Information', Icons.water_drop_outlined, C.g700, [
              _field(nameCtrl, 'Bucket Name', Icons.label_outline, dark,
                  validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null),
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
            ]),

            const SizedBox(height: 14),

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

            _section(dark, 'Pricing & Media', Icons.currency_rupee_rounded,
                C.indigo, [
              _field(priceCtrl, 'Selling Price', Icons.currency_rupee_rounded,
                  dark,
                  type: TextInputType.number),

              const SizedBox(height: 12),

              /// (Same UI, just optional URL support)
              TextFormField(
                controller: imgCtrl,
                onChanged: (v) => previewUrl.value = v.trim(),
                decoration: InputDecoration(
                  labelText: 'Image URL (optional)',
                  prefixIcon: const Icon(Icons.image_outlined),
                  filled: true,
                  fillColor: dark ? C.s750 : C.s100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: descCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: dark ? C.s750 : C.s100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ]),

            const SizedBox(height: 24),

            /// 🔥 SAVE BUTTON (UPDATED)
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final imagePath = selectedImage.value != null
                        ? selectedImage.value!.path
                        : (imgCtrl.text.trim().isEmpty
                            ? null
                            : imgCtrl.text.trim());

                    final item = BrochureItem(
                      id: existing?.id ?? '',
                      userId: auth.userId.value,
                      bucketName: nameCtrl.text.trim(),
                      sizeInLiters: sizeCtrl.text.trim(),
                      bodyWeight: bodyCtrl.text.trim(),
                      lidWeight: lidCtrl.text.trim(),
                      sellingPrice: double.parse(priceCtrl.text),
                      imageUrl: imagePath,
                      description: descCtrl.text.trim(),
                      material: matCtrl.text.trim(),
                    );

                    if (isEditing) {
                      controller.updateBrochureItem(existing.id, item);
                    } else {
                      controller.addBrochureItem(item);
                    }
                  }
                },
                child: Text(isEditing ? 'Update' : 'Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noImage(bool dark) => Center(
        child: Icon(Icons.add_photo_alternate_outlined,
            size: 36, color: dark ? C.s600 : C.g300),
      );

  Widget _section(bool dark, String title, IconData icon, Color color,
          List<Widget> children) =>
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: dark ? C.s750 : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: children),
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
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: dark ? C.s750 : C.s100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
}
