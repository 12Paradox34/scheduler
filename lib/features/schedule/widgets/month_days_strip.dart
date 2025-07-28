import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/colors.dart';
import '../../../core/typography.dart';

class MonthDaysStrip extends StatefulWidget {
  final DateTime selectedDay;
  final DateTime focusedMonth; // which month's days to render
  final ValueChanged<DateTime> onSelect;

  /// Control the chip height
  final double chipHeight;

  const MonthDaysStrip({
    super.key,
    required this.selectedDay,
    required this.focusedMonth,
    required this.onSelect,
    this.chipHeight = 28, // default height
  });

  @override
  State<MonthDaysStrip> createState() => _MonthDaysStripState();
}

class _MonthDaysStripState extends State<MonthDaysStrip> {
  final _keys = <String, GlobalKey>{};

  @override
  void didUpdateWidget(covariant MonthDaysStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameDay(oldWidget.selectedDay, widget.selectedDay) ||
        oldWidget.focusedMonth.year != widget.focusedMonth.year ||
        oldWidget.focusedMonth.month != widget.focusedMonth.month) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelected());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelected());
  }

  void _centerSelected() {
    final key = _keys[_keyFor(widget.selectedDay)];
    if (key?.currentContext == null) return;
    Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 250),
      alignment: 0.5,
      curve: Curves.easeOut,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final first = DateTime(widget.focusedMonth.year, widget.focusedMonth.month, 1);
    final last = DateTime(widget.focusedMonth.year, widget.focusedMonth.month + 1, 0);

    final days = List<DateTime>.generate(
      last.day,
          (i) => DateTime(widget.focusedMonth.year, widget.focusedMonth.month, i + 1),
    );

    final stripHeight = widget.chipHeight + 8; // little breathing room

    return SizedBox(
      height: stripHeight,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 25),
        itemBuilder: (_, i) {
          final day = days[i];
          final isSelected = _isSameDay(day, widget.selectedDay);

          final k = _keys.putIfAbsent(_keyFor(day), () => GlobalKey());

          if (isSelected) {
            final label = DateFormat("d MMM").format(day); // e.g. 24, Jun
            return Container(
              key: k,
              constraints: BoxConstraints.tightFor(height: widget.chipHeight),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF252F2C),
                borderRadius: BorderRadius.circular(widget.chipHeight / 0.5),
              ),
              child: Text(
                label,
                style: AppTypography.body.copyWith(color: Colors.white, height: 1.0),
              ),
            );
          } else {
            // NEW: highlight immediate neighbours
            final isImmediateNeighbour =
            (day.difference(widget.selectedDay).inDays.abs() == 1);

            final color = isImmediateNeighbour
                ? AppColors.textPrimary // dark black
                : AppColors.textSecondary; // normal grey

            final weight = isImmediateNeighbour ? FontWeight.w600 : FontWeight.w400;

            return GestureDetector(
              key: k,
              onTap: () => widget.onSelect(day),
              child: SizedBox(
                height: widget.chipHeight,
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: AppTypography.body.copyWith(
                      color: color,
                      fontWeight: weight,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  String _keyFor(DateTime d) => '${d.year}-${d.month}-${d.day}';

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
