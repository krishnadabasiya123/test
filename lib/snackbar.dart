import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test/routes/app_routes.dart';

class HolographicSnackBar {
  static const Duration displayDuration = Duration(milliseconds: 2500);

  // Simple list of active notifications (no custom models, just Map<String, String>)
  static final ValueNotifier<List<Map<String, String>>> activeNotifications =
      ValueNotifier([]);
  static OverlayEntry? _overlayEntry;

  static Future<void> show({
    required BuildContext context,
    required String message,
    required String title,
    Color? themeColor,
    IconData? icon,
  }) async {
    final String uniqueId = DateTime.now().microsecondsSinceEpoch.toString();

    final newNotification = {
      'id': uniqueId,
      'title': title,
      'message': message,
    };

    // Append to list
    final currentList = List<Map<String, String>>.from(
      activeNotifications.value,
    );
    currentList.add(newNotification);
    activeNotifications.value = currentList;

    // Trigger timer to remove this specific notification after duration
    Timer(displayDuration, () {
      removeNotification(uniqueId);
    });

    // Check if Overlay is currently rendered
    if (_overlayEntry == null) {
      final overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(
        builder: (context) => const HolographicSnackBarOverlayContainer(),
      );
      overlayState.insert(_overlayEntry!);
    }
  }

  static void removeNotification(String id) {
    final currentList = List<Map<String, String>>.from(
      activeNotifications.value,
    );
    currentList.removeWhere((item) => item['id'] == id);
    activeNotifications.value = currentList;
  }

  static void cleanOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}

class HolographicSnackBarOverlayContainer extends StatefulWidget {
  const HolographicSnackBarOverlayContainer({Key? key}) : super(key: key);

  @override
  State<HolographicSnackBarOverlayContainer> createState() =>
      _HolographicSnackBarOverlayContainerState();
}

class _HolographicSnackBarOverlayContainerState
    extends State<HolographicSnackBarOverlayContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  late final Animation<double> _scaleAnimation =
      Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
      );

  late final Animation<double> _fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));

  // Slide offset animation to slide up from bottom screen and slide back down on reverse
  late final Animation<double> _slideOffsetAnimation = Tween<double>(
    begin: -150.0,
    end: 0.0,
  ).animate(
    CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    ),
  );

  @override
  void initState() {
    super.initState();
    _animController.forward();
    HolographicSnackBar.activeNotifications.addListener(_listListener);
  }

  @override
  void dispose() {
    HolographicSnackBar.activeNotifications.removeListener(_listListener);
    _animController.dispose();
    super.dispose();
  }

  void _listListener() {
    // If the list is empty, slide down/fade out and clean overlay
    if (HolographicSnackBar.activeNotifications.value.isEmpty) {
      if (mounted) {
        _animController.reverse().then((_) {
          HolographicSnackBar.cleanOverlay();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.9;
    final double cardHeight = 110.0;

    return ValueListenableBuilder<List<Map<String, String>>>(
      valueListenable: HolographicSnackBar.activeNotifications,
      builder: (context, list, child) {
        if (list.isEmpty) return const SizedBox();

        // Newest is the last item in the list
        final newestNotification = list.last;
        final String title = newestNotification['title'] ?? '';
        final String message = newestNotification['message'] ?? '';
        final int moreCount = list.length - 1;

        return AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Positioned(
              left: screenWidth * 0.05,
              bottom: 80.0 + _slideOffsetAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // 1. Background Card 2 (Top-most card in the deck, peeking above)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        bottom: list.length >= 3 ? 16.0 : 0.0,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          scale: list.length >= 3 ? 0.90 : 1.0,
                          alignment: Alignment.bottomCenter,
                          child: _buildEmptyCardBack(cardWidth, cardHeight),
                        ),
                      ),

                      // 2. Background Card 1 (Middle card in the deck, peeking above)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        bottom: list.length >= 2 ? 8.0 : 0.0,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          scale: list.length >= 2 ? 0.95 : 1.0,
                          alignment: Alignment.bottomCenter,
                          child: _buildEmptyCardBack(cardWidth, cardHeight),
                        ),
                      ),

                      // 3. Foreground Card (Main Card showing active notification content)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.25),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: _buildMainCard(
                          cardWidth,
                          cardHeight,
                          title,
                          message,
                          moreCount,
                          key: ValueKey(newestNotification['id']),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyCardBack(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8.0),
        ],
      ),
    );
  }

  Widget _buildMainCard(
    double width,
    double height,
    String title,
    String message,
    int moreCount, {
    Key? key,
  }) {
    return Container(
      key: key,
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Premium light grey background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Icon
              const Icon(
                CupertinoIcons.profile_circled,
                size: 38,
                color: Colors.black45,
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          if (moreCount > 0)
            Text(
              "$moreCount more notification",
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class HolographicSnackBarDemoScreen extends StatelessWidget {
  const HolographicSnackBarDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17), // Match deep space theme
      appBar: AppBar(
        title: const Text("Holographic SnackBar Demo"),
        backgroundColor: const Color(0xFF131A26),
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "HOLOGRAPHIC NOTIFICATION TESTER",
              style: TextStyle(
                color: Colors.white30,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap multiple times quickly to stack card layers above!",
              style: TextStyle(color: Colors.white60, fontSize: 13.0),
            ),
            const SizedBox(height: 30),

            // Trigger Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.3),
                    blurRadius: 16.0,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: const Color(0xFF0A0E17),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                onPressed: () {
                  HolographicSnackBar.show(
                    context: context,
                    title:
                        "OakTree ${HolographicSnackBar.activeNotifications.value.length + 1}",
                    message: "We believe in the power of mobile computing.",
                    themeColor: Colors.cyanAccent,
                  );
                },
                icon: const Icon(CupertinoIcons.bolt_fill, size: 18),
                label: const Text("GENERATE SNACKBAR"),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF9A9E).withOpacity(0.3),
                    blurRadius: 16.0,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9A9E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.ICE_CREAM);
                },
                icon: const Icon(CupertinoIcons.drop_fill, size: 18),
                label: const Text("GO TO ICE CREAM SHOP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
