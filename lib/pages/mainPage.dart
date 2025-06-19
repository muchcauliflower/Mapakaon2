import 'package:flutter/material.dart';
import 'package:mapakaon2/pages/settings_page/settingsPage.dart';
import '../utils/appColors.dart';
import 'history_page/historyPage.dart';
import 'home_page/homePage.dart';
import 'maps_page/mapsPage.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Move _pages here so it has access to _onNavTap and _selectedIndex
    final List<Widget> _pages = [
      homePage(),
      mapsPage(
        onTabSelected: _onNavTap,
        currentIndex: _selectedIndex,
      ),
      historyPage(),
      settingsPage(),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: _pages[_selectedIndex],
        bottomNavigationBar: _selectedIndex == 1
            ? null
            : SizedBox(
          height: 100,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: bgColor,
            currentIndex: _selectedIndex,
            onTap: _onNavTap,
            selectedItemColor: appColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: "Maps",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: "History",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
