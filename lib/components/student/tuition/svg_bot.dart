import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SVGTuitionBottomPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  SVGTuitionBottomPainter(this.color1, this.color2);

  @override
  void paint(Canvas canvas, Size size) {       
    Path path_0 = Path();
    path_0.moveTo(size.width,size.height);
    path_0.lineTo(size.width,size.height*-0.3333333);
    path_0.cubicTo(size.width*0.7857143,size.height*-0.5000000,size.width*0.6428571,size.height*0.6666667,size.width*0.2142857,size.height);

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