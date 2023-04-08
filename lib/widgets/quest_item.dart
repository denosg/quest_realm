import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_realm/models/custom_material_color.dart';
import 'package:quest_realm/models/quest.dart';
import 'package:quest_realm/providers/quest_provider.dart';

import '../providers/acc_quests.dart';

class QuestItem extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final int points;

  QuestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
  });

  @override
  State<QuestItem> createState() => _QuestItemState();
}

class _QuestItemState extends State<QuestItem> {
  //_expanded gives the user the option to see the acc button quest
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? max(widget.description.length * 0.1 + 280, 285) : 220,
      child: Card(
        elevation: 5,
        // color of the quest based on amount of points
        color: widget.points <= 25
            ? createMaterialColor(const Color.fromRGBO(0, 142, 135, 1))
            : widget.points <= 50 && widget.points > 25
                ? createMaterialColor(const Color.fromRGBO(146, 52, 16, 1))
                : widget.points <= 100 && widget.points > 50
                    ? createMaterialColor(const Color.fromRGBO(156, 10, 54, 1))
                    : createMaterialColor(const Color.fromRGBO(93, 89, 79, 1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              // Title and the amount of points given
              child: Text(
                "${widget.title} , ${widget.points} points",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromRGBO(252, 250, 250, 1),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // pressing on the desctiption gives user option to take on the quest
            InkWell(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              // Description of quest
              child: Container(
                width: double.infinity,
                height: 150,
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(252, 250, 250, 1),
                    ),
                  ),
                ),
              ),
            ),
            // shows the acc button of the quest
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded ? max(widget.description.length * 0.1, 60) : 0,
              child: Container(
                child: ElevatedButton(
                  // add acc quest to database
                  onPressed: () async {
                    await Provider.of<AccQuests>(context, listen: false)
                        .addAccQuest(Quest(
                      id: widget.id,
                      title: widget.title,
                      description: widget.description,
                      points: widget.points,
                    ));
                    await Provider.of<QuestProvider>(context, listen: false)
                        .deteleQuest(widget.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Quest accepted !'),
                      duration: Duration(seconds: 2),
                    ));
                  },
                  child: const Text(
                    'Take on this quest !',
                    style: TextStyle(color: Color.fromRGBO(252, 250, 250, 1)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
