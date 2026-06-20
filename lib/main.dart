// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:hive/hive.dart';
// import 'package:test/Core/theme_colors.dart';
// import 'package:test/modules/ThemeModule/Controller/theme_cotroller.dart';
// import 'package:test/modules/langauge/models/languages.dart';
// import 'package:test/routes/app_pages.dart';
// import 'package:test/routes/app_routes.dart';
// import 'package:test/screen/home_screen.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Hive.initFlutter();

// //   final ThemeController themeController = Get.find();

// //   await Hive.openBox('themeBox');
// //   runApp(
// //     GetMaterialApp(
// // getPages: AppPages.routes,
// // initialRoute: AppRoutes.THEME,
// //       locale: Locale('hi', 'IN'),
// //       translations: Languages(),
// //       fallbackLocale: Locale('en', 'US'),
// //       theme: Themes.light,
// //       darkTheme: Themes.dark,
// //       themeMode: themeController.themeMode,
// //     ),
// //   );
// // }
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // 1. Initialize Hive
//   await Hive.initFlutter();
//   await Hive.openBox('themeBox');

//   // 2. REGISTER the controller (This fixes your error)
//   Get.put(ThemeController());

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 3. Now you can safely use Get.find
//     final ThemeController themeController = Get.find();

//     return GetMaterialApp(
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: themeController.themeMode,
//       getPages: AppPages.routes,
//       initialRoute: AppRoutes.THEME,
//     );
//   }
// }
// import 'dart:io';
// import 'dart:math' as math;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';

// void main() {
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ImageEditorScreen(),
//     ),
//   );
// }

// class ImageEditorScreen extends StatefulWidget {
//   const ImageEditorScreen({super.key});

//   @override
//   State<ImageEditorScreen> createState() => _ImageEditorScreenState();
// }

// class _ImageEditorScreenState extends State<ImageEditorScreen> {
//   final List<TextLayer> layers = [];
//   int? selectedIndex;

//   // Background Image properties
//   File? _bgImageFile;
//   final String _defaultBgUrl = "https://picsum.photos/800";

//   // Image adjustments
//   double brightness = 1.0;
//   double blur = 0.0;

//   final ImagePicker _picker = ImagePicker();

//   final List<String> fonts = [
//     'Open Sans',
//     'Roboto Slab',
//     'Allura',
//     'Lobster',
//     'Pacifico',
//     'Montserrat',
//   ];

//   final List<Color> colors = [
//     Colors.white,
//     Colors.black,
//     Colors.red,
//     Colors.orange,
//     Colors.yellow,
//     Colors.green,
//     Colors.blue,
//     Colors.indigo,
//     Colors.purple,
//     Colors.pink,
//   ];

//   // Pick background image from gallery
//   Future<void> _pickBackgroundImage() async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.gallery,
//       );
//       if (pickedFile == null) return;

//       final CroppedFile? croppedFile = await ImageCropper().cropImage(
//         sourcePath: pickedFile.path,
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: Colors.grey[900],
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false,
//           ),
//           IOSUiSettings(title: 'Crop Image'),
//         ],
//       );

//       if (croppedFile != null) {
//         setState(() {
//           _bgImageFile = File(croppedFile.path);
//         });
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error picking image: $e")),
//       );
//     }
//   }

//   void addText() {
//     setState(() {
//       layers.add(
//         TextLayer(
//           text: "Double-Tap to Edit",
//           offset: const Offset(100, 200),
//           fontSize: 28,
//           fontName: fonts.first,
//           color: Colors.white,
//           rotation: 0.0, // Initial rotation in radians
//           width: 250.0,
//           height: 80.0,
//           textAlign: TextAlign.center,
//         ),
//       );
//       selectedIndex = layers.length - 1;
//     });
//   }

