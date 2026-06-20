import 'package:flutter/material.dart';
import 'package:test/ui/animatedScreens/shopping/models/product.dart';

class MannequinPainter extends CustomPainter {
  final Color glowColor;

  MannequinPainter({this.glowColor = Colors.cyanAccent});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Glowing Neon Paints
    final Paint linePaint = Paint()
      ..color = glowColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3);

    final Paint fillPaint = Paint()
      ..color = glowColor.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    // Mannequin Path
    final Path bodyPath = Path();

    // 1. Head (Holographic Oval)
    final Offset headCenter = Offset(w / 2, h * 0.15);
    final double headRadiusX = w * 0.15;
    final double headRadiusY = h * 0.055;
    bodyPath.addOval(Rect.fromCenter(
      center: headCenter,
      width: headRadiusX * 2,
      height: headRadiusY * 2,
    ));

    // 2. Neck & Body Outline
    // Neck
    bodyPath.moveTo(w * 0.46, h * 0.205);
    bodyPath.lineTo(w * 0.46, h * 0.25);
    // Left Shoulder
    bodyPath.lineTo(w * 0.28, h * 0.28);
    // Left Arm (Upper)
    bodyPath.lineTo(w * 0.21, h * 0.42);
    // Left Arm (Forearm)
    bodyPath.lineTo(w * 0.23, h * 0.55);
    // Return up to inside armpit
    bodyPath.lineTo(w * 0.33, h * 0.35);
    // Left Waist
    bodyPath.lineTo(w * 0.35, h * 0.58);
    // Hips & Left Leg Outer
    bodyPath.lineTo(w * 0.36, h * 0.65);
    bodyPath.lineTo(w * 0.38, h * 0.9);
    // Left Foot
    bodyPath.lineTo(w * 0.44, h * 0.9);
    // Left Leg Inner
    bodyPath.lineTo(w * 0.47, h * 0.65);
    // Crotch
    bodyPath.lineTo(w * 0.5, h * 0.62);
    // Right Leg Inner
    bodyPath.lineTo(w * 0.53, h * 0.65);
    // Right Foot
    bodyPath.lineTo(w * 0.56, h * 0.9);
    // Right Leg Outer
    bodyPath.lineTo(w * 0.62, h * 0.9);
    bodyPath.lineTo(w * 0.64, h * 0.65);
    // Right Waist
    bodyPath.lineTo(w * 0.65, h * 0.58);
    // Right Armpit
    bodyPath.lineTo(w * 0.67, h * 0.35);
    // Right Arm (Forearm)
    bodyPath.lineTo(w * 0.77, h * 0.55);
    // Right Arm (Upper)
    bodyPath.lineTo(w * 0.79, h * 0.42);
    // Right Shoulder
    bodyPath.lineTo(w * 0.72, h * 0.28);
    // Right Neck
    bodyPath.lineTo(w * 0.54, h * 0.25);
    bodyPath.lineTo(w * 0.54, h * 0.205);

    bodyPath.close();

    // Draw the body
    canvas.drawPath(bodyPath, fillPaint);
    canvas.drawPath(bodyPath, linePaint);

    // Draw grid lines on the mannequin to make it look like a wireframe hologram
    final Paint gridPaint = Paint()
      ..color = glowColor.withOpacity(0.2)
      ..strokeWidth = 1.0;
    
    for (double i = 0.3; i < 0.6; i += 0.08) {
      canvas.drawLine(Offset(w * (0.5 - i * 0.25), h * i), Offset(w * (0.5 + i * 0.25), h * i), gridPaint);
    }
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ClothingPainter extends CustomPainter {
  final ClothingType type;
  final Color color;
  final double animationVal; // Value between 0.0 (entering) and 1.0 (settled)

  ClothingPainter({
    required this.type,
    required this.color,
    required this.animationVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Apply scale and slide animation
    // The clothing will slide down slightly and pop in scale
    final double slideOffset = (1.0 - animationVal) * -20.0;
    final double scale = 0.9 + (animationVal * 0.1);
    
    canvas.save();
    canvas.translate(w / 2, h * 0.4 + slideOffset);
    canvas.scale(scale);
    canvas.translate(-w / 2, -h * 0.4);

    final Paint borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);

    final Paint fillPaint = Paint()
      ..color = color.withOpacity(0.25 + (animationVal * 0.15))
      ..style = PaintingStyle.fill;

    final Paint detailPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Path clothPath = Path();

    switch (type) {
      case ClothingType.tshirt:
        // Collar curve
        clothPath.moveTo(w * 0.42, h * 0.275);
        clothPath.quadraticBezierTo(w * 0.5, h * 0.31, w * 0.58, h * 0.275);
        // Right shoulder
        clothPath.lineTo(w * 0.725, h * 0.282);
        // Right sleeve outer
        clothPath.lineTo(w * 0.77, h * 0.39);
        // Right sleeve cuff
        clothPath.lineTo(w * 0.69, h * 0.415);
        // Under right armpit
        clothPath.lineTo(w * 0.665, h * 0.36);
        // Right waist down
        clothPath.lineTo(w * 0.655, h * 0.58);
        // Bottom hem
        clothPath.lineTo(w * 0.345, h * 0.58);
        // Left waist up
        clothPath.lineTo(w * 0.335, h * 0.36);
        // Under left armpit
        clothPath.lineTo(w * 0.31, h * 0.415);
        // Left sleeve cuff
        clothPath.lineTo(w * 0.23, h * 0.39);
        // Left sleeve outer
        clothPath.lineTo(w * 0.275, h * 0.282);
        clothPath.close();

        canvas.drawPath(clothPath, fillPaint);
        canvas.drawPath(clothPath, borderPaint);

        // Add some fold details
        canvas.drawLine(Offset(w * 0.36, h * 0.55), Offset(w * 0.42, h * 0.56), detailPaint);
        canvas.drawLine(Offset(w * 0.64, h * 0.55), Offset(w * 0.58, h * 0.56), detailPaint);
        break;

      case ClothingType.hoodie:
        // High collar / Hood base
        clothPath.moveTo(w * 0.4, h * 0.27);
        clothPath.quadraticBezierTo(w * 0.5, h * 0.21, w * 0.6, h * 0.27);
        // Right shoulder
        clothPath.lineTo(w * 0.73, h * 0.285);
        // Right sleeve outer
        clothPath.lineTo(w * 0.785, h * 0.44);
        // Right sleeve wrist
        clothPath.lineTo(w * 0.755, h * 0.56);
        clothPath.lineTo(w * 0.71, h * 0.54);
        // Inner arm
        clothPath.lineTo(w * 0.66, h * 0.37);
        // Waist hem
        clothPath.lineTo(w * 0.66, h * 0.62);
        // Bottom waistband
        clothPath.lineTo(w * 0.34, h * 0.62);
        // Left waist up
        clothPath.lineTo(w * 0.34, h * 0.37);
        // Inner left arm
        clothPath.lineTo(w * 0.29, h * 0.54);
        // Left sleeve wrist
        clothPath.lineTo(w * 0.245, h * 0.56);
        // Left sleeve outer
        clothPath.lineTo(w * 0.215, h * 0.44);
        // Left shoulder
        clothPath.lineTo(w * 0.27, h * 0.285);
        clothPath.close();

        canvas.drawPath(clothPath, fillPaint);
        canvas.drawPath(clothPath, borderPaint);

        // Draw Kangaroo Pocket
        final Path pocketPath = Path()
          ..moveTo(w * 0.4, h * 0.61)
          ..lineTo(w * 0.6, h * 0.61)
          ..lineTo(w * 0.57, h * 0.51)
          ..lineTo(w * 0.43, h * 0.51)
          ..close();
        canvas.drawPath(pocketPath, detailPaint);

        // Draw Drawstrings
        final Path stringPath = Path()
          ..moveTo(w * 0.46, h * 0.28)
          ..quadraticBezierTo(w * 0.45, h * 0.36, w * 0.47, h * 0.42)
          ..moveTo(w * 0.54, h * 0.28)
          ..quadraticBezierTo(w * 0.56, h * 0.35, w * 0.53, h * 0.40);
        canvas.drawPath(stringPath, borderPaint..strokeWidth = 2.0);
        break;

      case ClothingType.jacket:
        // Left lapel & shoulder
        clothPath.moveTo(w * 0.42, h * 0.28);
        clothPath.lineTo(w * 0.27, h * 0.285);
        // Left sleeve outer
        clothPath.lineTo(w * 0.21, h * 0.44);
        // Left wrist
        clothPath.lineTo(w * 0.245, h * 0.56);
        // Inner arm
        clothPath.lineTo(w * 0.29, h * 0.54);
        // Waist
        clothPath.lineTo(w * 0.32, h * 0.60);
        // Hem bottom open
        clothPath.lineTo(w * 0.42, h * 0.60);
        // Open center v-line
        clothPath.lineTo(w * 0.45, h * 0.35);
        clothPath.lineTo(w * 0.55, h * 0.35);
        clothPath.lineTo(w * 0.58, h * 0.60);
        // Right waist
        clothPath.lineTo(w * 0.68, h * 0.60);
        clothPath.lineTo(w * 0.71, h * 0.54);
        // Right arm inner
        clothPath.lineTo(w * 0.755, h * 0.56);
        // Right sleeve outer
        clothPath.lineTo(w * 0.79, h * 0.44);
        // Right shoulder
        clothPath.lineTo(w * 0.73, h * 0.285);
        clothPath.lineTo(w * 0.58, h * 0.28);
        clothPath.quadraticBezierTo(w * 0.5, h * 0.30, w * 0.42, h * 0.28);
        clothPath.close();

        canvas.drawPath(clothPath, fillPaint);
        canvas.drawPath(clothPath, borderPaint);

        // Collar Fold lines
        canvas.drawLine(Offset(w * 0.42, h * 0.28), Offset(w * 0.45, h * 0.38), detailPaint..strokeWidth = 2.5);
        canvas.drawLine(Offset(w * 0.58, h * 0.28), Offset(w * 0.55, h * 0.38), detailPaint..strokeWidth = 2.5);
        break;

      case ClothingType.trenchCoat:
        // Collar V shape
        clothPath.moveTo(w * 0.42, h * 0.275);
        clothPath.lineTo(w * 0.27, h * 0.282);
        // Left sleeve outer
        clothPath.lineTo(w * 0.21, h * 0.44);
        // Left wrist
        clothPath.lineTo(w * 0.245, h * 0.56);
        // Inner arm
        clothPath.lineTo(w * 0.29, h * 0.54);
        // Waist left
        clothPath.lineTo(w * 0.31, h * 0.62);
        // Skirt coat left (extends long)
        clothPath.lineTo(w * 0.28, h * 0.81);
        // Hem bottom
        clothPath.lineTo(w * 0.72, h * 0.81);
        // Skirt coat right
        clothPath.lineTo(w * 0.69, h * 0.62);
        // Waist right
        clothPath.lineTo(w * 0.71, h * 0.54);
        // Right arm inner
        clothPath.lineTo(w * 0.755, h * 0.56);
        // Right sleeve outer
        clothPath.lineTo(w * 0.79, h * 0.44);
        // Right shoulder
        clothPath.lineTo(w * 0.73, h * 0.282);
        clothPath.lineTo(w * 0.58, h * 0.275);
        clothPath.quadraticBezierTo(w * 0.5, h * 0.29, w * 0.42, h * 0.275);
        clothPath.close();

        canvas.drawPath(clothPath, fillPaint);
        canvas.drawPath(clothPath, borderPaint);

        // Belt around waist
        final Rect beltRect = Rect.fromLTRB(w * 0.32, h * 0.54, w * 0.68, h * 0.565);
        canvas.drawRect(beltRect, Paint()..color = color.withOpacity(0.8));
        canvas.drawRect(beltRect, borderPaint..strokeWidth = 2.0);
        break;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ClothingPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.color != color || oldDelegate.animationVal != animationVal;
  }
}
