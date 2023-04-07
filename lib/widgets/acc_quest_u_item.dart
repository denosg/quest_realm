import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/acc_quests.dart';

class AccQuestUItem extends StatefulWidget {
  final AccQuestItem accQuestItem;

  const AccQuestUItem(this.accQuestItem);

  @override
  State<AccQuestUItem> createState() => _AccQuestUItemState();
}

class _AccQuestUItemState extends State<AccQuestUItem> {
  //_expanded gives the user the option to see the description of the acc quest
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    var accQuest = widget.accQuestItem;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? accQuest.description.length * 0.5 + 120 : 92,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(accQuest.title),
              subtitle: Text(
                  '${DateFormat.yMMMd().format(accQuest.dateTime)}, ${accQuest.points} points'),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ),
            ),
            // shows the description of the quest
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded ? accQuest.description.length * 0.5 + 20 : 0,
              child: Text(accQuest.description),
            )
          ],
        ),
      ),
    );
  }
}
