import 'package:flutter/material.dart';
import 'package:quest_realm/models/custom_material_color.dart';

import '../screens/quest_details_screen.dart';

class QuestItem extends StatelessWidget {
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

  var _expanded = false;

  void _showQuestDetails(String id, BuildContext ctx) {
    Navigator.of(ctx).pushNamed(QuestDetailsScreen.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showQuestDetails(id, context),
      child: Card(
        color: points <= 25
            ? createMaterialColor(const Color.fromRGBO(0, 142, 135, 1))
            : points <= 50 && points > 25
                ? createMaterialColor(const Color.fromRGBO(146, 52, 16, 1))
                : points <= 100 && points > 50
                    ? createMaterialColor(const Color.fromRGBO(156, 10, 54, 1))
                    : createMaterialColor(const Color.fromRGBO(93, 89, 79, 1)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              // Title and the amount of points given
              child: Text(
                "$title , $points points",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromRGBO(252, 250, 250, 1),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Description of quest
            Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(252, 250, 250, 1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
