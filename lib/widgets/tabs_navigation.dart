import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';
import '../screens/home_screen.dart';
import '../screens/my_quests_screen.dart';

// ignore: use_key_in_widget_constructors
class TabsNavigation extends StatefulWidget {
  @override
  State<TabsNavigation> createState() => _TabsNavigationState();
}

class _TabsNavigationState extends State<TabsNavigation> {
  List<Map<String, Object>> _pages = [];

  @override
  void initState() {
    _pages = [
      {
        'page': HomeScreen(), //Home Page
        'title': 'Home',
      },
      {
        'page': MyQuestsScreen(), //My Quests Page
        'title': 'MyQuests',
      },
    ];
    super.initState();
  }

  int _selectedPageIndex = 0;
  //Flutter gives the index automatically of the selected tab
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // custom drawer
      drawer: const CustomDrawer(),
      // Shows the widget in the chosen page
      body: _pages[_selectedPageIndex]['page'] as Widget,
      // Navigation bars
      bottomNavigationBar: BottomNavigationBar(
        // Custom BottomNavigationBar
        backgroundColor: Theme.of(context).primaryColor,
        onTap: _selectPage,
        iconSize: 30,
        unselectedItemColor: Theme.of(context).accentColor,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          //home
          BottomNavigationBarItem(
            // backgroundColor: Colors.white,
            activeIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          //my quests
          BottomNavigationBarItem(
            // backgroundColor: Colors.white,
            activeIcon: Icon(Icons.quiz_rounded),
            icon: Icon(Icons.quiz_outlined),
            label: 'MyQuests',
          ),
        ],
      ),
    );
  }
}
