import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/models/routine_item.dart';

class CategoryIllustration extends StatelessWidget {
  const CategoryIllustration(
      {super.key, required this.category, this.size = 46});
  final RoutineCategory category;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CategoryPainter(category)));
}

class _CategoryPainter extends CustomPainter {
  const _CategoryPainter(this.category);
  final RoutineCategory category;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 48;
    canvas.scale(scale);
    final line = Paint()
      ..color = AppColors.rosePink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = AppColors.babyPink;
    switch (category) {
      case RoutineCategory.skincare:
        final bottle = Path()
          ..moveTo(17, 13)
          ..lineTo(28, 8)
          ..lineTo(38, 29)
          ..lineTo(27, 35)
          ..close();
        canvas.drawPath(bottle, fill);
        canvas.drawPath(bottle, line);
        canvas.drawLine(const Offset(24, 10), const Offset(29, 20), line);
        canvas.drawLine(const Offset(20, 14), const Offset(25, 12), line);
        canvas.drawLine(const Offset(27, 35), const Offset(31, 42), line);
      case RoutineCategory.wellness:
        canvas.drawCircle(const Offset(24, 13), 5, fill);
        canvas.drawCircle(const Offset(24, 13), 5, line);
        canvas.drawArc(
            const Rect.fromLTWH(13, 20, 22, 22), 3.35, 2.7, false, line);
        canvas.drawLine(const Offset(24, 18), const Offset(24, 35), line);
        canvas.drawLine(const Offset(24, 26), const Offset(15, 22), line);
        canvas.drawLine(const Offset(24, 26), const Offset(33, 22), line);
        canvas.drawLine(const Offset(24, 35), const Offset(17, 43), line);
        canvas.drawLine(const Offset(24, 35), const Offset(31, 43), line);
      case RoutineCategory.medication:
        canvas.save();
        canvas.translate(24, 25);
        canvas.rotate(-.65);
        final pill = RRect.fromRectAndRadius(
            const Rect.fromLTWH(-8, -19, 16, 38), const Radius.circular(8));
        canvas.drawRRect(pill, fill);
        canvas.drawRRect(pill, line);
        canvas.drawLine(const Offset(-8, 0), const Offset(8, 0), line);
        canvas.restore();
      case RoutineCategory.custom:
        final heart = Path()
          ..moveTo(24, 40)
          ..cubicTo(20, 36, 7, 29, 7, 19)
          ..cubicTo(7, 12, 16, 10, 21, 16)
          ..cubicTo(24, 10, 33, 12, 33, 19)
          ..cubicTo(33, 29, 28, 35, 24, 40)
          ..close();
        canvas.drawPath(heart, fill);
        canvas.drawPath(heart, line);
        canvas.drawCircle(const Offset(36, 31), 6, fill);
        canvas.drawCircle(const Offset(36, 31), 6, line);
      default:
        canvas.drawCircle(const Offset(24, 24), 14, fill);
        canvas.drawCircle(const Offset(24, 24), 14, line);
    }
  }

  @override
  bool shouldRepaint(covariant _CategoryPainter oldDelegate) =>
      oldDelegate.category != category;
}
