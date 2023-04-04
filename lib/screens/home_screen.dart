import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../data/false_data.dart';
import '../widgets/quest_item.dart';

class HomeScreen extends StatelessWidget {
  final List<Quest> falseQuestList = falseData;

  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    double bottomNavBarHeight =
        MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;
    return Column(
      children: [
        SizedBox(
          height: (MediaQuery.of(context).size.height -
                  appBarHeight -
                  bottomNavBarHeight) *
              0.94,
          width: double.infinity,
          child: ListView.builder(
            itemBuilder: ((context, index) {
              var id = falseQuestList[index].id;
              var title = falseQuestList[index].title;
              var description = falseQuestList[index].description;
              var points = falseQuestList[index].points;
              return QuestItem(
                  id: id,
                  title: title,
                  description: description,
                  points: points);
            }),
            itemCount: falseQuestList.length,
          ),
        ),
      ],
    );
  }
}
