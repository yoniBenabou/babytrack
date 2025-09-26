import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import 'home_page.dart';
import 'statistics_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StatisticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final double appBarFontSize = SizeConfig.text(context, 0.07);
    final double appBarIconSize = SizeConfig.icon(context, 0.09);
    final double navBarFontSize = SizeConfig.text(context, 0.055);
    final double navBarIconSize = SizeConfig.icon(context, 0.09);
    final double navBarHeight = SizeConfig.vertical(context, 0.11);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Accueil' : 'Statistiques',
          style: TextStyle(fontSize: appBarFontSize, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        toolbarHeight: navBarHeight,
        leading: Icon(
          _selectedIndex == 0 ? Icons.home : Icons.bar_chart,
          size: appBarIconSize,
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedFontSize: navBarFontSize,
        unselectedFontSize: navBarFontSize,
        iconSize: navBarIconSize,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

