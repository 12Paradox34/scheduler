import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/colors.dart';
import '../../../core/typography.dart';

import '../widgets/month_header.dart'; //

class MiniCalendar extends StatefulWidget {
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final void Function(DateTime) onDaySelected;
  final DateTimeRange currentRange;

  const MiniCalendar({
    super.key,
    required this.focusedMonth,
    required this.selectedDay,
    required this.onDaySelected,
    required this.currentRange,
  });

  @override
  State<MiniCalendar> createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<MiniCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.focusedMonth;
  }

  void _goPrevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _goNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    final List<DateTime?> calendar = [];
    for (int i = 0; i < firstWeekday; i++) {
      calendar.add(null);
    }
    for (int i = 1; i <= daysInMonth; i++) {
      calendar.add(DateTime(_focusedMonth.year, _focusedMonth.month, i));
    }
    while (calendar.length % 7 != 0) {
      calendar.add(null);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE2ECEB),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color(0x6B3D675A),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _goPrevMonth,
                    icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        DateFormat('MMMM').format(_focusedMonth),
                        style: AppTypography.monthHeader, // Or any custom TextStyle
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _goNextMonth,
                    icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ),
                ],
              ),
              _WeekdayRow(),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  const int targetStart = 25;
                  const int targetEnd = 30;

                  final index25 = calendar.indexWhere(
                        (d) => d?.day == targetStart && d?.month == 3,
                  );
                  final row25 = index25 ~/ 7;

                  final double cellWidth = constraints.maxWidth / 7;
                  const double cellSpacing = 20;
                  final double cellHeight = (cellWidth / 1.3);

                  return Stack(
                    children: [
                      if (_focusedMonth.month == 3 && _focusedMonth.year == 2024)
                        Positioned(
                          top: row25 * (cellHeight + cellSpacing) + 39,
                          left: 42,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: cellWidth * 6,
                              height: cellHeight + 10,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF888888),
                                  width: 0.8,
                                ),
                                borderRadius: BorderRadius.circular(32),
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      GridView.builder(
                        itemCount: calendar.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: cellSpacing,
                          crossAxisSpacing: 0,
                        ),
                        itemBuilder: (_, index) {
                          final day = calendar[index];
                          if (day == null) return const SizedBox();

                          final isSelected = day.year == widget.selectedDay.year &&
                              day.month == widget.selectedDay.month &&
                              day.day == widget.selectedDay.day;

                          final isSpecialDay = day.day == 9 && day.month == 3;
                          final isRangeHighlight = day.month == 3 &&
                              day.day >= 11 &&
                              day.day <= 20;

                          final prevDay = index > 0 ? calendar[index - 1] : null;
                          final nextDay = index < calendar.length - 1
                              ? calendar[index + 1]
                              : null;

                          final isPrevInRange = prevDay != null &&
                              prevDay.month == 3 &&
                              prevDay.day >= 11 &&
                              prevDay.day <= 20;

                          final isNextInRange = nextDay != null &&
                              nextDay.month == 3 &&
                              nextDay.day >= 11 &&
                              nextDay.day <= 20;

                          final currentRow = index ~/ 7;
                          final prevRow = (index - 1) ~/ 7;
                          final nextRow = (index + 1) ~/ 7;

                          final isSameRowAsPrev =
                              index > 0 && currentRow == prevRow;
                          final isSameRowAsNext =
                              index < calendar.length - 1 &&
                                  currentRow == nextRow;

                          final hasLeftRadius = !(isPrevInRange && isSameRowAsPrev);
                          final hasRightRadius = !(isNextInRange && isSameRowAsNext);

                          BorderRadius borderRadius = BorderRadius.zero;
                          if (isRangeHighlight) {
                            borderRadius = BorderRadius.only(
                              topLeft: hasLeftRadius
                                  ? const Radius.circular(32)
                                  : Radius.zero,
                              bottomLeft: hasLeftRadius
                                  ? const Radius.circular(32)
                                  : Radius.zero,
                              topRight: hasRightRadius
                                  ? const Radius.circular(32)
                                  : Radius.zero,
                              bottomRight: hasRightRadius
                                  ? const Radius.circular(32)
                                  : Radius.zero,
                            );
                          } else if (isSelected || isSpecialDay) {
                            borderRadius = BorderRadius.circular(100);
                          }

                          Color? bgColor;
                          if (isRangeHighlight || isSelected) {
                            bgColor = AppColors.primary;
                          } else if (isSpecialDay) {
                            bgColor = const Color(0xFFD9D9D9);
                          }

                          return GestureDetector(
                            onTap: () => widget.onDaySelected(day),
                            child: AspectRatio(
                              aspectRatio: 1.3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: borderRadius,
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  '${day.day}',
                                  style: AppTypography.body.copyWith(
                                    fontSize: 14,
                                    color: (isRangeHighlight || isSelected)
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                    fontWeight: (isRangeHighlight || isSelected)
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dot(AppColors.dotToday),
            const SizedBox(width: 4),
            Text('Today', style: AppTypography.label),
            const SizedBox(width: 12),
            _dot(AppColors.dotCurrent),
            const SizedBox(width: 4),
            Text('Current tasks', style: AppTypography.label),
            const SizedBox(width: 12),
            _dot(AppColors.dotUpcoming, withBorder: true),
            const SizedBox(width: 4),
            Text('Upcoming tasks', style: AppTypography.label),
          ],
        ),
      ],
    );
  }

  Widget _dot(Color color, {bool withBorder = false}) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: withBorder
            ? Border.all(color: const Color(0xFF888888), width: 1.03)
            : null,
      ),
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  final days = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: days
          .map((d) => Expanded(
        child: Center(
          child: Text(
            d,
            style: AppTypography.label.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ))
          .toList(),
    );
  }
}
