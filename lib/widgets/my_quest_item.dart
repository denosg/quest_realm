import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/custom_material_color.dart';
import '../providers/quest_provider.dart';
import '../screens/quest_details_screen.dart';

class MyQuestItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final int points;

  MyQuestItem({
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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return InkWell(
      // longpressing shows an alert dialog that prompts the user to delete or not the quest
      onLongPress: () async {
        try {
          // Alert dialog for deleting quest
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Are you sure ?'),
                content: const Text(
                    'Do you want to remove your quest ? The points will be lost.'),
                // Options for the user regarding deleting a quest
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<QuestProvider>(context, listen: false)
                          .deteleQuest(id);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes'),
                  )
                ],
              );
            },
          );
        } catch (error) {
          scaffoldMessenger
              .showSnackBar(const SnackBar(content: Text('Deleting failed !')));
        }
      },
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
        elevation: 10,
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              // Title and the amount of points given
              child: Text(
                "$title, $points points",
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
