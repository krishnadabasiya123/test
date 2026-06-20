import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/routes/app_routes.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key, this.data});
  final Map<String, dynamic>? data;

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    data = Get.arguments as Map<String, dynamic>?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Column(
        children: [
          Text('Name: ${data?['name']}'),

          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.LANGUAGE);
              },
              child: const Text('Language'),
            ),
          ),

          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                Container(
                  color: Colors.blue,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.changeTheme(ThemeData.light());
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Center(child: Text('Light Theme')),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Get.changeTheme(ThemeData.dark());
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Center(child: Text('Dark Theme')),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              height: 100,
              width: 100,
              color: Colors.red,
              child: Center(child: Text('Open BottomSheet')),
            ),
          ),
        ],
      ),
    );
  }
}
