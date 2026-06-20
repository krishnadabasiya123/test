import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test/ui/animatedScreens/shopping/models/product.dart';
import 'package:test/ui/animatedScreens/shopping/shopping_details_screen.dart';
import 'package:test/ui/animatedScreens/shopping/utils/holo_painters.dart';

class ShoppingHomeScreen extends StatefulWidget {
  const ShoppingHomeScreen({Key? key}) : super(key: key);

  @override
  _ShoppingHomeScreenState createState() => _ShoppingHomeScreenState();
}

class _ShoppingHomeScreenState extends State<ShoppingHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void initState() {
    super.initState();
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17), // Deep space/cyberpunk dark blue
      body: Stack(
        children: [
          // Background Cyber Grid Decorative Effect
          _buildBackgroundGrid(),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header Area
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "N E O N",
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4.0,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "FIT STUDIO",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        // Cart / Profile Hologram Button
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.2),
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 22,
                            child: Icon(
                              CupertinoIcons.square_grid_2x2,
                              color: Colors.cyanAccent,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Subtitle / Intro Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyanAccent.withOpacity(0.1),
                            Colors.purpleAccent.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.sparkles,
                            color: Colors.cyanAccent,
                            size: 24,
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Holographic Try-On Active",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "Select any garment to test fit on the human model.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Grid of items
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = mockProducts[index];
                        return _buildStaggeredItem(product, index);
                      },
                      childCount: mockProducts.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return Positioned.fill(
      child: CustomPaint(
        painter: GridBackgroundPainter(),
      ),
    );
  }

  Widget _buildStaggeredItem(Product product, int index) {
    // Staggered slide up & fade animation
    final double delay = (index * 0.15).clamp(0.0, 1.0);
    final Animation<double> cardAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Interval(delay, delay + 0.45, curve: Curves.easeOutCubic),
      ),
    );

    return AnimatedBuilder(
      animation: cardAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1.0 - cardAnim.value) * 60.0),
          child: Opacity(
            opacity: cardAnim.value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, anim, secAnim) => ShoppingDetailsScreen(product: product),
              transitionsBuilder: (context, anim, secAnim, child) {
                return FadeTransition(opacity: anim, child: child);
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131A26),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: product.primaryColor.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: product.primaryColor.withOpacity(0.04),
                blurRadius: 12.0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Floating Holographic Preview Area
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E131C),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.white.withOpacity(0.03)),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: CustomPaint(
                        painter: ClothingPainter(
                          type: product.type,
                          color: product.primaryColor,
                          animationVal: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Title and Price info
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: product.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 13,
                            ),
                            const SizedBox(width: 2.0),
                            Text(
                              "${product.rating}",
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.02)
      ..strokeWidth = 1.0;

    final double gridSpace = 40.0;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += gridSpace) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), linePaint);
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += gridSpace) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