//   void editText(int index) {
//     TextEditingController controller = TextEditingController(
//       text: layers[index].text,
//     );
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: const Text("Edit Text"),
//           content: TextField(
//             controller: controller,
//             maxLines: null,
//             keyboardType: TextInputType.multiline,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   layers[index].text = controller.text;
//                 });
//                 Navigator.pop(context);
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   TextStyle getFontStyle(TextLayer layer) {
//     TextStyle baseStyle = TextStyle(
//       fontSize: layer.fontSize,
//       color: layer.color,
//     );

//     switch (layer.fontName) {
//       case "Roboto Slab":
//         return GoogleFonts.robotoSlab(textStyle: baseStyle);
//       case "Allura":
//         return GoogleFonts.allura(textStyle: baseStyle);
//       case "Lobster":
//         return GoogleFonts.lobster(textStyle: baseStyle);
//       case "Pacifico":
//         return GoogleFonts.pacifico(textStyle: baseStyle);
//       case "Montserrat":
//         return GoogleFonts.montserrat(textStyle: baseStyle);
//       default:
//         return GoogleFonts.openSans(textStyle: baseStyle);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey canvasKey = GlobalKey();

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("Direct Text Editor"),
//         backgroundColor: Colors.grey[900],
//         actions: [
//           IconButton(
//             onPressed: _pickBackgroundImage,
//             icon: const Icon(Icons.add_photo_alternate),
//             tooltip: "Pick Background Image",
//           ),
//           IconButton(
//             onPressed: addText,
//             icon: const Icon(Icons.text_fields),
//             tooltip: "Add Text",
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // 1. IMAGE EDITOR CANVAS AREA
//           Expanded(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Container(
//                   key: canvasKey,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white12),
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       // Background Image Layer
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedIndex = null; // Tap background to deselect
//                           });
//                         },
//                         child: ImageFiltered(
//                           imageFilter: ImageFilter.blur(
//                             sigmaX: blur,
//                             sigmaY: blur,
//                           ),
//                           child: ColorFiltered(
//                             colorFilter: ColorFilter.matrix([
//                               brightness,
//                               0,
//                               0,
//                               0,
//                               0,
//                               0,
//                               brightness,
//                               0,
//                               0,
//                               0,
//                               0,
//                               0,
//                               brightness,
//                               0,
//                               0,
//                               0,
//                               0,
//                               0,
//                               1,
//                               0,
//                             ]),
//                             child: _bgImageFile != null
//                                 ? Image.file(_bgImageFile!, fit: BoxFit.cover)
//                                 : Image.network(
//                                     _defaultBgUrl,
//                                     fit: BoxFit.cover,
//                                   ),
//                           ),
//                         ),
//                       ),

//                       // Interactive Text Layers
//                       ...List.generate(layers.length, (index) {
//                         final layer = layers[index];
//                         final isSelected = selectedIndex == index;

//                         return Positioned(
//                           left: layer.offset.dx,
//                           top: layer.offset.dy,
//                           child: Transform.rotate(
//                             angle: layer.rotation,
//                             child: Stack(
//                               clipBehavior: Clip.none,
//                               children: [
//                                 // The actual Text widget
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       selectedIndex = index;
//                                     });
//                                   },
//                                   onDoubleTap: () => editText(index),
//                                   onPanStart: (details) {
//                                     setState(() {
//                                       selectedIndex =
//                                           index; // Select on drag start
//                                     });
//                                   },
//                                   onPanUpdate: (details) {
//                                     setState(() {
//                                       layer.offset += details.delta;
//                                     });
//                                   },
//                                   child: Container(
//                                     width: layer.width,
//                                     height: layer.height,
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 10,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       // Shows bounding box border only when selected
//                                       border: isSelected
//                                           ? Border.all(
//                                               color: Colors.blueAccent,
//                                               width: 1.5,
//                                             )
//                                           : null,
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       layer.text,
//                                       textAlign: layer.textAlign,
//                                       style: getFontStyle(layer),
//                                     ),
//                                   ),
//                                 ),

//                                 // Bounding box handles (visible ONLY when selected)
//                                 if (isSelected) ...[
//                                   // 1. ROTATION HANDLE (Top Center)
//                                   Positioned(
//                                     top: -40,
//                                     left: 0,
//                                     right: 0,
//                                     child: Center(
//                                       child: Column(
//                                         children: [
//                                           GestureDetector(
//                                             onPanUpdate: (details) {
//                                               final RenderBox? canvasBox =
//                                                   canvasKey.currentContext
//                                                           ?.findRenderObject()
//                                                       as RenderBox?;
//                                               if (canvasBox != null) {
//                                                 final localCenter = Offset(
//                                                   layer.width / 2,
//                                                   layer.height / 2,
//                                                 );
//                                                 final globalCenter = canvasBox
//                                                     .localToGlobal(
//                                                       layer.offset +
//                                                           localCenter,
//                                                     );
//                                                 final angle = math.atan2(
//                                                   details.globalPosition.dy -
//                                                       globalCenter.dy,
//                                                   details.globalPosition.dx -
//                                                       globalCenter.dx,
//                                                 );
//                                                 setState(() {
//                                                   // Offset by math.pi / 2 because handle is at the top
//                                                   layer.rotation =
//                                                       angle + math.pi / 2;
//                                                 });
//                                               }
//                                             },
//                                             child: _buildHandleIcon(
//                                               Icons.rotate_right,
//                                               Colors.orange,
//                                             ),
//                                           ),
//                                           Container(
//                                             width: 1.5,
//                                             height: 12,
//                                             color: Colors.blueAccent,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),

//                                   // 2. CORNER RESIZE HANDLES (Proportional scaling)
//                                   // Top-Left
//                                   Positioned(
//                                     top: -8,
//                                     left: -8,
//                                     child: _buildCornerResizeHandle(
//                                       layer,
//                                       isLeft: true,
//                                       isTop: true,
//                                       canvasKey: canvasKey,
//                                     ),
//                                   ),
//                                   // Top-Right
//                                   Positioned(
//                                     top: -8,
//                                     right: -8,
//                                     child: _buildCornerResizeHandle(
//                                       layer,
//                                       isLeft: false,
//                                       isTop: true,
//                                       canvasKey: canvasKey,
//                                     ),
//                                   ),
//                                   // Bottom-Left
//                                   Positioned(
//                                     bottom: -8,
//                                     left: -8,
//                                     child: _buildCornerResizeHandle(
//                                       layer,
//                                       isLeft: true,
//                                       isTop: false,
//                                       canvasKey: canvasKey,
//                                     ),
//                                   ),
//                                   // Bottom-Right
//                                   Positioned(
//                                     bottom: -8,
//                                     right: -8,
//                                     child: _buildCornerResizeHandle(
//                                       layer,
//                                       isLeft: false,
//                                       isTop: false,
//                                       canvasKey: canvasKey,
//                                     ),
//                                   ),

//                                   // 3. SIDE RESIZE HANDLES (Smooth width / height adjustment)
//                                   // Left Handle
//                                   Positioned(
//                                     top: 0,
//                                     bottom: 0,
//                                     left: -6,
//                                     child: Center(
//                                       child: _buildSideResizeHandle(
//                                         layer,
//                                         isWidth: true,
//                                         isLeading: true,
//                                       ),
//                                     ),
//                                   ),
//                                   // Right Handle
//                                   Positioned(
//                                     top: 0,
//                                     bottom: 0,
//                                     right: -6,
//                                     child: Center(
//                                       child: _buildSideResizeHandle(
//                                         layer,
//                                         isWidth: true,
//                                         isLeading: false,
//                                       ),
//                                     ),
//                                   ),
//                                   // Top Handle
//                                   Positioned(
//                                     left: 0,
//                                     right: 0,
//                                     top: -6,
//                                     child: Center(
//                                       child: _buildSideResizeHandle(
//                                         layer,
//                                         isWidth: false,
//                                         isLeading: true,
//                                       ),
//                                     ),
//                                   ),
//                                   // Bottom Handle
//                                   Positioned(
//                                     left: 0,
//                                     right: 0,
//                                     bottom: -6,
//                                     child: Center(
//                                       child: _buildSideResizeHandle(
//                                         layer,
//                                         isWidth: false,
//                                         isLeading: false,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // 2. BOTTOM CONTROL PANEL
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(16),
//               ),
//             ),
//             child: selectedIndex == null
//                 ? _buildGlobalCanvasControls()
//                 : _buildSelectedLayerControls(),
//           ),
//         ],
//       ),
//     );
//   }

//   // Corner resize: proportional scaling of box and font size
//   Widget _buildCornerResizeHandle(
//     TextLayer layer, {
//     required bool isLeft,
//     required bool isTop,
//     required GlobalKey canvasKey,
//   }) {
//     double? initialDist;
//     double? initialFontSize;
//     double? initialWidth;
//     double? initialHeight;

//     return GestureDetector(
//       onPanStart: (details) {
//         final RenderBox? canvasBox =
//             canvasKey.currentContext?.findRenderObject() as RenderBox?;
//         if (canvasBox != null) {
//           final localCenter = Offset(layer.width / 2, layer.height / 2);
//           final globalCenter = canvasBox.localToGlobal(
//             layer.offset + localCenter,
//           );
//           initialDist = (details.globalPosition - globalCenter).distance;
//           initialFontSize = layer.fontSize;
//           initialWidth = layer.width;
//           initialHeight = layer.height;
//         }
//       },
//       onPanUpdate: (details) {
//         if (initialDist != null &&
//             initialFontSize != null &&
//             initialWidth != null &&
//             initialHeight != null) {
//           final RenderBox? canvasBox =
//               canvasKey.currentContext?.findRenderObject() as RenderBox?;
//           if (canvasBox != null) {
//             final localCenter = Offset(layer.width / 2, layer.height / 2);
//             final globalCenter = canvasBox.localToGlobal(
//               layer.offset + localCenter,
//             );
//             final currentDist =
//                 (details.globalPosition - globalCenter).distance;

//             final scale = currentDist / initialDist!;
//             setState(() {
//               layer.fontSize = (initialFontSize! * scale).clamp(10.0, 150.0);
//               layer.width = (initialWidth! * scale).clamp(40.0, 800.0);
//               layer.height = (initialHeight! * scale).clamp(20.0, 600.0);
//             });
//           }
//         }
//       },
//       child: Container(
//         width: 14,
//         height: 14,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.blueAccent, width: 2),
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }

