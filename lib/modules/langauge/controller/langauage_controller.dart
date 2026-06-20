import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  //static Controller get to => Get.find();
  void changeLanguage(String langCode, String countryCode) {
    var locale = Locale(langCode, countryCode);
    Get.updateLocale(locale);
  }
}
