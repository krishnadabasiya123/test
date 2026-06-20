import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/modules/ThemeModule/Controller/theme_cotroller.dart';
import 'package:test/routes/app_routes.dart';

// class ThemeChangeScreen extends StatefulWidget {
//   const ThemeChangeScreen({super.key});

//   @override
//   State<ThemeChangeScreen> createState() => _ThemeChangeScreenState();
// }

// class _ThemeChangeScreenState extends State<ThemeChangeScreen> {
//   final ThemeController controller = Get.put(ThemeController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Change Theme')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(height: 100, width: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10))),
//             SizedBox(height: 10),
//             GestureDetector(
//               onTap: () {
//                 Get.defaultDialog(
//                   title: 'Alert Dialogue',
//                   contentPadding: EdgeInsets.all(20),
//                   backgroundColor: Colors.white,
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text('Open Alert Dialogue'),
//                       SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           Get.back();
//                         },
//                         child: Text('Ok'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                 child: Text('Alert Dialogue'),
//               ),
//             ),
//             SizedBox(height: 10),
//             GestureDetector(
//               onTap: () {
//                 Get.bottomSheet(
//                   Container(
//                     margin: EdgeInsets.only(top: 25),
//                     height: 200,
//                     width: double.infinity,
//                     color: Colors.white,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Open Bottom Sheet'),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           child: Text('Ok'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                 child: Text('Bottom Sheet'),
//               ),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     //controller.changeTheme();
//                     controller.changeTheme();
//                     Get.changeThemeMode(ThemeMode.dark);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     height: 50,
//                     decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: Text('Dark Mode', style: TextStyle(color: Colors.white)),
//                   ),
//                 ),

//                 GestureDetector(
//                   onTap: () {
//                     controller.changeTheme();
//                     Get.changeThemeMode(ThemeMode.light);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     height: 50,
//                     decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: Text('Light Mode', style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class ThemeChangeScreen extends StatefulWidget {
  const ThemeChangeScreen({super.key, required this.title});

  final String title;

  @override
  State<ThemeChangeScreen> createState() => _ThemeChangeScreenState();
}

class _ThemeChangeScreenState extends State<ThemeChangeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => Get.find<ThemeController>().toggleTheme(),
            icon: Obx(
              () => Icon(
                Get.find<ThemeController>().isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(color: Colors.black),
            ),
            Text('counter', style: TextStyle(color: Colors.black)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.TRANSACTION_FORM),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_card_outlined),
                  SizedBox(width: 8),
                  Text(
                    'Open Transaction Form',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
