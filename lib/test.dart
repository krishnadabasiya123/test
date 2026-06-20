import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:ui';

void main() {
  runApp(const ImageEditorApp());
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
          "સંવત ૧૮૭૭ ના કાર્તિક વદિ ૧૧ એકાદશીને દિવસ સ્વામી શ્રીસહજાનંદજી મહારાજ ગામ શ્રીલોયા મધ્યે સુરાખાચરના દરબારમાં દક્ષિણાદે મુખારવિંદે ઢોલિયા ઉપર વિરાજમાન હતા.",
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
        padding: const EdgeInsets.all(16),
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

  // Box Position and Bounds State Metrics
  double _boxTop = 80.0;
  double _boxLeft = 30.0;
  double _boxWidth = 330.0;
  double _boxHeight = 180.0;

  // Filter Target Properties
  double _fontSize = 14.0;
  double _lineHeight = 1.3;
  double _letterSpacing = 0.0;
  double _boxOpacity = 0.25;
  Color _themeColor = Colors.black87;
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
      body: Column(
        children: [
          // PREVIEW GRAPHIC STUDIO CANVAS
          Expanded(
            child: Container(
              color: Colors.black45,
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRect(
                  child: Stack(
                    children: [
                      // Base Background Image
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
                      // Image Blur Layer Filter Effect
                      if (_blurValue > 0)
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: _blurValue,
                              sigmaY: _blurValue,
                            ),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      // Draggable Moveable Resizable Container Box Frame
                      Positioned(
                        top: _boxTop,
                        left: _boxLeft,
                        width: _boxWidth,
                        height: _boxHeight,
                        child: _buildFourWayResizableContainer(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // MODIFIER FILTERS MANAGEMENT PANEL CONTROL
          _buildFilterDashboard(),
        ],
      ),
    );
  }

  Widget _buildFourWayResizableContainer() {
    const double minW = 120.0;
    const double minH = 70.0;
    const double handleSize =
        24.0; // Touch Target Pad Area size for smooth interaction

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // MAIN DISPLAY TEXT BOX CONTAINER (Manages Dragging/Movement)
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: (details) {
              setState(() {
                _boxLeft += details.delta.dx;
                _boxTop += details.delta.dy;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _themeColor.withOpacity(_boxOpacity),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.initialText,
                textAlign: _textAlign,
                style: GoogleFonts.getFont(
                  _selectedFont,
                  textStyle: TextStyle(
                    color: _themeColor.computeLuminance() > 0.4
                        ? Colors.black
                        : Colors.white,
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

        // TOP RESIZE HANDLE (Translucent Gesture)
        Positioned(
          top: -handleSize / 2,
          left: handleSize,
          right: handleSize,
          height: handleSize,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (d) {
              setState(() {
                double proposedTop = _boxTop + d.delta.dy;
                double proposedHeight = _boxHeight - d.delta.dy;
                if (proposedHeight >= minH) {
                  _boxTop = proposedTop;
                  _boxHeight = proposedHeight;
                }
              });
            },
            child: _buildHandleUI(Axis.horizontal),
          ),
        ),

        // BOTTOM RESIZE HANDLE (Translucent Gesture)
        Positioned(
          bottom: -handleSize / 2,
          left: handleSize,
          right: handleSize,
          height: handleSize,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (d) {
              setState(() {
                double proposedHeight = _boxHeight + d.delta.dy;
                if (proposedHeight >= minH) _boxHeight = proposedHeight;
              });
            },
            child: _buildHandleUI(Axis.horizontal),
          ),
        ),

        // LEFT RESIZE HANDLE (Translucent Gesture)
        Positioned(
          left: -handleSize / 2,
          top: handleSize,
          bottom: handleSize,
          width: handleSize,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (d) {
              setState(() {
                double proposedLeft = _boxLeft + d.delta.dx;
                double proposedWidth = _boxWidth - d.delta.dx;
                if (proposedWidth >= minW) {
                  _boxLeft = proposedLeft;
                  _boxWidth = proposedWidth;
                }
              });
            },
            child: _buildHandleUI(Axis.vertical),
          ),
        ),

        // RIGHT RESIZE HANDLE (Translucent Gesture)
        Positioned(
          right: -handleSize / 2,
          top: handleSize,
          bottom: handleSize,
          width: handleSize,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (d) {
              setState(() {
                double proposedWidth = _boxWidth + d.delta.dx;
                if (proposedWidth >= minW) _boxWidth = proposedWidth;
              });
            },
            child: _buildHandleUI(Axis.vertical),
          ),
        ),
      ],
    );
  }

  Widget _buildHandleUI(Axis axis) {
    return Center(
      child: Container(
        width: axis == Axis.vertical ? 8 : 34,
        height: axis == Axis.vertical ? 34 : 8,
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _tabButton(
                0,
                Icons.font_download,
                _appLanguage == 'en' ? "Fonts" : "ફોન્ટ્સ",
              ),
              _tabButton(
                1,
                Icons.format_line_spacing,
                _appLanguage == 'en' ? "Spacing" : "જગ્યા",
              ),
              _tabButton(
                2,
                Icons.layers,
                _appLanguage == 'en' ? "Box & Color" : "બોક્સ",
              ),
              _tabButton(
                3,
                Icons.tune,
                _appLanguage == 'en' ? "Effects" : "ઇફેક્ટ્સ",
              ),
            ],
          ),
          const Divider(height: 1, color: Colors.white12),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(height: 130, child: _renderActiveTabControls()),
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
      case 0: // Fonts Selector Panel
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
      case 1: // Typography Sizing Formatting Sliders Panel
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.format_align_left),
                  color: _textAlign == TextAlign.left
                      ? Colors.amber
                      : Colors.white,
                  onPressed: () => setState(() => _textAlign = TextAlign.left),
                ),
                IconButton(
                  icon: const Icon(Icons.format_align_center),
                  color: _textAlign == TextAlign.center
                      ? Colors.amber
                      : Colors.white,
                  onPressed: () =>
                      setState(() => _textAlign = TextAlign.center),
                ),
                IconButton(
                  icon: const Icon(Icons.format_align_right),
                  color: _textAlign == TextAlign.right
                      ? Colors.amber
                      : Colors.white,
                  onPressed: () => setState(() => _textAlign = TextAlign.right),
                ),
              ],
            ),
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
      case 2: // Container Background Opacity & Theme Color Picker Panel
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
              style: ElevatedButton.styleFrom(backgroundColor: _themeColor),
              onPressed: _showColorPickerDialog,
              icon: const Icon(Icons.color_lens, color: Colors.white),
              label: Text(
                _appLanguage == 'en'
                    ? 'Select Color Theme'
                    : 'થીમ રંગ પસંદ કરો',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      case 3: // Canvas Filters Modifiers Panel (Blur & Brightness)
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
            const SizedBox(height: 10),
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
        Icon(icon, size: 16, color: Colors.grey),
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
        title: const Text('Pick Theme Color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _themeColor,
            onColorChanged: (color) {
              setState(() => _themeColor = color);
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
