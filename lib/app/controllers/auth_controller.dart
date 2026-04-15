import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final isLoading = false.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userBiz = ''.obs;
  final userId = ''.obs;

  User? get firebaseUser => _auth.currentUser;
  bool get isLoggedIn => firebaseUser != null;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        userId.value = user.uid;
        userEmail.value = user.email ?? '';
        _loadUserProfile(user.uid);
      } else {
        userId.value = '';
        userName.value = '';
        userEmail.value = '';
        userBiz.value = '';
      }
    });
  }

  Future<void> _loadUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        final d = doc.data()!;
        userName.value = d['name'] ?? '';
        userBiz.value = d['businessName'] ?? '';
      }
    } catch (e) {
      // ignore
    }
  }

  // ── Register ───────────────────────────────────────────────
  Future<void> register(
      String name, String email, String pass, String biz) async {
    isLoading.value = true;
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: pass,
      );
      final uid = cred.user!.uid;

      // Save profile to Firestore
      await _db.collection('users').doc(uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'businessName': biz.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      userName.value = name.trim();
      userBiz.value = biz.trim();
      userEmail.value = email.trim();
      userId.value = uid;

      isLoading.value = false;
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Registration Failed',
        _authError(e.code),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    }
  }

  // ── Login ──────────────────────────────────────────────────
  Future<void> login(String email, String pass) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: pass,
      );
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Login Failed',
        _authError(e.code),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    }
  }

  // ── Logout ─────────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  // ── Forgot Password ────────────────────────────────────────
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      Get.snackbar('Email Sent', 'Password reset link sent to $email',
          snackPosition: SnackPosition.BOTTOM);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', _authError(e.code),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  String _authError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try later.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Authentication failed. Please check your details and try again.';
    }
  }
}
