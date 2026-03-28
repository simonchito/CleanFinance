import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/entities/analytics_models.dart';
import '../../domain/entities/reports_snapshot.dart';

class DonutChart extends StatelessWidget {
  const DonutChart({
    required this.items,
    super.key,
  });

  final List<CategorySpend> items;

  @override
  Widget build(BuildContext context) {
    final colors = _palette(context);
    final total = items.fold<double>(0, (sum, item) => sum + item.amount);

    return Row(
      children: [
        SizedBox(
          width: 136,
          height: 136,
          child: CustomPaint(
            painter: _DonutPainter(
              items: items,
              colors: colors,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    total == 0 ? '-' : total.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < items.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          items[i].categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        total == 0
                            ? '0%'
                            : '${((items[i].amount / total) * 100).round()}%',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Color> _palette(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return [
      scheme.primary,
      scheme.secondary,
      scheme.tertiary,
      const Color(0xFF67B99A),
      const Color(0xFFF1B56B),
    ];
  }
}

class IncomeExpenseComparison extends StatelessWidget {
  const IncomeExpenseComparison({
    required this.income,
    required this.expense,
    super.key,
  });

  final double income;
  final double expense;

  @override
  Widget build(BuildContext context) {
    final total = math.max(income, expense);
    final scheme = Theme.of(context).colorScheme;

    Widget buildBar(String label, double value, Color color) {
      final widthFactor = total == 0 ? 0.02 : (value / total).clamp(0.02, 1.0);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const Spacer(),
              Text(value.toStringAsFixed(0)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: widthFactor,
              minHeight: 10,
              backgroundColor: color.withValues(alpha: 0.14),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        buildBar('Ingresos', income, scheme.primary),
        const SizedBox(height: 14),
        buildBar('Gastos', expense, scheme.error),
      ],
    );
  }
}

class MonthlyTrendChart extends StatelessWidget {
  const MonthlyTrendChart({
    required this.points,
    super.key,
  });

  final List<MonthlyTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final maxValue = points.fold<double>(
      0,
      (max, point) => math.max(
        max,
        math.max(point.income, math.max(point.expense, point.savings)),
      ),
    );
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final point in points)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _TrendBar(
                                  value: point.income,
                                  maxValue: maxValue,
                                  color: scheme.primary,
                                ),
                                const SizedBox(width: 4),
                                _TrendBar(
                                  value: point.expense,
                                  maxValue: maxValue,
                                  color: scheme.error,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          point.label,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: CustomPaint(
                  painter: _SavingsLinePainter(
                    points: points,
                    maxValue: maxValue,
                    color: scheme.tertiary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendBar extends StatelessWidget {
  const _TrendBar({
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final double value;
  final double maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final heightFactor = maxValue == 0 ? 0.04 : (value / maxValue).clamp(0.04, 1.0);
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: Container(
        width: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({
    required this.items,
    required this.colors,
  });

  final List<CategorySpend> items;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 18.0;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final total = items.fold<double>(0, (sum, item) => sum + item.amount);

    final background = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.black.withValues(alpha: 0.06)
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, background);

    if (total == 0) {
      return;
    }

    var startAngle = -math.pi / 2;
    for (var i = 0; i < items.length; i++) {
      final sweep = (items[i].amount / total) * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = colors[i % colors.length];
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep + 0.02;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.items != items || oldDelegate.colors != colors;
  }
}

class _SavingsLinePainter extends CustomPainter {
  const _SavingsLinePainter({
    required this.points,
    required this.maxValue,
    required this.color,
  });

  final List<MonthlyTrendPoint> points;
  final double maxValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }

    final path = Path();
    final dotPaint = Paint()..color = color;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final usableHeight = size.height - 10;
    final sectionWidth = size.width / points.length;

    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final x = (sectionWidth * index) + (sectionWidth / 2);
      final normalized = maxValue == 0
          ? 0.02
          : (point.savings / maxValue).clamp(0.02, 1.0);
      final y = usableHeight - (usableHeight * normalized);

      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final x = (sectionWidth * index) + (sectionWidth / 2);
      final normalized = maxValue == 0
          ? 0.02
          : (point.savings / maxValue).clamp(0.02, 1.0);
      final y = usableHeight - (usableHeight * normalized);

      canvas.drawCircle(Offset(x, y), 4.5, dotPaint);
      canvas.drawCircle(
        Offset(x, y),
        2.4,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SavingsLinePainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.color != color;
  }
}
