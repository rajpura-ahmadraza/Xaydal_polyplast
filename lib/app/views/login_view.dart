import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final showPass = false.obs;

  final controller = Get.put(AuthController());
  final tc = Get.put(ThemeController());

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              // Gold gradient header (UNCHANGED)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 320,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: dark
                          ? [C.s800, C.s900]
                          : [C.g600, const Color(0xFF8A6A00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(top: -50, right: -50, child: _ring(200, 0.06)),
                    Positioned(top: 80, right: 40, child: _ring(90, 0.08)),
                    Positioned(bottom: 20, left: -30, child: _ring(130, 0.05)),
                  ]),
                ),
              ),

              // Theme toggle (UNCHANGED)
              Positioned(
                top: 52,
                right: 16,
                child: SafeArea(
                  child: Obx(() => GestureDetector(
                        onTap: tc.toggle,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Icon(
                            tc.isDark.value
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      )),
                ),
              ),

              SafeArea(
                child: Column(children: [
                  const SizedBox(height: 48),

                  // Logo (UNCHANGED)
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [C.g400, C.g700]),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.5), width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: C.g700.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6))
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text('Plastic Business',
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),

                  Text('Your premium business partner',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.white70)),

                  const SizedBox(height: 36),

                  // Card (UNCHANGED DESIGN)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                      decoration: BoxDecoration(
                        color: dark ? C.s750 : Colors.white,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28)),
                        boxShadow: dark
                            ? []
                            : [
                                BoxShadow(
                                    color: C.g700.withOpacity(0.12),
                                    blurRadius: 30,
                                    offset: const Offset(0, -4))
                              ],
                      ),
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 40,
                                  height: 3,
                                  decoration: BoxDecoration(
                                      color: C.g600,
                                      borderRadius: BorderRadius.circular(2))),

                              const SizedBox(height: 16),

                              Text('Welcome Back 👑',
                                  style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700)),

                              Text('Sign in to continue',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: C.s500)),

                              const SizedBox(height: 28),

                              // EMAIL (FIXED VALIDATION ONLY)
                              TextFormField(
                                controller: emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  prefixIcon: const Icon(Icons.email_outlined,
                                      size: 20),
                                  prefixIconColor: dark ? C.g400 : C.g700,
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!GetUtils.isEmail(v.trim())) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 14),

                              // PASSWORD (UNCHANGED)
                              Obx(() => TextFormField(
                                    controller: passCtrl,
                                    obscureText: !showPass.value,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: const Icon(Icons.lock_outline,
                                          size: 20),
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
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Please enter your password'
                                        : null,
                                  )),

                              const SizedBox(height: 28),

                              // BUTTON (UNCHANGED)
                              Obx(() => SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                controller.login(
                                                  emailCtrl.text.trim(),
                                                  passCtrl.text.trim(),
                                                );
                                              }
                                            },
                                      child: controller.isLoading.value
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5))
                                          : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.login_rounded,
                                                    size: 18),
                                                SizedBox(width: 8),
                                                Text('Sign In'),
                                              ],
                                            ),
                                    ),
                                  )),

                              const SizedBox(height: 20),

                              Row(children: [
                                Expanded(
                                    child:
                                        Divider(color: dark ? C.s600 : C.s300)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text('OR',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12, color: C.s500)),
                                ),
                                Expanded(
                                    child:
                                        Divider(color: dark ? C.s600 : C.s300)),
                              ]),

                              const SizedBox(height: 20),

                              Center(
                                child: GestureDetector(
                                  onTap: () => Get.toNamed(AppRoutes.register),
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: C.s500),
                                      children: [
                                        const TextSpan(
                                          text: "Don't have an account? ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: C.s500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Register Now →',
                                          style: GoogleFonts.poppins(
                                            color: dark ? C.g400 : C.g700,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _ring(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(opacity), width: 1),
      ),
    );
  }
}
