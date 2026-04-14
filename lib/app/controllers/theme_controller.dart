import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDark.value = _box.read('isDark') ?? false;
    _apply();
  }

  void toggle() {
    isDark.value = !isDark.value;
    _box.write('isDark', isDark.value);
    _apply();
  }

  void _apply() => Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  ThemeMode get mode => isDark.value ? ThemeMode.dark : ThemeMode.light;
}
