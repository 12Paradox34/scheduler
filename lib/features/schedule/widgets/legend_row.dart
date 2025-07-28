import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../core/typography.dart';

class LegendRow extends StatelessWidget {
  const LegendRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Legend(color: AppColors.dotToday, text: 'today'),
        SizedBox(width: 12),
        _Legend(color: AppColors.dotCurrent, text: 'Current tasks'),
        SizedBox(width: 12),
        _Legend(color: AppColors.dotUpcoming, text: 'Upcoming tasks'),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(text, style: AppTypography.label),
      ],
    );
  }
}