//   // Side resize: changes width or height based on local coordinates along rotation axis
//   Widget _buildSideResizeHandle(
//     TextLayer layer, {
//     required bool isWidth,
//     required bool isLeading,
//   }) {
//     return GestureDetector(
//       onPanUpdate: (details) {
//         setState(() {
//           double cosAngle = math.cos(layer.rotation);
//           double sinAngle = math.sin(layer.rotation);

//           if (isWidth) {
//             // Project screen delta onto horizontal axis of rotated text box
//             double localDx =
//                 details.delta.dx * cosAngle + details.delta.dy * sinAngle;
//             if (isLeading) {
//               double newWidth = layer.width - localDx;
//               if (newWidth > 40) {
//                 layer.width = newWidth;
//                 layer.offset += Offset(localDx * cosAngle, localDx * sinAngle);
//               }
//             } else {
//               double newWidth = layer.width + localDx;
//               if (newWidth > 40) {
//                 layer.width = newWidth;
//               }
//             }
//           } else {
//             // Project screen delta onto vertical axis of rotated text box
//             double localDy =
//                 -details.delta.dx * sinAngle + details.delta.dy * cosAngle;
//             if (isLeading) {
//               double newHeight = layer.height - localDy;
//               if (newHeight > 20) {
//                 layer.height = newHeight;
//                 layer.offset += Offset(-localDy * sinAngle, localDy * cosAngle);
//               }
//             } else {
//               double newHeight = layer.height + localDy;
//               if (newHeight > 20) {
//                 layer.height = newHeight;
//               }
//             }
//           }
//         });
//       },
//       child: Container(
//         width: isWidth ? 6 : 16,
//         height: isWidth ? 16 : 6,
//         decoration: BoxDecoration(
//           color: Colors.blueAccent,
//           borderRadius: BorderRadius.circular(2),
//         ),
//       ),
//     );
//   }

