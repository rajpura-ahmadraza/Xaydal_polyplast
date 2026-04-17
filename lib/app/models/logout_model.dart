import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

void showPremiumLogoutDialog(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),

            // 🔥 GOLD BORDER
            border: Border.all(
              color: const Color(0xFFD4AF37), // gold
              width: 1.2,
            ),

            // ✨ SHADOW
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔥 ICON
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFD4AF37),
                      Color(0xFFFFD700),
                    ],
                  ),
                ),
                child: const Icon(Icons.logout, color: Colors.black, size: 28),
              ),

              const SizedBox(height: 16),

              // TITLE
              Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              // SUBTITLE
              Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white70 : Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              // BUTTONS
              Row(
                children: [
                  // CANCEL
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: const Color(0xFFD4AF37)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // LOGOUT
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        var auth = Get.find<AuthController>();
                        auth.logout();
                        // 👉 YOUR LOGOUT LOGIC HERE
                        // Example:
                        // controller.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37), // GOLD
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
