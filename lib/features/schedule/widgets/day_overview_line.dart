import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../models/task.dart';
import 'task_card.dart';

/// Shows ONE vertical dashed line and places the day's tasks on it
/// proportionally by start time (earlier on top).
class DayOverviewLine extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task) onTaskTap;

  const DayOverviewLine({
    super.key,
    required this.tasks,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    // sort by start time
    final sorted = [...tasks]..sort((a, b) => a.start.compareTo(b.start));

    return const SizedBox(
      height: 600.0, // adjust if needed
      child: _TimelineStack(),
    );
  }
}

class _TimelineStack extends StatelessWidget {
  const _TimelineStack();

  @override
  Widget build(BuildContext context) {
    final inherited = context.findAncestorWidgetOfExactType<DayOverviewLine>()!;
    final tasks = inherited.tasks;
    final onTaskTap = inherited.onTaskTap;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        final sorted = [...tasks]..sort((a, b) => a.start.compareTo(b.start));

        return Stack(
          children: [
            // Vertical dashed line
            Positioned.fill(
              left: 32.0,
              right: null,
              child: CustomPaint(
                painter: _DashedLinePainter(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  dash: 6.0,
                  gap: 4.0,
                  strokeWidth: 2.0,
                ),
              ),
            ),

            // Task cards positioned by time
            ...sorted.map((t) {
              final top = _timeToDy(t.start, totalHeight);
              return Positioned(
                left: 56.0,
                right: 16.0,
                top: top,
                child: GestureDetector(
                  onTap: () => onTaskTap(t),
                  child: TaskCard(task: t),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  /// Map time (0..24h) into available height
  double _timeToDy(DateTime dt, double totalHeight) {
    final minutes = dt.hour * 60 + dt.minute;
    return (minutes / (24 * 60)) * totalHeight;
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dash;
  final double gap;

  const _DashedLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    double y = 0.0;
    const double x = 1.0; // line at ~left edge
    while (y < size.height) {
      canvas.drawLine(Offset(x, y), Offset(x, y + dash), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
