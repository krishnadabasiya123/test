import 'package:flutter/material.dart';

class FloatingTopping {
  final String emoji;
  final double offsetAngle; // angle offset in radians (0 to 2*pi)
  final double distance; // distance from center (pixels or logical factor)
  final double
  parallaxSpeed; // how fast it moves compared to page offset (negative for reverse)
  final double scale;
  final double rotationSpeed; // rotational offset speed

  const FloatingTopping({
    required this.emoji,
    required this.offsetAngle,
    required this.distance,
    required this.parallaxSpeed,
    required this.scale,
    required this.rotationSpeed,
  });
}

class IceCreamItem {
  final String name;
  final String description;
  final double price;
  final double rating;
  final String imagePath;
  final List<Color> bgGradient;
  final List<FloatingTopping> toppings;

  const IceCreamItem({
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.bgGradient,
    required this.toppings,
  });
}

final List<IceCreamItem> iceCreamItems = [
  IceCreamItem(
    name: 'Strawberry Fields',
    description:
        'Fresh hand-picked summer strawberries blended with ultra-smooth organic sweet cream. Finished with a lush strawberry glaze, fresh sliced berries, and a cool organic mint leaf.',
    price: 6.99,
    rating: 4.8,
    imagePath: 'assets/images/animatedScreens/ice_cream/strawberry.png',
    bgGradient: [
      const Color(0xFFFF9A9E), // Soft Pink
      const Color(0xFFFECFEF), // Pastel Rose
      const Color(0xFFF9A8D4), // Vibrant Rose
    ],
    toppings: [
      const FloatingTopping(
        emoji: '🍓',
        offsetAngle: 0.8,
        distance: 130,
        parallaxSpeed: 2.2,
        scale: 1.4,
        rotationSpeed: 0.5,
      ),
      const FloatingTopping(
        emoji: '🍃',
        offsetAngle: 2.2,
        distance: 150,
        parallaxSpeed: -1.8,
        scale: 1.1,
        rotationSpeed: -0.3,
      ),
      const FloatingTopping(
        emoji: '🍓',
        offsetAngle: 3.5,
        distance: 120,
        parallaxSpeed: 2.5,
        scale: 0.9,
        rotationSpeed: 0.7,
      ),
      const FloatingTopping(
        emoji: '🌸',
        offsetAngle: 4.8,
        distance: 160,
        parallaxSpeed: -1.5,
        scale: 1.2,
        rotationSpeed: 0.2,
      ),
      const FloatingTopping(
        emoji: '✨',
        offsetAngle: 5.8,
        distance: 140,
        parallaxSpeed: 3.0,
        scale: 0.8,
        rotationSpeed: 1.0,
      ),
    ],
  ),
  IceCreamItem(
    name: 'Dark Chocolate Cocoa',
    description:
        'An indulgent, double-churned cocoa experience using premium 72% Belgian dark chocolate, swirled with glossy chocolate fudge and organic roasted hazelnuts.',
    price: 7.49,
    rating: 4.9,
    imagePath: 'assets/images/animatedScreens/ice_cream/chocolate.png',
    bgGradient: [
      const Color(0xFF3E2723), // Dark Brown
      const Color(0xFF5D4037), // Medium Brown
      const Color(0xFF8D6E63), // Light warm bronze
    ],
    toppings: [
      const FloatingTopping(
        emoji: '🍫',
        offsetAngle: 0.5,
        distance: 120,
        parallaxSpeed: 2.0,
        scale: 1.3,
        rotationSpeed: 0.4,
      ),
      const FloatingTopping(
        emoji: '🥜',
        offsetAngle: 2.0,
        distance: 160,
        parallaxSpeed: -2.2,
        scale: 1.0,
        rotationSpeed: -0.6,
      ),
      const FloatingTopping(
        emoji: '🍪',
        offsetAngle: 3.8,
        distance: 130,
        parallaxSpeed: 2.4,
        scale: 1.2,
        rotationSpeed: 0.8,
      ),
      const FloatingTopping(
        emoji: '🍩',
        offsetAngle: 4.9,
        distance: 150,
        parallaxSpeed: -1.6,
        scale: 0.9,
        rotationSpeed: 0.1,
      ),
      const FloatingTopping(
        emoji: '✨',
        offsetAngle: 5.6,
        distance: 140,
        parallaxSpeed: 2.8,
        scale: 0.8,
        rotationSpeed: 0.9,
      ),
    ],
  ),
  IceCreamItem(
    name: 'Mango Sunset',
    description:
        'A refreshing, sun-kissed sorbet crafted from Alphonso mangoes and tangy passionfruit seeds. Infused with a rich tropical syrup drizzle for a refreshing finish.',
    price: 6.79,
    rating: 4.7,
    imagePath: 'assets/images/animatedScreens/ice_cream/mango.png',
    bgGradient: [
      const Color(0xFFFFA000), // Amber Yellow
      const Color(0xFFFFB300), // Soft Amber
      const Color(0xFFFFCC80), // Peach Orange
    ],
    toppings: [
      const FloatingTopping(
        emoji: '🥭',
        offsetAngle: 0.7,
        distance: 130,
        parallaxSpeed: 2.3,
        scale: 1.4,
        rotationSpeed: 0.5,
      ),
      const FloatingTopping(
        emoji: '🍊',
        offsetAngle: 2.1,
        distance: 140,
        parallaxSpeed: -1.7,
        scale: 1.1,
        rotationSpeed: -0.4,
      ),
      const FloatingTopping(
        emoji: '🍍',
        offsetAngle: 3.6,
        distance: 150,
        parallaxSpeed: 2.6,
        scale: 1.2,
        rotationSpeed: 0.6,
      ),
      const FloatingTopping(
        emoji: '🥥',
        offsetAngle: 4.7,
        distance: 120,
        parallaxSpeed: -2.0,
        scale: 1.0,
        rotationSpeed: 0.3,
      ),
      const FloatingTopping(
        emoji: '✨',
        offsetAngle: 5.9,
        distance: 160,
        parallaxSpeed: 3.1,
        scale: 0.8,
        rotationSpeed: 1.1,
      ),
    ],
  ),
  IceCreamItem(
    name: 'Minty Matcha Chip',
    description:
        'Artisanal organic Japanese matcha green tea blended with fresh garden mint oil and folded with crisp, premium dark chocolate chips for an invigorating flavor profile.',
    price: 7.29,
    rating: 4.8,
    imagePath: 'assets/images/animatedScreens/ice_cream/mint.png',
    bgGradient: [
      const Color(0xFF004D40), // Deep Teal/Green
      const Color(0xFF00796B), // Teal Green
      const Color(0xFF4DB6AC), // Soft Mint Green
    ],
    toppings: [
      const FloatingTopping(
        emoji: '🍃',
        offsetAngle: 0.6,
        distance: 140,
        parallaxSpeed: 2.1,
        scale: 1.3,
        rotationSpeed: 0.5,
      ),
      const FloatingTopping(
        emoji: '🍫',
        offsetAngle: 2.2,
        distance: 130,
        parallaxSpeed: -1.9,
        scale: 1.1,
        rotationSpeed: -0.4,
      ),
      const FloatingTopping(
        emoji: '🌿',
        offsetAngle: 3.4,
        distance: 150,
        parallaxSpeed: 2.4,
        scale: 1.2,
        rotationSpeed: 0.7,
      ),
      const FloatingTopping(
        emoji: '❄️',
        offsetAngle: 4.8,
        distance: 120,
        parallaxSpeed: -1.6,
        scale: 1.0,
        rotationSpeed: 0.2,
      ),
      const FloatingTopping(
        emoji: '✨',
        offsetAngle: 5.8,
        distance: 160,
        parallaxSpeed: 2.9,
        scale: 0.8,
        rotationSpeed: 1.0,
      ),
    ],
  ),
];
