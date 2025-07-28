import 'package:flutter/material.dart';
import 'features/schedule/schedule_screen.dart';
import '../../core/colors.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RootShell(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  final _pages = const [
    _PlaceholderPage('Home'),
    _PlaceholderPage('Subproject'),
    _PlaceholderPage('Tasks'),
    ScheduleScreen(),
    _PlaceholderPage('Queries'),
  ];

  final labels = ['home', 'subproject', 'tasks', 'scheduling', 'queries'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10.75,
        unselectedFontSize: 10.75,
        selectedLabelStyle: AppTypography.navLabelSelected,
        unselectedLabelStyle: AppTypography.navLabelUnselected,
        items: List.generate(labels.length, (i) {
          final label = labels[i];
          return BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/$label.png',
              width: 28.15,
              height: 28.67,
              color: _index == i ? AppColors.primary : const Color(0xFFAEAFB0),
            ),
            label: label[0].toUpperCase() + label.substring(1),
          );
        }),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String text;
  const _PlaceholderPage(this.text, {super.key});

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(text, style: const TextStyle(fontSize: 24)));
}
