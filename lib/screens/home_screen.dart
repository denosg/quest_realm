import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_realm/providers/quest_provider.dart';

import '../widgets/quest_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // fetches the quests from the firebase database
    Future.delayed(Duration.zero).then((value) {
      Provider.of<QuestProvider>(context, listen: false).fetchAndSetQuests();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // gets the quests and saves them in a var
    final questData = Provider.of<QuestProvider>(context);
    // gets the size of the app bar for multiple device support for UI
    var appBarHeight = AppBar().preferredSize.height;
    double bottomNavBarHeight =
        MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;
    // saves the quests here:
    final questsList = questData.items;
    return Column(
      children: [
        SizedBox(
          height: (MediaQuery.of(context).size.height -
                  appBarHeight -
                  bottomNavBarHeight) *
              0.949,
          width: double.infinity,
          child: questsList.isEmpty
              ? Center(
                  child: Text(
                    'No quests available !',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              : ListView.builder(
                  itemBuilder: ((context, index) {
                    var id = questsList[index].id;
                    var title = questsList[index].title;
                    var description = questsList[index].description;
                    var points = questsList[index].points;
                    return QuestItem(
                        id: id,
                        title: title,
                        description: description,
                        points: points);
                  }),
                  itemCount: questsList.length,
                ),
        ),
      ],
    );
  }
}
