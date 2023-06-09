import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quest_provider.dart';
import '../screens/edit_quest_screen.dart';

class QuestDetailsScreen extends StatelessWidget {
  static const routeName = '/quest-details-screen';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)?.settings.arguments as String;
    final selectedQuest = Provider.of<QuestProvider>(context).findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedQuest.title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 50),
            backgroundColor: Theme.of(context).accentColor),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(EditQuestScreen.routeName, arguments: id);
        },
        child: const Text('Edit Quest !'),
      ),
      body: Column(
        children: [
          // TODO: show difficulty of the quest
          // shows the quest's title
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              selectedQuest.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color.fromRGBO(173, 171, 167, 1),
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          // shows the quest's description
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              selectedQuest.description,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromRGBO(173, 171, 167, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
