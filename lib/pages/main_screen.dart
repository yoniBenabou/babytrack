import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import 'home_page.dart';
import 'statistics_page.dart';
import '../widgets/bottle_settings_form.dart';
import 'add_baby_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  // stock id of selected baby
  String _selectedBaby = '';
  // list of id of baby from Users/.../babyIds
  List<String> _babyList = [];
  // mapping id -> firstName from collection 'Babies'
  Map<String, String> _babyNames = {};
  bool _loadingBabies = true;

  @override
  void initState() {
    super.initState();
    _loadBabyIds();
  }

  Future<void> _loadBabyIds() async {
    setState(() {
      _loadingBabies = true;
    });

    try {
      final doc = await FirebaseFirestore.instance.collection('Users').doc('329573563').get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['babyIds'] is List) {
          final ids = (data['babyIds'] as List).map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
          if (ids.isNotEmpty) {
            // collect firstName for each id from collection 'Babies'
            final Map<String, String> names = {};
            await Future.wait(ids.map((id) async {
              try {
                final babyDoc = await FirebaseFirestore.instance.collection('Babies').doc(id).get();
                if (babyDoc.exists) {
                  final babyData = babyDoc.data();
                  final firstName = (babyData != null && babyData['firstName'] != null) ? babyData['firstName'].toString() : id;
                  names[id] = firstName;
                } else {
                  names[id] = id;
                }
              } catch (e) {
                names[id] = id;
                debugPrint('Error loading Baby doc $id: $e');
              }
            }));

            setState(() {
              _babyList = List<String>.from(ids);
              _babyNames = names;
              if (_babyList.isNotEmpty) _selectedBaby = _babyList.first;
              _loadingBabies = false;
            });
            return;
          }
        }
      }
      else {
        /// to do handle no user doc case
        debugPrint('User doc does not exist');
      }
    } catch (e) {
      debugPrint('Error loading babyIds: $e');
    }

    // No babies found - ensure loading flag cleared
    setState(() {
      _babyList = [];
      _babyNames = {};
      _selectedBaby = '';
      _loadingBabies = false;
    });
  }

  // Called when Add Baby is requested - open AddBabyPage and reload if new id returned
  Future<void> _onAddBabyPressed() async {
    final newId = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const AddBabyPage()),
    );
    if (newId != null && newId.isNotEmpty) {
      await _loadBabyIds();
      setState(() {
        _selectedBaby = newId;
      });
    }
  }

  // Build pages dynamically so we can pass the currently selected baby id/name
  List<Widget> get _pages => [
        HomePage(selectedBaby: _selectedBaby),
        StatisticsPage(selectedBaby: _selectedBaby),
      ];

  @override
  Widget build(BuildContext context) {
    final double appBarFontSize = SizeConfig.text(context, 0.07);
    final double appBarIconSize = SizeConfig.icon(context, 0.09);
    final double navBarFontSize = SizeConfig.text(context, 0.055);
    final double navBarIconSize = SizeConfig.icon(context, 0.09);
    final double navBarHeight = SizeConfig.vertical(context, 0.06);
    return Scaffold(
      appBar: AppBar(
        title: _loadingBabies
            ? const SizedBox(width: 120, height: 24, child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
            : (_babyList.isNotEmpty
                ? DropdownButton<String>(
                    value: _selectedBaby.isNotEmpty ? _selectedBaby : null,
                    isExpanded: true,
                    // Use selectedItemBuilder to customize how the selected value is displayed
                    selectedItemBuilder: (BuildContext context) => _babyList
                        .map((id) => Align(
                              alignment: Alignment.center,
                              child: Text(_babyNames[id] ?? id, style: TextStyle(fontSize: appBarFontSize)),
                            ))
                        .toList(),
                    items: _babyList
                        .map((id) => DropdownMenuItem<String>(
                              value: id,
                              child: Text(_babyNames[id] ?? id, style: TextStyle(fontSize: appBarFontSize)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedBaby = value;
                        });
                      }
                    },
                  )
                : Text('Aucun bébé', style: TextStyle(fontSize: appBarFontSize))),
        centerTitle: true,
        toolbarHeight: navBarHeight,
        leading: Icon(
          _selectedIndex == 0 ? Icons.home : Icons.bar_chart,
          size: appBarIconSize,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Ajouter un bébé',
            onPressed: _onAddBabyPressed,
          ),
          IconButton(
            icon: const Text('⚙️', style: TextStyle(fontSize: 26)),
            tooltip: 'Settings',
            onPressed: () {
              showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => const BottleSettingsForm(),
              ).then((saved) {
                if (!mounted) return;
              });
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedFontSize: navBarFontSize*0.9,
        unselectedFontSize: navBarFontSize*0.9,
        iconSize: navBarIconSize*1.1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
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
