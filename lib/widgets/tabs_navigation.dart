import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/my_quests_screen.dart';

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
        'page': const MyQuestsScreen(), //My Quests Page
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
      appBar: AppBar(
        //title on top
        title: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            _pages[_selectedPageIndex]['title'] as String,
            style: TextStyle(
              fontFamily: 'Lato',
              color: Theme.of(context).accentColor,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 7),
            child: IconButton(
              //onPressed opens the Personal Profile Page
              onPressed: () {},
              icon: const Icon(Icons.person_rounded, size: 33),
            ),
          )
        ],
      ),
      // Shows the widget in the chosen page
      body: _pages[_selectedPageIndex]['page'] as Widget,
      // Navigation bars
      bottomNavigationBar: BottomNavigationBar(
        // Custom BottomNavigationBar
        backgroundColor: Theme.of(context).primaryColor,
        onTap: _selectPage,
        iconSize: 30,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
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