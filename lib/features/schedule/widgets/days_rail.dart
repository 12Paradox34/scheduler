// lib/features/schedule/widgets/days_rail.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/colors.dart';
import '../../../core/typography.dart';
import '../../../models/task.dart';

class DaysRail extends StatelessWidget {
  final DateTime centerDay;
  final int visibleBefore;
  final int visibleAfter;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onSelect;
  final List<Task> tasks;

  final double minLineHeight;
  final double cardHeightEstimate;
  final double minGap;
  final double maxGapBetweenCards;

  const DaysRail({
    super.key,
    required this.centerDay,
    required this.visibleBefore,
    required this.visibleAfter,
    required this.selectedDay,
    required this.onSelect,
    required this.tasks,
    this.minLineHeight = 200.0,
    this.cardHeightEstimate = 80.0,
    this.minGap = 12.0,
    this.maxGapBetweenCards = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      visibleBefore + visibleAfter + 1,
          (i) => centerDay.add(Duration(days: i - visibleBefore)),
    );

    // tasks for the selected day (only these will be rendered as cards)
    final selectedTasks = tasks
        .where((t) => _isSameDay(t.start, selectedDay))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    final estimatedHeight = selectedTasks.isEmpty
        ? minLineHeight
        : (selectedTasks.length * (cardHeightEstimate + minGap)) +
        cardHeightEstimate +
        120.0;

    final dynamicHeight = max(minLineHeight, estimatedHeight);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: dynamicHeight,
      child: ListView.separated(
        // critical so cards can paint outside 56px column
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, i) {
          final day = days[i];
          final isSelected = _isSameDay(day, selectedDay);
          final isToday = _isSameDay(day, DateTime.now());

          final dateLabel = isToday ? 'Today' : DateFormat('d').format(day);
          final monthLabel = DateFormat('MMM').format(day);

          // fixed 56px width for every day column
          const double itemWidth = 56.0;
          const double lineX = itemWidth / 2; // center of the column

          return GestureDetector(
            onTap: () => onSelect(day),
            child: SizedBox(
              width: itemWidth,
              // allow children to overflow horizontally
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // non-selected days: dashed line only, behind
                  if (!isSelected)
                    Positioned.fill(
                      child: _DayColumn(
                        dateLabel: dateLabel,
                        monthLabel: monthLabel,
                        isSelected: false,
                        lineHeight: dynamicHeight - 40,
                        tasks: const [],
                        minGap: minGap,
                        maxGapBetweenCards: maxGapBetweenCards,
                        cardHeightEstimate: cardHeightEstimate,
                        lineX: lineX,
                      ),
                    ),

                  // selected day: draw on top so its cards overlap neighbours
                  if (isSelected)
                    Positioned.fill(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: _DayColumn(
                          key: const ValueKey('selected'),
                          dateLabel: dateLabel,
                          monthLabel: monthLabel,
                          isSelected: true,
                          lineHeight: dynamicHeight - 40,
                          tasks: selectedTasks,
                          minGap: minGap,
                          maxGapBetweenCards: maxGapBetweenCards,
                          cardHeightEstimate: cardHeightEstimate,
                          lineX: lineX,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayColumn extends StatelessWidget {
  final String dateLabel;
  final String monthLabel;
  final bool isSelected;
  final double lineHeight;
  final List<Task> tasks;
  final double minGap;
  final double maxGapBetweenCards;
  final double cardHeightEstimate;
  final double lineX;

  const _DayColumn({
    super.key,
    required this.dateLabel,
    required this.monthLabel,
    required this.isSelected,
    required this.lineHeight,
    required this.tasks,
    required this.minGap,
    required this.maxGapBetweenCards,
    required this.cardHeightEstimate,
    required this.lineX,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor =
    isSelected ? AppColors.textPrimary : AppColors.textSecondary;

    return Column(
      children: [
        Text(
          dateLabel,
          style: AppTypography.body.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: labelColor,
          ),
        ),
        Text(
          monthLabel,
          style: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: SizedBox(
            height: lineHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // dashed vertical line
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DashedLinePainter(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary.withOpacity(0.3),
                      strokeWidth: isSelected ? 2.0 : 1.0,
                      dashHeight: 4.0,
                      dashSpace: 2.0,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned.fill(
                    child: _TasksStack(
                      tasks: tasks,
                      totalHeight: lineHeight,
                      minGap: minGap,
                      maxGapBetweenCards: maxGapBetweenCards,
                      cardHeightEstimate: cardHeightEstimate,
                      lineX: lineX,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TasksStack extends StatelessWidget {
  final List<Task> tasks;
  final double totalHeight;
  final double minGap;
  final double maxGapBetweenCards;
  final double cardHeightEstimate;
  final double lineX;

  const _TasksStack({
    super.key,
    required this.tasks,
    required this.totalHeight,
    required this.minGap,
    required this.maxGapBetweenCards,
    required this.cardHeightEstimate,
    required this.lineX,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    const double cardWidth = 200.0;
    const double stepShift = 32.0;
    const double dotClearance = 10.0;

    final List<Widget> positioned = [];
    double lastBottom = 0.0;

    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      final Color bgColor =
      (i % 2 == 0) ? const Color(0xFF3D675A) : const Color(0xFF465A54);

      // Zig-zag offsets
      double left;
      switch (i % 4) {
        case 0:
          left = lineX - (cardWidth / 2);
          break;
        case 1:
          left = lineX ;
          break;
        case 2:
          left = lineX - (2 * stepShift);
          break;
        case 3:
          left = lineX - (4.5 * stepShift);
          break;
        default:
          left = lineX;
      }

      double idealTop = _timeToDy(task.start, totalHeight);

      double top;
      if (i == 0) {
        // first card: dot + minGap
        top = dotClearance + minGap;
      } else {
        final minTop = lastBottom + minGap;
        final maxTop = lastBottom + maxGapBetweenCards;
        top = idealTop;
        if (top < minTop) top = minTop;
        if (top > maxTop) top = maxTop;
      }

      positioned.add(
        Positioned(
          left: left,
          width: cardWidth,
          top: top,
          child: _MiniTaskCard(task: task, backgroundColor: bgColor),
        ),
      );

      lastBottom = top + cardHeightEstimate;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: positioned,
    );
  }

  double _timeToDy(DateTime dt, double totalHeight) {
    final minutes = dt.hour * 60 + dt.minute;
    return (minutes / (24 * 60)) * totalHeight;
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashHeight;
  final double dashSpace;

  _DashedLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashHeight,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final x = size.width / 2;

    // Top dot
    final double dotRadius = strokeWidth * 1.5;
    final double topDotCenterY = dotRadius;
    canvas.drawCircle(Offset(x, topDotCenterY), dotRadius, dotPaint);

    // Bottom dot
    final double bottomDotCenterY = size.height - dotRadius;

    // Dashed body between top and bottom dot
    double y = topDotCenterY + dotRadius + dashSpace;
    final double maxYForLine = bottomDotCenterY - dotRadius - dashSpace;

    while (y < maxYForLine) {
      final double nextY = (y + dashHeight).clamp(0.0, maxYForLine);
      canvas.drawLine(Offset(x, y), Offset(x, nextY), linePaint);
      y = nextY + dashSpace;
    }

    // Draw bottom dot
    canvas.drawCircle(Offset(x, bottomDotCenterY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class _MiniTaskCard extends StatelessWidget {
  final Task task;
  final Color backgroundColor;

  const _MiniTaskCard({
    required this.task,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 1),
            color: Colors.black26,
          )
        ],
      ),
      child: DefaultTextStyle(
        style: AppTypography.label.copyWith(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              task.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
