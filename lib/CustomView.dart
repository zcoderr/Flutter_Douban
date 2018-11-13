import 'dart:math' as Math;

import 'package:flutter/material.dart';

class ScoreView extends StatelessWidget {
  double score;
  Size size;
  double width;
  double height;

  ScoreView(this.size, this.score);

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: size,
      painter: new ScorePainter(
        score,
      ),
    );
  }
}

class ScorePainter extends CustomPainter {
  double _score;
  double padding = 10.0; //左右两边间距
  double spacing = 2.0; // 星星之间间距
  Paint _backgroundPaint;
  Paint _foregroundPaint;

  ScorePainter(num score) {
    this._score = score;
    init();
  }

  void init() {
    _backgroundPaint = new Paint();
    _backgroundPaint.isAntiAlias = true;
    _backgroundPaint.color = Colors.grey;
    _backgroundPaint.strokeWidth = 1.0;
    _backgroundPaint.style = PaintingStyle.fill;

    _foregroundPaint = new Paint();
    _foregroundPaint.isAntiAlias = true;
    _foregroundPaint.color = Colors.orange;
    _foregroundPaint.strokeWidth = 1.0;
    _foregroundPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double outR = (size.width - 2 * padding - 4 * spacing) / 2 / 5;
    double inR = outR * sin(18) / sin(180 - 36 - 18);

    canvas.translate(padding + outR, outR);

    Path path;
    for (int i = 0; i < 5; i++) {
      if (_score > 2.0) {
        // 完整的星星
        path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
        canvas.drawPath(path, _foregroundPaint);
      } else if (_score > 0.0) {
        // 不完整的星星
        path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
        canvas.drawPath(path, _backgroundPaint);

        _foregroundPaint.blendMode = BlendMode.overlay;
        Rect rect = new Rect.fromLTWH(-outR, -outR, outR * _score, 2 * outR);
        canvas.drawRect(rect, _foregroundPaint);
      } else {
        // 灰色星星
        path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
        canvas.drawPath(path, _backgroundPaint);
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

    path.moveTo(Math.cos((54 + 72 * -1 - rot) / 180 * Math.pi) * r + x,
        -Math.sin((54 + 72 * -1 - rot) / 180 * Math.pi) * r + y);

    for (var i = 0; i < 5; i++) {
      path.lineTo(Math.cos((18 + 72 * i - rot) / 180 * Math.pi) * R + x,
          -Math.sin((18 + 72 * i - rot) / 180 * Math.pi) * R + y);
      path.lineTo(Math.cos((54 + 72 * i - rot) / 180 * Math.pi) * r + x,
          -Math.sin((54 + 72 * i - rot) / 180 * Math.pi) * r + y);
    }
    path.close();
    return path;
  }

  double cos(int num) {
    return Math.cos(num * Math.pi / 180);
  }

  double sin(int num) {
    return Math.sin(num * Math.pi / 180);
  }
}
