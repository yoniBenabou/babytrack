import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import 'home_page.dart';
import 'statistics_page.dart';
import '../widgets/bottle_settings_form.dart';

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
        title: FittedBox(
          child: Text(
            _selectedIndex == 0 ? 'Accueil' : 'Statistiques',
            style: TextStyle(fontSize: appBarFontSize, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        toolbarHeight: navBarHeight,
        leading: Icon(
          _selectedIndex == 0 ? Icons.home : Icons.bar_chart,
          size: appBarIconSize,
        ),
        actions: [
          IconButton(
            icon: const Text('⚙️', style: TextStyle(fontSize: 28)),
            tooltip: 'Paramètres',
            onPressed: () async {
              final saved = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => const BottleSettingsForm(),
              );

              if (saved == true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paramètres biberon mis à jour')));
                setState(() {
                  // trigger rebuild if needed
                });
              }
            },
          ),
        ],
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
