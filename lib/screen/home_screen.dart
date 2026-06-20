import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:test/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.offAndToNamed(AppRoutes.FIRST_SCREEN, arguments: {'name': 'John', 'age': 25});
              },
              child: const Text('Go to First Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.PIZZA_HOME);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff541414),
                foregroundColor: Colors.white,
              ),
              child: const Text('Go to Pizza Home Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.ICE_CREAM);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9A9E),
                foregroundColor: Colors.white,
              ),
              child: const Text('Go to Ice Cream Shop'),
            ),
          ],
        ),
      ),
    );
  }
}
