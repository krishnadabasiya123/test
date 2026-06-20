import 'package:flutter/material.dart';

enum ClothingType {
  tshirt,
  hoodie,
  jacket,
  trenchCoat,
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final ClothingType type;
  final Color primaryColor;
  final List<Color> availableColors;
  final String heroImage; // Reference representation in the catalog
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.primaryColor,
    required this.availableColors,
    required this.heroImage,
    required this.rating,
  });
}

const List<Product> mockProducts = [
  Product(
    id: 'p1',
    name: 'Cyberpunk T-Shirt',
    description: 'Holographic casual wear with cyber-weave breathable mesh.',
    price: 49.99,
    type: ClothingType.tshirt,
    primaryColor: Colors.amberAccent,
    availableColors: [Colors.amberAccent, Colors.cyanAccent, Colors.pinkAccent],
    heroImage: 'assets/images/animatedScreens/shopping/tshirt_amber.png',
    rating: 4.8,
  ),
  Product(
    id: 'p2',
    name: 'Neon Horizon Hoodie',
    description: 'Ultra-plush smart thermal hoodie with custom light-up drawstrings.',
    price: 89.99,
    type: ClothingType.hoodie,
    primaryColor: Colors.cyan,
    availableColors: [Colors.cyan, Colors.purpleAccent, Colors.orangeAccent],
    heroImage: 'assets/images/animatedScreens/shopping/hoodie_cyan.png',
    rating: 4.9,
  ),
  Product(
    id: 'p3',
    name: 'Retrowave Leather Jacket',
    description: 'Vibrant synthetic neon leather jacket. Outrun cold in style.',
    price: 149.99,
    type: ClothingType.jacket,
    primaryColor: Colors.pinkAccent,
    availableColors: [Colors.pinkAccent, Colors.redAccent, Colors.blueAccent],
    heroImage: 'assets/images/animatedScreens/shopping/jacket_pink.png',
    rating: 4.7,
  ),
  Product(
    id: 'p4',
    name: 'Matrix Tech Trench',
    description: 'Waterproof nano-layered trench coat for high-tech street fashion.',
    price: 199.99,
    type: ClothingType.trenchCoat,
    primaryColor: Colors.greenAccent,
    availableColors: [Colors.greenAccent, Colors.tealAccent, Colors.grey],
    heroImage: 'assets/images/animatedScreens/shopping/trench_green.png',
    rating: 5.0,
  ),
];
