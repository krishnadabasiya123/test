import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/routes/app_routes.dart';

class FirstScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const FirstScreen({super.key, this.data});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Map<String, dynamic>? data;
  Map<String, dynamic>? result;

  @override
  void initState() {
    super.initState();
    data = Get.arguments as Map<String, dynamic>?;
    result = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Screen')),
      body: Column(
        children: [
          Text('Name: ${data?['name']}'),
          Text('Age: ${data?['age']}'),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.SECOND_SCREEN, arguments: {'name': 'Krishna', 'age': 28})?.then((value) {
                  print(value);
                  setState(() {
                    result = value as Map<String, dynamic>?;
                  });
                });
              },
              child: const Text('Go to Second Screen'),
            ),
          ),
          if (result != null) Text('Result: ${result?['name']}'),
        ],
      ),
    );
  }
}
