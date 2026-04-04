import 'package:flutter/material.dart';
import 'package:scanner/core/theme/app_theme.dart';
import 'package:scanner/features/scanner/presentation/pages/home_page.dart';
import 'package:scanner/features/scanner/presentation/pages/history_page.dart';
import 'package:scanner/features/scanner/presentation/pages/qr_generator_page.dart';
import 'package:scanner/features/scanner/presentation/pages/qr_scanner_page.dart';
import 'package:scanner/features/scanner/presentation/widgets/home_widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('OCR Library (Coming Soon)')),
    const QRGeneratorPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRScannerPage()),
        ),
        backgroundColor: AppTheme.primaryNavy,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_a_photo_rounded, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: PremiumBottomNav(
        selectedIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
