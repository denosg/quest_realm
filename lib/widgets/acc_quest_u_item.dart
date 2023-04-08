import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/acc_quests.dart';
import '../models/custom_material_color.dart';

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
        elevation: 5,
        // color of the quest based on amount of points
        color: accQuest.points <= 25
            ? createMaterialColor(const Color.fromRGBO(0, 142, 135, 1))
            : accQuest.points <= 50 && accQuest.points > 25
                ? createMaterialColor(const Color.fromRGBO(146, 52, 16, 1))
                : accQuest.points <= 100 && accQuest.points > 50
                    ? createMaterialColor(const Color.fromRGBO(156, 10, 54, 1))
                    : createMaterialColor(const Color.fromRGBO(93, 89, 79, 1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            // quest title
            ListTile(
              title: Text(
                accQuest.title,
                style: const TextStyle(color: Color.fromRGBO(252, 250, 250, 1)),
              ),
              // acc quest time + amount of points
              subtitle: Text(
                '${DateFormat.yMMMd().format(accQuest.dateTime)}, ${accQuest.points} points',
                style: const TextStyle(color: Color.fromRGBO(252, 250, 250, 1)),
              ),
              // expand to see description
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
              child: Text(
                accQuest.description,
                style: const TextStyle(color: Color.fromRGBO(252, 250, 250, 1)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
