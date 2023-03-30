import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SVGTuitionTopPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  SVGTuitionTopPainter(this.color1, this.color2);

  @override
  void paint(Canvas canvas, Size size) {       
    Path path_0 = Path();
    path_0.moveTo(0,0);
    path_0.lineTo(size.width*1.285714,0);
    path_0.lineTo(size.width*1.285714,size.height*0.4000000);
    path_0.cubicTo(size.width*0.5714286,size.height*0.4000000,size.width*0.4285714,size.height,0,size.height*1.400000);

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    // paint_0_fill.color = color;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset.zero,
      Offset(size.width, size.height),
      [
        color1,
        color2,
      ],
  );
    canvas.drawPath(path_0,paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}