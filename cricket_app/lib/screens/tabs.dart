import 'package:cricket_app/screens/admin/admin.dart';
import 'package:cricket_app/screens/fantasy/fantasy.dart';
import 'package:cricket_app/screens/statistics/statistics.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreen();
  }
}

class _TabsScreen extends State<TabsScreen> {
  int _selectedPageIndex = 2;
  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const AdminScreen();
    var activePageTitle = "Administration";

    if (_selectedPageIndex == 0) {
      activePage = const FantasyScreen();
      activePageTitle = "Fantasy";
    }

    if (_selectedPageIndex == 1) {
      activePage = const StatisticsScreen();
      activePageTitle = "Statistics";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectedPage,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_cricket),
              label: "Fantasy",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dataset_rounded),
              label: "Statistics",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings_rounded),
                label: "Administration"),
          ]),
    );
  }
}
