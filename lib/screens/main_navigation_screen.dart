import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'report/report_form_screen.dart';
import 'report/report_history_screen.dart';

/// Screen utama wadah Bottom Navigation Bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Daftar layar berdasarkan urutan tab bottom navigation
  final List<Widget> _screens = const [
    HomeScreen(),
    ReportFormScreen(),
    ReportHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert_outlined),
            activeIcon: Icon(Icons.add_alert),
            label: 'Lapor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}
