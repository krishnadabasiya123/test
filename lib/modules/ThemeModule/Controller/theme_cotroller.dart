import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

// class ThemeService {
//   // Use a private box instance.
//   // Ensure Hive.openBox('themeBox') is called in your main() before using this.
//   final Box _box = Hive.box('themeBox');

//   final String _settingsThemeKey = 'theme';
//   final String _darkThemeValue = 'darkTheme';
//   final String _lightThemeValue = 'lightTheme';

//   /// Get the current theme string from storage
//   String get _themeModeString => _box.get(_settingsThemeKey, defaultValue: _lightThemeValue);

//   /// Convert the stored string into a [ThemeMode] for GetMaterialApp
//   ThemeMode get themeMode => _themeModeString == _darkThemeValue ? ThemeMode.dark : ThemeMode.light;

//   /// Switch the theme and save the choice to Hive
//   void switchTheme() {
//     // 1. Determine the new mode
//     bool isDarkMode = _themeModeString == _darkThemeValue;
//     String newThemeString = isDarkMode ? _lightThemeValue : _darkThemeValue;
//     ThemeMode newThemeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;

//     // 2. Change the theme in the UI using GetX
//     Get.changeThemeMode(newThemeMode);

//     // 3. Save the new selection to Hive
//     _box.put(_settingsThemeKey, newThemeString);
//   }
// }

class ThemeController extends GetxController {
  // Access the Hive box (Make sure Hive.openBox('themeBox') is called in main)
  final Box _box = Hive.box('themeBox');

  final String _key = 'theme';
  final String _darkValue = 'darkTheme';
  final String _lightValue = 'lightTheme';

  /// Get the current theme from storage
  String get _storedTheme => _box.get(_key, defaultValue: _lightValue);

  /// Getter for the UI (GetMaterialApp)
  ThemeMode get themeMode => _storedTheme == _darkValue ? ThemeMode.dark : ThemeMode.light;

  /// Reactive variable to track if it's dark (useful for UI switches)
  late RxBool isDarkMode;

  @override
  void onInit() {
    super.onInit();
    // Initialize the reactive variable based on stored data
    isDarkMode = (_storedTheme == _darkValue).obs;
  }

  /// Toggle the theme
  void toggleTheme() {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      _box.put(_key, _lightValue);
      isDarkMode.value = false;
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      _box.put(_key, _darkValue);
      isDarkMode.value = true;
    }
  }
}
