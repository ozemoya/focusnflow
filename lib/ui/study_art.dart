import 'dart:math' as math;

import 'package:flutter/material.dart';

class StudyArt extends StatelessWidget {
  const StudyArt({super.key, this.scene = 0});
  final int scene;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(painter: _StudyPainter(scene), size: Size.infinite),
  );
}

class _StudyPainter extends CustomPainter {
  _StudyPainter(this.scene);
  final int scene;
  final ink = const Color(0xff304b36);
  void shape(Canvas canvas, Path path, Color color) {
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void oval(Canvas c, Rect r, Color fill) {
    c.drawOval(r, Paint()..color = fill);
    c.drawOval(
      r,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void person(Canvas c, double x, double y, Color shirt, {bool book = false}) {
    final p = Path()
      ..moveTo(x - 15, y + 24)
      ..quadraticBezierTo(x - 23, y + 58, x - 10, y + 66)
      ..lineTo(x + 25, y + 66)
      ..quadraticBezierTo(x + 31, y + 33, x + 13, y + 24)
      ..close();
    shape(c, p, shirt);
    oval(
      c,
      Rect.fromCircle(center: Offset(x, y + 7), radius: 17),
      const Color(0xffc9855a),
    );
    shape(
      c,
      Path()
        ..moveTo(x - 17, y + 4)
        ..quadraticBezierTo(x - 23, y - 18, x, y - 13)
        ..quadraticBezierTo(x + 22, y - 21, x + 18, y + 9)
        ..lineTo(x + 12, y + 4)
        ..lineTo(x + 7, y - 3)
        ..lineTo(x - 10, y + 2)
        ..close(),
      const Color(0xff3e382d),
    );
    c.drawCircle(Offset(x - 5, y + 8), 1.5, Paint()..color = ink);
    c.drawCircle(Offset(x + 6, y + 8), 1.5, Paint()..color = ink);
    c.drawArc(
      Rect.fromLTWH(x - 4, y + 10, 9, 7),
      0,
      math.pi,
      false,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    if (book) {
      shape(
        c,
        Path()
          ..moveTo(x - 22, y + 43)
          ..lineTo(x, y + 48)
          ..lineTo(x + 22, y + 40)
          ..lineTo(x + 20, y + 63)
          ..lineTo(x, y + 69)
          ..lineTo(x - 22, y + 62)
          ..close(),
        const Color(0xfff9e7bb),
      );
      c.drawLine(
        Offset(x, y + 48),
        Offset(x, y + 68),
        Paint()
          ..color = ink
          ..strokeWidth = 1.3,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 320, size.height / 220);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 320, 220),
      Paint()..color = const Color(0xffa9d7b3),
    );
    final sun = Paint()..color = const Color(0xffffd97e);
    canvas.drawCircle(const Offset(266, 47), 32, sun);
    shape(
      canvas,
      Path()
        ..moveTo(0, 134)
        ..quadraticBezierTo(83, 92, 164, 143)
        ..quadraticBezierTo(250, 111, 320, 129)
        ..lineTo(320, 220)
        ..lineTo(0, 220)
        ..close(),
      const Color(0xff69ad79),
    );
    shape(
      canvas,
      Path()
        ..moveTo(0, 187)
        ..quadraticBezierTo(140, 123, 320, 178)
        ..lineTo(320, 220)
        ..lineTo(0, 220)
        ..close(),
      const Color(0xfff2c77e),
    );
    for (final x in [21.0, 292.0]) {
      shape(
        canvas,
        Path()
          ..moveTo(x, 178)
          ..lineTo(x + 8, 31)
          ..lineTo(x + 19, 34)
          ..lineTo(x + 16, 178)
          ..close(),
        const Color(0xffa26c50),
      );
      for (var i = 0; i < 3; i++) {
        oval(
          canvas,
          Rect.fromCircle(
            center: Offset(x + (i - 1) * 20, 35 + (i % 2) * 20),
            radius: 35,
          ),
          i == 1 ? const Color(0xff49946a) : const Color(0xff77b86e),
        );
      }
    }
    if (scene == 1) {
      shape(
        canvas,
        Path()
          ..moveTo(75, 92)
          ..lineTo(164, 42)
          ..lineTo(249, 92)
          ..close(),
        const Color(0xffb9674d),
      );
      shape(
        canvas,
        Path()..addRect(const Rect.fromLTWH(86, 92, 151, 94)),
        const Color(0xfff5dfad),
      );
      for (final x in [105.0, 156.0, 207.0]) {
        shape(
          canvas,
          Path()..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, 108, 17, 30),
              const Radius.circular(8),
            ),
          ),
          const Color(0xff507f73),
        );
      }
      shape(
        canvas,
        Path()..addRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(149, 151, 29, 36),
            const Radius.circular(10),
          ),
        ),
        const Color(0xff97634a),
      );
    } else if (scene == 2) {
      person(canvas, 112, 100, const Color(0xfff4bd59), book: true);
      person(canvas, 190, 93, const Color(0xffcf7960), book: true);
      shape(
        canvas,
        Path()..addRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(80, 163, 151, 13),
            const Radius.circular(6),
          ),
        ),
        const Color(0xff8c5942),
      );
    } else {
      shape(
        canvas,
        Path()..addRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(79, 167, 157, 16),
            const Radius.circular(7),
          ),
        ),
        const Color(0xffa66848),
      );
      person(canvas, 155, 84, const Color(0xfff6bc56), book: true);
      for (var i = 0; i < 3; i++) {
        shape(
          canvas,
          Path()..addRect(Rect.fromLTWH(212.0, 155 - i * 8, 33 + i * 3, 7)),
          [
            const Color(0xffd78b65),
            const Color(0xfff9e3af),
            const Color(0xff8bb6a4),
          ][i],
        );
      }
    }
    for (final x in [45.0, 263.0]) {
      canvas.drawLine(
        Offset(x, 214),
        Offset(x - 3, 182),
        Paint()
          ..color = ink
          ..strokeWidth = 1.8,
      );
      oval(canvas, Rect.fromLTWH(x - 16, 184, 16, 8), const Color(0xff609c68));
      oval(canvas, Rect.fromLTWH(x, 193, 18, 9), const Color(0xff609c68));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StudyPainter oldDelegate) =>
      oldDelegate.scene != scene;
}
