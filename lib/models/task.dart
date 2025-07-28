import 'package:flutter/material.dart';

enum TaskType { today, current, upcoming }

class Task {
  final String title;
  final String subtitle;
  final DateTime start;
  final DateTime end;
  final TaskType type;

  Task({
    required this.title,
    required this.subtitle,
    required this.start,
    required this.end,
    required this.type,
  });

  Color get color {
    switch (type) {
      case TaskType.today:
        return const Color(0xFFBDBDBD);
      case TaskType.current:
        return const Color(0xFF0F5248);
      case TaskType.upcoming:
        return const Color(0xFF9BC5BA);
    }
  }
}
