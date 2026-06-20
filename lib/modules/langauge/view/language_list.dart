import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/modules/langauge/controller/langauage_controller.dart';

class LanguageView extends StatelessWidget {
  final LanguageController controller = Get.put(LanguageController());

  LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use .tr to translate
        title: Text('title'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('hello'.tr, style: TextStyle(fontSize: 25)),
            SizedBox(height: 20),

            ElevatedButton(child: Text("English"), onPressed: () => controller.changeLanguage('en', 'US')),
            ElevatedButton(child: Text("Hindi (हिंदी)"), onPressed: () => controller.changeLanguage('hi', 'IN')),
            ElevatedButton(child: Text("French (Français)"), onPressed: () => controller.changeLanguage('fr', 'FR')),
          ],
        ),
      ),
    );
  }
}
