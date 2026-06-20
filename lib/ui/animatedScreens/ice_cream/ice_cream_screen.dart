import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'models/ice_cream_model.dart';

class IceCreamHomeScreen extends StatefulWidget {
  const IceCreamHomeScreen({Key? key}) : super(key: key);

  @override
  State<IceCreamHomeScreen> createState() => _IceCreamHomeScreenState();
}

class _IceCreamHomeScreenState extends State<IceCreamHomeScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  double _pageOffset = 0.0;
  int _selectedSize = 1; // 0 = Small, 1 = Medium, 2 = Large
  int _cartCount = 0;
  final Set<int> _favorites = {};

  // For button tap animations
  late AnimationController _cartButtonController;
  late AnimationController _favButtonController;

  // Custom ColorFilter to make the white background of generated images transparent
  // Alpha = 5 * A - 2 * R - 2 * G - 2 * B.
  // This effectively keys out pixels where R, G, and B are all high (white/off-white)
  final ColorFilter _whiteToTransparentFilter = const ColorFilter.matrix(<double>[
    1.0, 0.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0, 0.0,
    -2.0, -2.0, -2.0, 5.0, 0.0,
  ]);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.76)
      ..addListener(() {
        setState(() {
          _pageOffset = _pageController.page ?? 0.0;
        });
      });

    _cartButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _favButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cartButtonController.dispose();
    _favButtonController.dispose();
    super.dispose();
  }

  // Interpolate between colors of the current gradient and the next gradient
  List<Color> _getCurrentGradient() {
    int currentIndex = _pageOffset.floor();
    double fraction = _pageOffset - currentIndex;

    currentIndex = currentIndex.clamp(0, iceCreamItems.length - 1);
    int nextIndex = (currentIndex + 1).clamp(0, iceCreamItems.length - 1);

    List<Color> currentColors = iceCreamItems[currentIndex].bgGradient;
    List<Color> nextColors = iceCreamItems[nextIndex].bgGradient;

    List<Color> interpolated = [];
    for (int i = 0; i < currentColors.length; i++) {
      interpolated.add(Color.lerp(currentColors[i], nextColors[i], fraction)!);
    }
    return interpolated;
  }

  double _getSizeScale() {
    switch (_selectedSize) {
      case 0:
        return 0.82;
      case 2:
        return 1.15;
      case 1:
      default:
        return 1.0;
    }
  }

  void _toggleFavorite(int index) {
    _favButtonController.forward(from: 0.0).then((_) => _favButtonController.reverse());
    setState(() {
      if (_favorites.contains(index)) {
        _favorites.remove(index);
      } else {
        _favorites.add(index);
      }
    });
  }

  void _addToCart() {
    _cartButtonController.forward(from: 0.0).then((_) => _cartButtonController.reverse());
    setState(() {
      _cartCount++;
    });
    Get.snackbar(
      'Added to Order',
      'One ${iceCreamItems[_pageOffset.round().clamp(0, iceCreamItems.length - 1)].name} added to cart!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white.withOpacity(0.9),
      colorText: Colors.black87,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final int activeIndex = _pageOffset.round().clamp(0, iceCreamItems.length - 1);
    final currentItem = iceCreamItems[activeIndex];

    // Card opacity cross-fade during scrolling
    final double cardOpacity = (1.0 - (_pageOffset - activeIndex).abs() * 3.0).clamp(0.0, 1.0);

    return Scaffold(
      body: Stack(
        children: [
          // 1. DYNAMIC GRADIENT BACKGROUND
          AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              final gradientColors = _getCurrentGradient();
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: gradientColors,
                    center: const Alignment(0.0, -0.2),
                    radius: 1.4,
                  ),
                ),
              );
            },
          ),

          // Decorative light blur background circle for depth
          Positioned(
            top: size.height * 0.15,
            left: size.width * 0.1,
            right: size.width * 0.1,
            child: Container(
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // 2. BACKGROUND TOPPINGS LAYER (Z-index behind the ice cream)
          ...List.generate(iceCreamItems.length, (itemIdx) {
            final double diff = itemIdx - _pageOffset;
            // Render only if visible to save performance
            if (diff.abs() > 1.2) return const SizedBox.shrink();

            final item = iceCreamItems[itemIdx];
            return Stack(
              children: item.toppings.asMap().entries.map((entry) {
                final int idx = entry.key;
                final FloatingTopping topping = entry.value;

                // Alternate toppings between front and back
                if (idx % 2 != 0) return const SizedBox.shrink();

                return _buildToppingWidget(topping, diff, size);
              }).toList(),
            );
          }),

          // 3. MAIN PAGEVIEW WITH 3D ROTATING ICE CREAM IMAGES
          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            height: size.height * 0.45,
            child: PageView.builder(
              controller: _pageController,
              itemCount: iceCreamItems.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final double diff = index - _pageOffset;
                final double sizeScale = _getSizeScale();

                // Advanced 3D Transform Matrix calculations
                final double angleY = diff * 1.3; // Horizontal perspective rotation
                final double angleZ = diff * 0.28; // Rolling tilt
                final double finalScale = (1.0 - diff.abs() * 0.18) * sizeScale;
                final double tx = -diff * 30.0; // Parallax offset to pull in adjacent items slightly
                final double ty = diff.abs() * 45; // Curved dip as it exits center

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0014) // 3D Depth/Perspective skew
                    ..translate(tx, ty, -diff.abs() * 120.0) // Deep push on Z-axis
                    ..rotateY(angleY)
                    ..rotateZ(angleZ)
                    ..scale(finalScale),
                  alignment: Alignment.center,
                  child: Center(
                    child: Container(
                      width: size.width * 0.65,
                      height: size.width * 0.65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.24),
                            blurRadius: 35,
                            offset: const Offset(0, 25),
                          ),
                        ],
                      ),
                      child: ColorFiltered(
                        colorFilter: _whiteToTransparentFilter,
                        child: Image.asset(
                          iceCreamItems[index].imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 4. FOREGROUND TOPPINGS LAYER (Z-index in front of the ice cream)
          ...List.generate(iceCreamItems.length, (itemIdx) {
            final double diff = itemIdx - _pageOffset;
            if (diff.abs() > 1.2) return const SizedBox.shrink();

            final item = iceCreamItems[itemIdx];
            return Stack(
              children: item.toppings.asMap().entries.map((entry) {
                final int idx = entry.key;
                final FloatingTopping topping = entry.value;

                // Alternate toppings between front and back
                if (idx % 2 == 0) return const SizedBox.shrink();

                return _buildToppingWidget(topping, diff, size);
              }).toList(),
            );
          }),

          // 5. GLASSMORPHIC DETAILS CARD
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.14),
                      width: 1.2,
                    ),
                  ),
                  child: Opacity(
                    opacity: cardOpacity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title and Rating row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                currentItem.name,
                                style: GoogleFonts.outfit(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    currentItem.rating.toString(),
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Description
                        Text(
                          currentItem.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13.5,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Size Selector and Add to Cart Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Size Buttons
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SIZE',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: List.generate(3, (index) {
                                    final labels = ['S', 'M', 'L'];
                                    final isSelected = _selectedSize == index;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedSize = index;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 250),
                                        margin: const EdgeInsets.only(right: 10),
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.08),
                                          border: Border.all(
                                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
                                            width: 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          labels[index],
                                          style: GoogleFonts.outfit(
                                            color: isSelected ? Colors.black87 : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),

                            // Price and Action Button
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'TOTAL PRICE',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${currentItem.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons: Favorite and Add to Cart
                        Row(
                          children: [
                            // Heart Button
                            ScaleTransition(
                              scale: Tween<double>(begin: 1.0, end: 1.25).animate(
                                CurvedAnimation(
                                  parent: _favButtonController,
                                  curve: Curves.elasticOut,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () => _toggleFavorite(activeIndex),
                                child: Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: _favorites.contains(activeIndex)
                                        ? Colors.redAccent.withOpacity(0.18)
                                        : Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: _favorites.contains(activeIndex)
                                          ? Colors.redAccent.withOpacity(0.4)
                                          : Colors.white.withOpacity(0.15),
                                    ),
                                  ),
                                  child: Icon(
                                    _favorites.contains(activeIndex)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _favorites.contains(activeIndex)
                                        ? Colors.redAccent
                                        : Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Add to Cart Button
                            Expanded(
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 1.0, end: 0.95).animate(
                                  CurvedAnimation(
                                    parent: _cartButtonController,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: _addToCart,
                                  child: Container(
                                    height: 54,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.white.withOpacity(0.9),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.12),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.shopping_bag_outlined,
                                          color: Colors.black87,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Add to Cart',
                                          style: GoogleFonts.outfit(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 6. CUSTOM APP BAR
          Positioned(
            top: 48,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                  ),
                ),

                // Title
                Text(
                  'Ice Cream Shop',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),

                // Cart badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                    ),
                    if (_cartCount > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _cartCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to construct floating topping layers with parallax rotation & translations
  Widget _buildToppingWidget(FloatingTopping topping, double diff, Size size) {
    // Current angle shifts with scroll difference (causing toppings to rotate/drift around the ice cream)
    final double angle = topping.offsetAngle + (diff * topping.parallaxSpeed * 0.7);
    // Expand distance slightly during transitions for an exploding/dispersing visual feel
    final double currentDistance = topping.distance * (1.0 + diff.abs() * 0.55);

    final double x = math.cos(angle) * currentDistance;
    final double y = math.sin(angle) * currentDistance;

    final double scale = topping.scale * (1.0 - diff.abs() * 0.22);
    // Smoothly fade out toppings that are far from center focus
    final double opacity = (1.0 - diff.abs() * 1.4).clamp(0.0, 1.0);

    if (opacity <= 0.0) return const SizedBox.shrink();

    // Calculate center offset relative to the ice cream viewport center
    final double centerX = size.width / 2;
    final double centerY = size.height * 0.345;

    // Follow the ice cream's horizontal slide and vertical dip
    final double iceCreamXOffset = (diff * size.width * 0.76) - (diff * 30.0);
    final double iceCreamYOffset = diff.abs() * 45; // Match ty in PageView

    return Positioned(
      left: centerX + x + iceCreamXOffset - 20,
      top: centerY + y + iceCreamYOffset - 20,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: diff * topping.rotationSpeed * 4.5,
          child: Transform.scale(
            scale: scale,
            child: Text(
              topping.emoji,
              style: const TextStyle(
                fontSize: 28,
                shadows: [
                  Shadow(
                    color: Colors.black38,
                    offset: Offset(0, 6),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