//   Widget _buildHandleIcon(IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//         boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
//       ),
//       child: Icon(icon, color: Colors.white, size: 14),
//     );
//   }

//   // Canvas global adjustment sliders
//   Widget _buildGlobalCanvasControls() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _buildSliderRow(
//           "Light",
//           brightness,
//           0.2,
//           1.8,
//           (v) => setState(() => brightness = v),
//         ),
//         _buildSliderRow("Blur", blur, 0, 15, (v) => setState(() => blur = v)),
//       ],
//     );
//   }

//   // Selected Text Layer Controls (Alignment, Font, Color, Font Size)
//   Widget _buildSelectedLayerControls() {
//     final layer = layers[selectedIndex!];

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Top options row: Edit, Duplicate, Layer Order, Delete
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () => editText(selectedIndex!),
//                   icon: const Icon(Icons.edit, color: Colors.white70),
//                   tooltip: "Edit text content",
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     // Duplicate layer
//                     setState(() {
//                       layers.add(
//                         TextLayer(
//                           text: layer.text,
//                           offset: layer.offset + const Offset(20, 20),
//                           fontSize: layer.fontSize,
//                           fontName: layer.fontName,
//                           color: layer.color,
//                           rotation: layer.rotation,
//                           width: layer.width,
//                           height: layer.height,
//                           textAlign: layer.textAlign,
//                         ),
//                       );
//                       selectedIndex = layers.length - 1;
//                     });
//                   },
//                   icon: const Icon(Icons.copy, color: Colors.white70),
//                   tooltip: "Duplicate",
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     // Move layer up
//                     if (selectedIndex! < layers.length - 1) {
//                       setState(() {
//                         final item = layers.removeAt(selectedIndex!);
//                         layers.add(item);
//                         selectedIndex = layers.length - 1;
//                       });
//                     }
//                   },
//                   icon: const Icon(Icons.arrow_upward, color: Colors.white70),
//                   tooltip: "Bring to Front",
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     // Move layer down
//                     if (selectedIndex! > 0) {
//                       setState(() {
//                         final item = layers.removeAt(selectedIndex!);
//                         layers.insert(0, item);
//                         selectedIndex = 0;
//                       });
//                     }
//                   },
//                   icon: const Icon(Icons.arrow_downward, color: Colors.white70),
//                   tooltip: "Send to Back",
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       layers.removeAt(selectedIndex!);
//                       selectedIndex = null;
//                     });
//                   },
//                   icon: const Icon(Icons.delete, color: Colors.redAccent),
//                   tooltip: "Delete",
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       selectedIndex = null; // Deselect
//                     });
//                   },
//                   icon: const Icon(Icons.check, color: Colors.green),
//                   tooltip: "Apply",
//                 ),
//               ],
//             ),
//           ],
//         ),

