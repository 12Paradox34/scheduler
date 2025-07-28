import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../core/typography.dart';

class MonthHeader extends StatelessWidget {
final String month;
final VoidCallback onPrev;
final VoidCallback onNext;

const MonthHeader({
super.key,
required this.month,
required this.onPrev,
required this.onNext,
});

@override
Widget build(BuildContext context) {
return Row(
children: [
IconButton(
onPressed: onPrev,
icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
),
Expanded(
child: Center(
child: Text(month, style: AppTypography.h2),
),
),
IconButton(
onPressed: onNext,
icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
),
],
);
}
}