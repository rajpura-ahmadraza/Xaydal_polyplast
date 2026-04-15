import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final bizCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final confCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final showPass = false.obs;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 220,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    dark ? [C.s800, C.s900] : [C.g600, const Color(0xFF8A6A00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        SafeArea(
            child: Column(children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Create Account',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ]),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: dark ? C.s750 : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: dark
                      ? []
                      : [
                          BoxShadow(
                              color: C.g700.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 4))
                        ],
                ),
                child: Form(
                  key: formKey,
                  autovalidateMode:
                      AutovalidateMode.disabled, // FIX: no live validation
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 40,
                            height: 3,
                            decoration: BoxDecoration(
                                color: C.g600,
                                borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 14),
                        Text('Business Setup',
                            style: GoogleFonts.poppins(
                                fontSize: 20, fontWeight: FontWeight.w700)),
                        Text('Create your premium business account',
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: C.s500)),
                        const SizedBox(height: 22),
                        _field(
                            nameCtrl, 'Full Name', Icons.person_outline, dark,
                            validator: (v) => (v?.trim().isEmpty ?? true)
                                ? 'Please enter your name'
                                : null),
                        const SizedBox(height: 12),
                        _field(bizCtrl, 'Business Name',
                            Icons.business_outlined, dark,
                            validator: (v) => (v?.trim().isEmpty ?? true)
                                ? 'Please enter business name'
                                : null),
                        const SizedBox(height: 12),
                        _field(emailCtrl, 'Email Address', Icons.email_outlined,
                            dark, type: TextInputType.emailAddress,
                            validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Please enter your email';
                          if (!v.trim().contains('@'))
                            return 'Please enter a valid email';
                          return null;
                        }),
                        const SizedBox(height: 12),
                        Obx(() => TextFormField(
                              controller: passCtrl,
                              obscureText: !showPass.value,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon:
                                    const Icon(Icons.lock_outline, size: 20),
                                prefixIconColor: dark ? C.g400 : C.g700,
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      showPass.value = !showPass.value,
                                  icon: Icon(
                                      showPass.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 20),
                                ),
                              ),
                              validator: (v) => (v == null || v.length < 6)
                                  ? 'Minimum 6 characters required'
                                  : null,
                            )),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: confCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline, size: 20),
                              prefixIconColor: dark ? C.g400 : C.g700),
                          validator: (v) => v != passCtrl.text
                              ? 'Passwords do not match'
                              : null,
                        ),
                        const SizedBox(height: 26),
                        Obx(() => SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          controller.register(
                                              nameCtrl.text,
                                              emailCtrl.text,
                                              passCtrl.text,
                                              bizCtrl.text);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14))),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5))
                                    : const Text('Create Account'),
                              ),
                            )),
                        const SizedBox(height: 16),
                        Center(
                            child: GestureDetector(
                          onTap: () => Get.back(),
                          child: RichText(
                              text: TextSpan(
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: C.s500),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                  text: 'Sign In',
                                  style: GoogleFonts.poppins(
                                      color: dark ? C.g400 : C.g700,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )),
                        )),
                      ]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ])),
      ]),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon, bool dark,
          {TextInputType type = TextInputType.text,
          String? Function(String?)? validator}) =>
      TextFormField(
        controller: c,
        keyboardType: type,
        validator: validator,
        decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, size: 20),
            prefixIconColor: dark ? C.g400 : C.g700),
      );
}