//         // Text alignment & font size
//         Row(
//           children: [
//             const Text("Align:", style: TextStyle(color: Colors.white70)),
//             IconButton(
//               icon: Icon(
//                 Icons.format_align_left,
//                 color: layer.textAlign == TextAlign.left
//                     ? Colors.blue
//                     : Colors.white54,
//               ),
//               onPressed: () => setState(() => layer.textAlign = TextAlign.left),
//             ),
//             IconButton(
//               icon: Icon(
//                 Icons.format_align_center,
//                 color: layer.textAlign == TextAlign.center
//                     ? Colors.blue
//                     : Colors.white54,
//               ),
//               onPressed: () =>
//                   setState(() => layer.textAlign = TextAlign.center),
//             ),
//             IconButton(
//               icon: Icon(
//                 Icons.format_align_right,
//                 color: layer.textAlign == TextAlign.right
//                     ? Colors.blue
//                     : Colors.white54,
//               ),
//               onPressed: () =>
//                   setState(() => layer.textAlign = TextAlign.right),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: _buildSliderRow(
//                 "Font Size",
//                 layer.fontSize,
//                 10,
//                 150,
//                 (v) => setState(() => layer.fontSize = v),
//               ),
//             ),
//           ],
//         ),

//         // Font Family List
//         SizedBox(
//           height: 36,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: fonts.length,
//             itemBuilder: (context, index) {
//               final font = fonts[index];
//               final isSelected = layer.fontName == font;
//               return GestureDetector(
//                 onTap: () => setState(() => layer.fontName = font),
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: isSelected ? Colors.blue : Colors.grey[800],
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                   child: Text(
//                     font,
//                     style: GoogleFonts.getFont(
//                       font,
//                       color: isSelected ? Colors.white : Colors.white70,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 8),

//         // Color Presets Selector
//         SizedBox(
//           height: 30,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: colors.length,
//             itemBuilder: (context, index) {
//               final color = colors[index];
//               final isSelected = layer.color == color;
//               return GestureDetector(
//                 onTap: () => setState(() => layer.color = color),
//                 child: Container(
//                   width: 30,
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                     border: isSelected
//                         ? Border.all(color: Colors.white, width: 2)
//                         : null,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSliderRow(
//     String label,
//     double value,
//     double min,
//     double max,
//     Function(double) onChanged,
//   ) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 65,
//           child: Text(
//             label,
//             style: const TextStyle(color: Colors.white70, fontSize: 13),
//           ),
//         ),
//         Expanded(
//           child: Slider(
//             value: value,
//             min: min,
//             max: max,
//             activeColor: Colors.blue,
//             inactiveColor: Colors.white24,
//             onChanged: onChanged,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TextLayer {
//   String text;
//   Offset offset;
//   double fontSize;
//   String fontName;
//   Color color;
//   double rotation;
//   double width;
//   double height;
//   TextAlign textAlign;

//   TextLayer({
//     required this.text,
//     required this.offset,
//     required this.fontSize,
//     required this.fontName,
//     required this.color,
//     required this.rotation,
//     required this.width,
//     required this.height,
//     required this.textAlign,
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // REQUIRED for RenderRepaintBoundary
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gal/gal.dart';
import 'dart:ui' as ui;
import 'dart:typed_data'; // CORRECTED import for Uint8List / ByteData
import 'package:test/ui/animatedScreens/pizzOrderAnimation/pizzaHomeScreen.dart';
import 'package:test/ui/animatedScreens/shopping/shopping_home_screen.dart';
import 'package:test/snackbar.dart';
import 'package:get/get.dart';
import 'package:test/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      home: const HolographicSnackBarDemoScreen(),
    ),
  );
}

class ImageEditorApp extends StatelessWidget {
  const ImageEditorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vachanamrut Editor Studio',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.amber,
      ),
      home: const ScriptureListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// =========================================================================
