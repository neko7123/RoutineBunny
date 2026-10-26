import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum NavIconType { home, calendar, add, items, settings }

/// Small, scalable vector icons matching the RoutineBunny navigation artwork.
/// Keeping these as painters avoids raster assets and keeps them crisp at every
/// device density.
class NavIcon extends StatelessWidget {
  const NavIcon(
      {super.key, required this.type, this.selected = false, this.size = 30});

  final NavIconType type;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _NavIconPainter(type: type, selected: selected),
      );
}

class _NavIconPainter extends CustomPainter {
  _NavIconPainter({required this.type, required this.selected});

  final NavIconType type;
  final bool selected;

  static const _pink = AppColors.rosePink;
  static const _dark = AppColors.mutedBrown;
  static const _red = AppColors.strawberryPink;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 40;
    canvas.save();
    canvas.scale(scale, scale);
    switch (type) {
      case NavIconType.home:
        _home(canvas);
      case NavIconType.calendar:
        _calendar(canvas);
      case NavIconType.add:
        _add(canvas);
      case NavIconType.items:
        _items(canvas);
      case NavIconType.settings:
        _settings(canvas);
    }
    canvas.restore();
  }

  Paint _line(Color color, {double width = 2.2}) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint _fill(Color color) => Paint()..color = color;

  void _home(Canvas canvas) {
    final color = selected ? _pink : _dark;
    final roof = Path()
      ..moveTo(7, 18)
      ..lineTo(20, 7)
      ..lineTo(33, 18)
      ..lineTo(30, 18)
      ..lineTo(30, 31)
      ..quadraticBezierTo(30, 33, 28, 33)
      ..lineTo(22, 33)
      ..lineTo(22, 25)
      ..lineTo(18, 25)
      ..lineTo(18, 33)
      ..lineTo(12, 33)
      ..quadraticBezierTo(10, 33, 10, 31)
      ..lineTo(10, 18)
      ..close();
    canvas.drawPath(
        roof,
        selected
            ? _fill(_pink.withValues(alpha: .88))
            : _line(color, width: 2.4));
    canvas.drawPath(_heart(const Offset(20, 21), 4.4),
        _fill(selected ? Colors.white : _pink));
    if (selected) _rays(canvas, const Offset(20, 4), _pink);
  }

  void _calendar(Canvas canvas) {
    final color = selected ? _pink : _dark;
    final outline = RRect.fromRectAndRadius(
        const Rect.fromLTWH(7, 9, 26, 24), const Radius.circular(4));
    canvas.drawRRect(outline, _line(color, width: 2.2));
    canvas.drawLine(
        const Offset(8, 16), const Offset(32, 16), _line(color, width: 2));
    for (final x in [13.0, 27.0]) {
      canvas.drawLine(Offset(x, 6), Offset(x, 12), _line(color, width: 2.6));
      canvas.drawCircle(Offset(x, 7), 1.4, _fill(AppColors.cream));
    }
    canvas.drawPath(_heart(const Offset(20, 24), 4.2), _fill(_pink));
  }

  void _add(Canvas canvas) {
    final color = _pink;
    canvas.drawCircle(const Offset(20, 20), 12, _line(color, width: 2.4));
    canvas.drawLine(
        const Offset(14, 20), const Offset(26, 20), _line(color, width: 2.8));
    canvas.drawLine(
        const Offset(20, 14), const Offset(20, 26), _line(color, width: 2.8));
    _rays(canvas, const Offset(20, 4), color);
  }

  void _items(Canvas canvas) {
    final color = selected ? _pink : _dark;
    final bag = Path()
      ..moveTo(9, 14)
      ..quadraticBezierTo(9, 12, 11, 12)
      ..lineTo(29, 12)
      ..quadraticBezierTo(31, 12, 31, 14)
      ..lineTo(30, 31)
      ..quadraticBezierTo(30, 33, 28, 33)
      ..lineTo(12, 33)
      ..quadraticBezierTo(10, 33, 10, 31)
      ..close();
    canvas.drawPath(bag, _line(color, width: 2.2));
    canvas.drawArc(const Rect.fromLTWH(14, 5, 12, 13), math.pi, math.pi, false,
        _line(color, width: 2.2));
    canvas.drawPath(_heart(const Offset(20, 22), 4.2), _fill(_pink));
    canvas.drawCircle(const Offset(30, 9), 3.5, _fill(_red));
    canvas.drawCircle(const Offset(30, 9), 2.1,
        _fill(AppColors.softWhite.withValues(alpha: .45)));
  }

  void _settings(Canvas canvas) {
    final color = selected ? _pink : _dark;
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final angle = -math.pi / 2 + i * math.pi / 8;
      final radius = i.isEven ? 14.5 : 11.5;
      final point =
          Offset(20 + math.cos(angle) * radius, 20 + math.sin(angle) * radius);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, _line(color, width: 2.2));
    canvas.drawCircle(const Offset(20, 20), 5, _line(color, width: 2.2));
  }

  void _rays(Canvas canvas, Offset center, Color color) {
    canvas.drawLine(
        const Offset(7, 10), const Offset(4, 8), _line(color, width: 1.5));
    canvas.drawLine(
        const Offset(33, 10), const Offset(36, 8), _line(color, width: 1.5));
    canvas.drawLine(Offset(center.dx, center.dy),
        Offset(center.dx, center.dy - 2), _line(color, width: 1.5));
  }

  Path _heart(Offset center, double size) {
    final x = center.dx;
    final y = center.dy;
    final p = Path()..moveTo(x, y + size);
    p.cubicTo(x - size * 1.7, y - size * .1, x - size, y - size * 1.3,
        x - size * .45, y - size * 1.15);
    p.cubicTo(
        x - size * .1, y - size * 1.1, x, y - size * .75, x, y - size * .55);
    p.cubicTo(x, y - size * .75, x + size * .1, y - size * 1.1, x + size * .45,
        y - size * 1.15);
    p.cubicTo(
        x + size, y - size * 1.3, x + size * 1.7, y - size * .1, x, y + size);
    return p;
  }

  @override
  bool shouldRepaint(covariant _NavIconPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.selected != selected;
}
