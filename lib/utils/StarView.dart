import 'dart:math' as Math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class StarView extends StatelessWidget {
  double width;
  double height;
  double score;

  StarView(this.width, this.height, this.score);

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: new Size(width, height),
      painter: new ScorePainter(
        score,
      ),
    );
  }
}

class ScorePainter extends CustomPainter {
  double _score;

  ScorePainter(this._score);

  @override
  void paint(Canvas canvas, Size size) {
    double padding = 0.0; //左右两边间距
    double spacing = 2.0; // 星星之间间距

    double outR = (size.width - 2 * padding - 4 * spacing) / 2 / 5;
    double inR = outR * sin(18) / sin(180 - 36 - 18);

    Paint paint = new Paint();
    paint.isAntiAlias = true;
    paint.color = Colors.orange;
    paint.strokeWidth = 1.0;

    canvas.translate(padding + outR, outR);
    //Path path = getCompletePath(outR, inR);
    paint.style = PaintingStyle.fill;
//    Path path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
//
//    for (int i = 0; i < 5; i++) {
//      canvas.drawPath(path, paint);
//      canvas.translate(spacing + outR * 2, 0.0);
//    }

    Path path;
    for (int i = 0; i < 5; i++) {
      if (_score > 2.0) {
        // 完整的星星
        paint.color = Colors.orange;
        path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
        canvas.drawPath(path, paint);
      } else if (_score > 0.0) {
        // 不完整的星星
        paint.color = Colors.grey;
        path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
        canvas.drawPath(path, paint);

        paint.blendMode = BlendMode.overlay;
        paint.color = Colors.orange;
        Rect rect = new Rect.fromLTWH(-outR, -outR, outR * _score, 2 * outR);
        canvas.drawRect(rect, paint);

        paint.blendMode = BlendMode.src;
      } else {
        // 灰色星星
        paint.color = Colors.grey;
        path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
        canvas.drawPath(path, paint);
      }
      canvas.translate(spacing + outR * 2, 0.0);
      _score -= 2.0;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  getStarPath(double R, double r, double x, double y, double rot) {
    Path path = new Path();

    path.moveTo(Math.cos((54 + 72 * -1 - rot) / 180 * Math.PI) * r + x,
        -Math.sin((54 + 72 * -1 - rot) / 180 * Math.PI) * r + y);

    for (var i = 0; i < 5; i++) {
      path.lineTo(Math.cos((18 + 72 * i - rot) / 180 * Math.PI) * R + x,
          -Math.sin((18 + 72 * i - rot) / 180 * Math.PI) * R + y);
      path.lineTo(Math.cos((54 + 72 * i - rot) / 180 * Math.PI) * r + x,
          -Math.sin((54 + 72 * i - rot) / 180 * Math.PI) * r + y);
    }
    path.close();
    return path;
  }

  double cos(int num) {
    return Math.cos(num * Math.PI / 180);
  }

  double sin(int num) {
    return Math.sin(num * Math.PI / 180);
  }
}

class ImgBlurPaint extends CustomPainter {
  ImgBlurPaint();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint();

    ui.ImageFilter.blur(
      sigmaX: 0.0,
      sigmaY: 0.0,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
