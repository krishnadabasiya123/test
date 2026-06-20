import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test/ui/animatedScreens/shopping/models/product.dart';
import 'package:test/ui/animatedScreens/shopping/utils/holo_painters.dart';

class ShoppingDetailsScreen extends StatefulWidget {
  final Product product;

  const ShoppingDetailsScreen({Key? key, required this.product})
    : super(key: key);

  @override
  _ShoppingDetailsScreenState createState() => _ShoppingDetailsScreenState();
}

class _ShoppingDetailsScreenState extends State<ShoppingDetailsScreen>
    with TickerProviderStateMixin {
  // Animation for the entry load of mannequin
  late final AnimationController _entryController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  // Animation for switching clothes
  late final AnimationController _clothSwitchController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );

  // Animation for Add to Cart button morphing
  late final AnimationController _cartBtnController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  // Animation for Custom Snackbar
  late final AnimationController _snackbarController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  // States
  late Color _selectedColor = widget.product.primaryColor;
  bool _isMannequinActive = true;
  String _cartState = 'idle'; // 'idle' | 'loading' | 'success'
  bool _showSnackbar = false;

  @override
  void initState() {
    super.initState();
    _entryController.forward();
    _clothSwitchController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _entryController.dispose();
    _clothSwitchController.dispose();
    _cartBtnController.dispose();
    _snackbarController.dispose();
    super.dispose();
  }

  void _onColorSelected(Color color) {
    if (color == _selectedColor) return;
    setState(() {
      _selectedColor = color;
    });
    // Trigger clothing slide-on animation
    _clothSwitchController.forward(from: 0.0);
  }

  void _triggerAddToCart() {
    if (_cartState != 'idle') return;

    setState(() {
      _cartState = 'loading';
    });
    _cartBtnController.forward();

    // Simulate network add to cart
    Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _cartState = 'success';
        });

        // Show the custom animated snackbar
        _triggerSnackbar();

        // Revert button state after success message
        Timer(const Duration(milliseconds: 2200), () {
          if (mounted) {
            setState(() {
              _cartState = 'idle';
            });
            _cartBtnController.reverse();
          }
        });
      }
    });
  }

  void _triggerSnackbar() {
    setState(() {
      _showSnackbar = true;
    });
    _snackbarController.forward(from: 0.0);

    // Auto dismiss after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _snackbarController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _showSnackbar = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17), // Deep Space Blue
      body: Stack(
        children: [
          // 1. Mannequin & Clothes Showcase Area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.62,
            child: _buildFittingRoom(),
          ),

          // 2. Back and Toggle Buttons (Floating on top)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: _buildHeaderButtons(),
          ),

          // 3. Bottom Specs and Purchase Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.40,
            child: _buildDetailsPanel(screenHeight),
          ),

          // 4. Custom Animated Floating Snackbar
          if (_showSnackbar)
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              child: _buildCustomAnimatedSnackbar(),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),

        // Mannequin wireframe toggle (aesthetic)
        GestureDetector(
          onTap: () {
            setState(() {
              _isMannequinActive = !_isMannequinActive;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _isMannequinActive
                  ? Colors.cyanAccent.withOpacity(0.15)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isMannequinActive
                    ? Colors.cyanAccent.withOpacity(0.4)
                    : Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.person_crop_square,
                  color: _isMannequinActive
                      ? Colors.cyanAccent
                      : Colors.white60,
                  size: 16,
                ),
                const SizedBox(width: 6.0),
                Text(
                  _isMannequinActive ? "MODEL ON" : "MODEL OFF",
                  style: TextStyle(
                    color: _isMannequinActive
                        ? Colors.cyanAccent
                        : Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFittingRoom() {
    final entryAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.elasticOut,
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.7,
          colors: [Color(0xFF131D2F), Color(0xFF0A0E17)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Holographic glowing circular base/pedestal
          Positioned(
            bottom: 40,
            child: ScaleTransition(
              scale: entryAnimation,
              child: Container(
                width: 190,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(0.5),
                    width: 2.0,
                  ),
                  gradient: RadialGradient(
                    colors: [
                      Colors.cyanAccent.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Cyberpunk Grid Background Lines
          Positioned(
            top: 100,
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=400&q=80',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),

          // The Human Model / Mannequin outline
          if (_isMannequinActive)
            Positioned.fill(
              top: 50,
              bottom: 30,
              child: AnimatedBuilder(
                animation: _entryController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _entryController.value,
                    child: Opacity(
                      opacity: _entryController.value,
                      child: CustomPaint(
                        painter: MannequinPainter(
                          glowColor: _selectedColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // The Try-On Clothes Overlay Layer
          Positioned.fill(
            top: 50,
            bottom: 30,
            child: AnimatedBuilder(
              animation: _clothSwitchController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ClothingPainter(
                    type: widget.product.type,
                    color: _selectedColor,
                    animationVal: _clothSwitchController.value,
                  ),
                );
              },
            ),
          ),

          // Futuristic Scanning line animation
          Positioned.fill(child: _buildScannerAnimation()),
        ],
      ),
    );
  }

  Widget _buildScannerAnimation() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 4),
          builder: (context, val, child) {
            double scanHeight = 120.0 + (val * 320.0);
            return Stack(
              children: [
                Positioned(
                  top: scanHeight,
                  left: MediaQuery.of(context).size.width * 0.18,
                  right: MediaQuery.of(context).size.width * 0.18,
                  child: Container(
                    height: 2.0,
                    decoration: BoxDecoration(
                      color: _selectedColor.withOpacity(0.6),
                      boxShadow: [
                        BoxShadow(
                          color: _selectedColor,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDetailsPanel(double screenHeight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: const BoxDecoration(
        color: Color(0xFF0F1522), // Dark Slate Card background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 20.0,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: Title & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                "\$${widget.product.price.toStringAsFixed(2)}",
                style: TextStyle(
                  color: _selectedColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8.0),

          // Rating & Reviews
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4.0),
              Text(
                "${widget.product.rating} (128 Reviews)",
                style: const TextStyle(color: Colors.white60, fontSize: 12.0),
              ),
            ],
          ),

          const SizedBox(height: 14.0),

          // Description
          Text(
            widget.product.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13.0,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // Color Selector Capsules
          const Text(
            "CHOOSE HOLO-COLOR",
            style: TextStyle(
              color: Colors.white30,
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: widget.product.availableColors.map((color) {
              final isSelected = color == _selectedColor;
              return GestureDetector(
                onTap: () => _onColorSelected(color),
                child: Container(
                  margin: const EdgeInsets.only(right: 14.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? color : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const Spacer(),

          // Add to Cart Button Container
          Center(child: _buildMorphingButton()),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildMorphingButton() {
    // Determine target width & decoration based on cart state
    double btnWidth = 320;
    if (_cartState == 'loading' || _cartState == 'success') {
      btnWidth = 56;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
      width: btnWidth,
      height: 56,
      child: Material(
        color: _cartState == 'success' ? Colors.greenAccent : _selectedColor,
        borderRadius: BorderRadius.circular(
          _cartState == 'idle' ? 18.0 : 100.0,
        ),
        shadowColor:
            (_cartState == 'success' ? Colors.greenAccent : _selectedColor)
                .withOpacity(0.4),
        elevation: 8,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            _cartState == 'idle' ? 18.0 : 100.0,
          ),
          onTap: _triggerAddToCart,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildButtonContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (_cartState == 'loading') {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (_cartState == 'success') {
      return const Icon(Icons.check, color: Color(0xFF0A0E17), size: 26);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            CupertinoIcons.cart_badge_plus,
            color: Color(0xFF0A0E17),
            size: 20,
          ),
          SizedBox(width: 12.0),
          Text(
            "ADD TO CARTRIDGE",
            style: TextStyle(
              color: Color(0xFF0A0E17),
              fontWeight: FontWeight.bold,
              fontSize: 14.5,
              letterSpacing: 1.0,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildCustomAnimatedSnackbar() {
    final snackbarAnimation = CurvedAnimation(
      parent: _snackbarController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeInCubic,
    );

    return AnimatedBuilder(
      animation: snackbarAnimation,
      builder: (context, child) {
        // Slide down from top with spring effect
        double dy = -80.0 + (snackbarAnimation.value * 80.0);
        return Transform.translate(
          offset: Offset(0, dy),
          child: Opacity(
            opacity: snackbarAnimation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: const Color(0xFF182232),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.12),
              blurRadius: 16.0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Color(0xFF182232),
                size: 14,
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Outfit Configured!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    "${widget.product.name} added to cart.",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
