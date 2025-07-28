import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../models/task.dart';

// widgets
import 'widgets/mini_calendar.dart';
import 'widgets/month_header.dart';
import 'widgets/days_rail.dart';
import 'widgets/month_days_strip.dart';


class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _focusedMonth = DateTime(2024, 3, 9);
  DateTime _selectedDay = DateTime(2024, 3, 26);

  // List of all tasks
  final List<Task> _tasks = [
    Task(
      title: 'Setup temporary site offices',
      subtitle: 'Establish your site office in control of compliance',
      start: DateTime(2024, 3, 26, 8),
      end: DateTime(2024, 3, 26, 9, 30),
      type: TaskType.current,
    ),
    Task(
      title: 'Pour concrete footings',
      subtitle:
      'Coordinate the start of topography by grading and cover with sand...',
      start: DateTime(2024, 3, 26, 11),
      end: DateTime(2024, 3, 26, 12, 30),
      type: TaskType.upcoming,
    ),
    Task(
      title: 'Water curing for footings',
      subtitle: 'Discussed how to save the world',
      start: DateTime(2024, 3, 26, 14),
      end: DateTime(2024, 3, 26, 15),
      type: TaskType.current,
    ),
    Task(
      title: 'Layout plumbing pipes',
      subtitle: 'Mark places & dimensions for drainline, bathroom, etc.',
      start: DateTime(2024, 3, 26, 16),
      end: DateTime(2024, 3, 26, 17),
      type: TaskType.today,
    ),
  ];

  void _goPrevMonth() {
    setState(() {
      _focusedMonth =
          DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _goNextMonth() {
    setState(() {
      _focusedMonth =
          DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  void _onDaySelected(DateTime day) {
    setState(() => _selectedDay = day);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final selectedDateStr = _isSameDay(_selectedDay, today)
        ? 'Today, ${DateFormat("d MMM").format(_selectedDay)}'
        : DateFormat("d MMM").format(_selectedDay);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ------------ TOP (heading + month calendar) ------------
            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('Schedule', style: AppTypography.h1)),
                    const SizedBox(height: 8),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First line: Today, 9th
                        Text(
                          'Today, 9th',
                          style: AppTypography.topSidebar.copyWith(color: AppColors.textSecondary),
                        ),
                        //const SizedBox(height: 4),

                        // Second line: March 2024 on left, Month ▼ on right
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'March 2024',
                              style: AppTypography.topSidebar.copyWith(color: AppColors.textSecondary),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Month',
                                  style: AppTypography.monthSidebar.copyWith(color: AppColors.textSecondary),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const SizedBox(height: 12),
                    // Mini calendar
                    MiniCalendar(
                      focusedMonth: _focusedMonth,
                      selectedDay: _selectedDay,
                      onDaySelected: _onDaySelected,
                      currentRange: DateTimeRange(
                        start: DateTime(2024, 3, 12),
                        end: DateTime(2024, 3, 21),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ------------ Month header + chip ------------
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.background,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                      MonthHeader(
                        month: DateFormat('MMMM').format(_focusedMonth),
                        onPrev: _goPrevMonth,
                        onNext: _goNextMonth,
                      ),
                    const SizedBox(height: 8),
                    MonthDaysStrip(
                      selectedDay: _selectedDay,
                      focusedMonth: _focusedMonth,
                      onSelect: _onDaySelected,
                      chipHeight: 24,
                    ),
                  ],
                ),
              ),
            ),

// ------------ DaysRail (scrolls as tall as it needs) ------------
            // ------------ DaysRail (with rounded top corners) ------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomRight:Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                    color:  Color(0xFFF3F6F6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),

                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: DaysRail(
                      centerDay: _selectedDay,
                      visibleBefore: 30,
                      visibleAfter: 30,
                      selectedDay: _selectedDay,
                      onSelect: _onDaySelected,
                      tasks: _tasks,
                      minLineHeight: 200,
                      cardHeightEstimate: 80,
                      minGap: 12,
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
