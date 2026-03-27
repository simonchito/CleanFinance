import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    this.size = 52,
    this.showWordmark = false,
    super.key,
  });

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppPalette.brandBright,
            AppPalette.brand,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppPalette.brand.withValues(alpha: 0.24),
            blurRadius: size * 0.36,
            offset: Offset(0, size * 0.16),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _BrandLogoPainter(
          lineColor: Colors.white,
          accentColor: const Color(0xFFF6D9B5),
        ),
      ),
    );

    if (!showWordmark) {
      return mark;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Clean',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(
              'Finance',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BrandLogoPainter extends CustomPainter {
  const _BrandLogoPainter({
    required this.lineColor,
    required this.accentColor,
  });

  final Color lineColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;

    final softCircle = Paint()
      ..color = accentColor.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.18, center.dy - size.height * 0.16),
      size.width * 0.22,
      softCircle,
    );

    final stroke = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.6, size.width * 0.08)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.22, size.height * 0.62)
      ..cubicTo(
        size.width * 0.34,
        size.height * 0.46,
        size.width * 0.46,
        size.height * 0.56,
        size.width * 0.54,
        size.height * 0.46,
      )
      ..cubicTo(
        size.width * 0.66,
        size.height * 0.29,
        size.width * 0.74,
        size.height * 0.34,
        size.width * 0.78,
        size.height * 0.46,
      );

    canvas.drawPath(path, stroke);

    final barPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;
    final radii = Radius.circular(size.width * 0.04);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.25,
          size.height * 0.67,
          size.width * 0.08,
          size.height * 0.1,
        ),
        radii,
      ),
      barPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.39,
          size.height * 0.61,
          size.width * 0.08,
          size.height * 0.16,
        ),
        radii,
      ),
      barPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.53,
          size.height * 0.56,
          size.width * 0.08,
          size.height * 0.21,
        ),
        radii,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BrandLogoPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.accentColor != accentColor;
  }
}