// SCREEN 1: SCRIPTURE SELECTION LIST SCREEN
// =========================================================================
class ScriptureListScreen extends StatelessWidget {
  const ScriptureListScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> _mockScriptures = const [
    {
      "title": "લોયા ૨:૧",
      "lang": "gu",
      "text":
          "સંવત ૧૮૭૭ ના કાર્તિક વદિ ૧૧ એકાદશીને દિવસ સ્વામી શ્રીસહજાનંદજી મહારાજ ગામ શ્રીલોયા મધ્યે સુરાખાચરના દરબારમાં દક્ષિણાદે મુખારવિંદે ઢોલિયા ઉપર વિરાજમાન હતા.\n\nઅને રાતા કિનાખાપનો સુરવાળ પહેર્યો હતો અને નરનારાયણ નામે અંકિત એવો જે કાળો કિનાખાપનો તેની ડગલી પહેરી હતી અને માથે બુરહાનપુરી આસમાની રંગનો રેંટો સોનેરી તારના કરતા છેડાનો બાંધ્યો હતો.",
    },
    {
      "title": "Sarangpur 2:1",
      "lang": "en",
      "text":
          "In the Samvat year 1877, on Shrāvan vad 6 [29th August, 1820], Shreeji Mahārāj was sitting facing north, on a decorated bedstead on the veranda outside.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Text')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _mockScriptures.length,
        itemBuilder: (context, index) {
          final item = _mockScriptures[index];
          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                item["title"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  item["text"]!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkspaceEditorScreen(
                      initialText: item["text"]!,
                      languageCode: item["lang"]!,
                      title: item["title"]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// =========================================================================
// SCREEN 2: ALL-IN-ONE CANVAS EDITOR & ALL FILTERS WORKSPACE
// =========================================================================
class WorkspaceEditorScreen extends StatefulWidget {
  final String initialText;
  final String languageCode;
  final String title;

  const WorkspaceEditorScreen({
    Key? key,
    required this.initialText,
    required this.languageCode,
    required this.title,
  }) : super(key: key);

  @override
  State<WorkspaceEditorScreen> createState() => _WorkspaceEditorScreenState();
}

class _WorkspaceEditorScreenState extends State<WorkspaceEditorScreen> {
  final GlobalKey _canvasRepaintKey = GlobalKey();

  late String _appLanguage;
  int _activeTab = 0; // 0: Fonts, 1: Spacing, 2: Box & Color, 3: Effects

  final List<String> _backgroundImages = [
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&q=80',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=600&q=80',
    'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&q=80',
  ];
  late String _selectedBackground;

  final List<String> _fonts = ['Open Sans', 'Roboto Slab', 'Federo'];
  final Map<String, Map<String, String>> _fontLabels = {
    'en': {
      'Open Sans': 'Open Sans Regular',
      'Roboto Slab': 'Roboto Slab Regular',
      'Federo': 'Federo Script',
    },
    'gu': {
      'Open Sans': 'ઓપન સાંસ',
      'Roboto Slab': 'હિન્દ વડોદરા',
      'Federo': 'ભાવનગર',
    },
  };
  late String _selectedFont;

  bool _isTextSelected = true;
  bool _isExporting = false;

  // Box Position and Metrics
  double _boxTop = 40.0;
  double _boxLeft = 40.0;
  double _boxWidth = 240.0;
  double _boxHeight = 180.0;

  // Formatting configurations
  double _fontSize = 15.0;
  double _lineHeight = 1.4;
  double _letterSpacing = 0.0;

  // CHANGED: Initialized to 0.0 so there is NO text background color layout by default
  double _boxOpacity = 0.0;

  Color _textColor = Colors.white;
  double _blurValue = 0.0;
  double _brightnessValue = 1.0;
  TextAlign _textAlign = TextAlign.center;

  @override
  void initState() {
    super.initState();
    _appLanguage = widget.languageCode;
    _selectedBackground = _backgroundImages[0];
    _selectedFont = _fonts[0];
  }

  Future<void> _exportCanvasToDeviceGallery() async {
    setState(() {
      _isTextSelected = false;
      _isExporting = true;
    });

    await Future.delayed(const Duration(milliseconds: 150));

    try {
      final RenderRepaintBoundary? boundary =
          _canvasRepaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary != null) {
        final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        final ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );

        if (byteData != null) {
          final Uint8List pngBytes = byteData.buffer.asUint8List();

          bool hasAccess = await Gal.hasAccess();
          if (!hasAccess) {
            await Gal.requestAccess();
          }

          await Gal.putImageBytes(pngBytes);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _appLanguage == 'en'
                      ? 'Image exported successfully to Gallery! ✅'
                      : 'છબી સફળતાપૂર્વક ગેલેરીમાં સાચવવામાં આવી! ✅',
                ),
                backgroundColor: Colors.green.shade800,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error exporting image: $e')));
      }
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          DropdownButton<String>(
            value: _appLanguage,
            underline: const SizedBox(),
            icon: const Icon(Icons.language, color: Colors.amber),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English ')),
              DropdownMenuItem(value: 'gu', child: Text('ગુજરાતી ')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _appLanguage = val);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _isTextSelected = false;
          });
        },
        child: Column(
          children: [
            // PREVIEW CANVAS AREA
            Expanded(
              child: Container(
                color: Colors.black45,
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: RepaintBoundary(
                    key: _canvasRepaintKey,
                    child: ClipRect(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double canvasW = constraints.maxWidth;
                          final double canvasH = constraints.maxHeight;

                          _boxWidth = _boxWidth.clamp(120.0, canvasW);
                          _boxHeight = _boxHeight.clamp(70.0, canvasH);
                          _boxLeft = _boxLeft.clamp(0.0, canvasW - _boxWidth);
                          _boxTop = _boxTop.clamp(0.0, canvasH - _boxHeight);

                          return Stack(
                            children: [
                              // Base Background Image Layer
                              Positioned.fill(
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.matrix([
                                    _brightnessValue,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    _brightnessValue,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    _brightnessValue,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    1,
                                    0,
                                  ]),
                                  child: Image.network(
                                    _selectedBackground,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Backdrop Blur Filter
                              if (_blurValue > 0)
                                Positioned.fill(
                                  child: BackdropFilter(
                                    filter: ui.ImageFilter.blur(
                                      sigmaX: _blurValue,
                                      sigmaY: _blurValue,
                                    ),
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                              // Draggable & Hard-Bounded Text Box
                              Positioned(
                                top: _boxTop,
                                left: _boxLeft,
                                width: _boxWidth,
                                height: _boxHeight,
                                child: _buildFourWayResizableContainer(
                                  canvasW,
                                  canvasH,
                                ),
                              ),

                              // BOTTOM-RIGHT LOGO WATERMARK LAYER
                              Positioned(
                                bottom: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.wb_sunny_outlined,
                                        size: 12,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'STUDIO LOGO',
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // DOWNLOAD BUTTON BAR CONTROLLER
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 1.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isExporting ? null : _exportCanvasToDeviceGallery,
                  icon: _isExporting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.file_download, size: 20),
                  label: Text(
                    _isExporting
                        ? (_appLanguage == 'en'
                              ? 'Saving Image...'
                              : 'સાચવી રહ્યાં છે...')
                        : (_appLanguage == 'en'
                              ? 'Download Artwork to Gallery'
                              : 'ગેલેરીમાં ડાઉનલોડ કરો'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

            _buildFilterDashboard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFourWayResizableContainer(double maxW, double maxH) {
    const double minW = 120.0;
    const double minH = 70.0;
    // Increased handle size slightly to match the prominent round buttons in the screenshot
    const double handleSize = 32.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // MAIN DISPLAY TEXT DRAG CONTROLLER
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _isTextSelected = true;
              });
            },
            onPanUpdate: (details) {
              if (_isTextSelected) {
                setState(() {
                  _boxLeft = (_boxLeft + details.delta.dx).clamp(
                    0.0,
                    maxW - _boxWidth,
                  );
                  _boxTop = (_boxTop + details.delta.dy).clamp(
                    0.0,
                    maxH - _boxHeight,
                  );
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(_boxOpacity),
                // MATCHES THE SCREENSHOT: Continuous solid blue border boundary lines
                border: Border.all(
                  color: _isTextSelected
                      ? const Color(0xFF2196F3)
                      : Colors.transparent,
                  width: _isTextSelected ? 2.0 : 0.0,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    widget.initialText,
                    textAlign: _textAlign,
                    style: GoogleFonts.getFont(
                      _selectedFont,
                      textStyle: TextStyle(
                        color: _textColor,
                        fontSize: _fontSize,
                        height: _lineHeight,
                        letterSpacing: _letterSpacing,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // MATCHES THE SCREENSHOT: Midpoint Edge Handles
        if (_isTextSelected) ...[
          // TOP HANDLE
          Positioned(
            top: -handleSize / 2,
            left: 0,
            right: 0,
            height: handleSize,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (d) {
                  setState(() {
                    double proposedTop = _boxTop + d.delta.dy;
                    double proposedHeight = _boxHeight - d.delta.dy;
                    if (proposedTop >= 0 && proposedHeight >= minH) {
                      _boxTop = proposedTop;
                      _boxHeight = proposedHeight;
                    }
                  });
                },
                child: _buildScreenshotStyleHandle(),
              ),
            ),
          ),
          // BOTTOM HANDLE
          Positioned(
            bottom: -handleSize / 2,
            left: 0,
            right: 0,
            height: handleSize,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (d) {
                  setState(() {
                    double maxHeightLimit = maxH - _boxTop;
                    _boxHeight = (_boxHeight + d.delta.dy).clamp(
                      minH,
                      maxHeightLimit,
                    );
                  });
                },
                child: _buildScreenshotStyleHandle(),
              ),
            ),
          ),
          // LEFT HANDLE
          Positioned(
            left: -handleSize / 2,
            top: 0,
            bottom: 0,
            width: handleSize,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (d) {
                  setState(() {
                    double proposedLeft = _boxLeft + d.delta.dx;
                    double proposedWidth = _boxWidth - d.delta.dx;
                    if (proposedLeft >= 0 && proposedWidth >= minW) {
                      _boxLeft = proposedLeft;
                      _boxWidth = proposedWidth;
                    }
                  });
                },
                child: _buildScreenshotStyleHandle(),
              ),
            ),
          ),
          // RIGHT HANDLE
          Positioned(
            right: -handleSize / 2,
            top: 0,
            bottom: 0,
            width: handleSize,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (d) {
                  setState(() {
                    double maxWidthLimit = maxW - _boxLeft;
                    _boxWidth = (_boxWidth + d.delta.dx).clamp(
                      minW,
                      maxWidthLimit,
                    );
                  });
                },
                child: _buildScreenshotStyleHandle(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Helper widget that paints the precise blue circle handles with internal indicator lines
  Widget _buildScreenshotStyleHandle() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFF2196F3), // Accurate bright blue background
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons
              .blur_linear, // Dotted grid adjustment indicator icon matches the artwork style
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHandleUI(Axis axis) {
    return Center(
      child: Container(
        width: axis == Axis.vertical ? 6 : 30,
        height: axis == Axis.vertical ? 30 : 6,
        decoration: BoxDecoration(
          color: Colors.blue.shade600,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildFilterDashboard() {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ONLY the top tab navigation items are horizontally scrollable
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _tabButton(
                  0,
                  Icons.font_download,
                  _appLanguage == 'en' ? "Fonts" : "ફોન્ટ્સ",
                ),
                const SizedBox(width: 5),
                _tabButton(
                  1,
                  Icons.format_line_spacing,
                  _appLanguage == 'en' ? "Spacing" : "જગ્યા",
                ),
                const SizedBox(width: 8),
                _tabButton(
                  2,
                  Icons.layers,
                  _appLanguage == 'en' ? "Box & Color" : "બોક્સ",
                ),
                const SizedBox(width: 8),
                _tabButton(
                  3,
                  Icons.tune,
                  _appLanguage == 'en' ? "Effects" : "ઇફેક્ટ્સ",
                ),
                // Feel free to append more tabs here safely now!
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 120,
              // The controller dashboard remains fully wide and functional
              child: _renderActiveTabControls(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(int index, IconData icon, String label) {
    final isSelected = _activeTab == index;
    return TextButton.icon(
      onPressed: () => setState(() => _activeTab = index),
      icon: Icon(
        icon,
        color: isSelected ? Colors.amber : Colors.grey,
        size: 18,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.amber : Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _renderActiveTabControls() {
    switch (_activeTab) {
      case 0:
        return ListView.builder(
          itemCount: _fonts.length,
          itemBuilder: (context, index) {
            final fKey = _fonts[index];
            final label = _fontLabels[_appLanguage]?[fKey] ?? fKey;
            return ListTile(
              dense: true,
              title: Text(
                label,
                style: TextStyle(
                  color: _selectedFont == fKey ? Colors.amber : Colors.white,
                ),
              ),
              trailing: _selectedFont == fKey
                  ? const Icon(Icons.check, color: Colors.amber)
                  : null,
              onTap: () => setState(() => _selectedFont = fKey),
            );
          },
        );
      case 1:
      case 1:
        return Column(
          mainAxisSize: MainAxisSize.min, // Keep the column tightly packed
          mainAxisAlignment: MainAxisAlignment
              .center, // Center controls vertically without wasting space
          children: [
            // Align buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  visualDensity:
                      VisualDensity.compact, // Removes internal button padding
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.format_align_left, size: 20),
                  color: _textAlign == TextAlign.left
                      ? Colors.amber
                      : Colors.white,
                  onPressed: () => setState(() => _textAlign = TextAlign.left),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.format_align_center, size: 20),
                  color: _textAlign == TextAlign.center
                      ? Colors.amber
                      : Colors.white,
                  onPressed: () =>
                      setState(() => _textAlign = TextAlign.center),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.format_align_right, size: 20),
                  color: _textAlign == TextAlign.right
                      ? Colors.amber
                      : Colors.white,
                  onPressed: () => setState(() => _textAlign = TextAlign.right),
                ),
              ],
            ),
            // Removed extra vertical spacing / SizedBoxes completely
            _sliderRow(
              Icons.text_fields,
              _fontSize,
              10,
              30,
              (v) => setState(() => _fontSize = v),
            ),
            _sliderRow(
              Icons.format_line_spacing,
              _lineHeight,
              0.8,
              2.5,
              (v) => setState(() => _lineHeight = v),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            _sliderRow(
              Icons.opacity,
              _boxOpacity,
              0.0,
              1.0,
              (v) => setState(() => _boxOpacity = v),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _textColor.withOpacity(0.8),
              ),
              onPressed: _showColorPickerDialog,
              icon: const Icon(Icons.color_lens, color: Colors.black),
              label: Text(
                _appLanguage == 'en'
                    ? 'Select Text Color'
                    : 'ટેક્સ્ટ રંગ પસંદ કરો',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _sliderRow(
              Icons.blur_on,
              _blurValue,
              0.0,
              7.0,
              (v) => setState(() => _blurValue = v),
            ),
            const SizedBox(height: 5),
            _sliderRow(
              Icons.wb_sunny,
              _brightnessValue,
              0.3,
              1.8,
              (v) => setState(() => _brightnessValue = v),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _sliderRow(
    IconData icon,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        Icon(icon, size: 11, color: Colors.grey),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            activeColor: Colors.amber,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _appLanguage == 'en' ? 'Pick Text Color' : 'ટેક્સ્ટ રંગ પસંદ કરો',
        ),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _textColor,
            onColorChanged: (color) {
              setState(() => _textColor = color);
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
