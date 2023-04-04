import 'package:flutter/material.dart';
import 'package:quest_realm/models/custom_material_color.dart';

import '../screens/quest_details_screen.dart';

class QuestItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final int points;

  const QuestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
  });

  // TODO: Implement pressed person details
  //opens pressed Quest Details
  // void _showQuestDetails(String id, BuildContext context) {
  //   Navigator.of(context)
  //       .pushNamed(QuestDetailsScreen.routeName, arguments: id);
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => _showQuestDetails(id, context),
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
                  color: Color.fromRGBO(173, 171, 167, 1),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Description of quest
            Container(
              width: 200,
              height: 150,
              padding: const EdgeInsets.all(12),
              child: Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(173, 171, 167, 1),
                      ),
                    ),
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
