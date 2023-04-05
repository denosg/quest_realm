import 'package:flutter/material.dart';
import 'package:quest_realm/screens/edit_quest_screen.dart';

class MyQuestsScreen extends StatelessWidget {
  const MyQuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CircleAvatar(
        backgroundColor: Theme.of(context).accentColor,
        child: IconButton(
          onPressed: () {
            // Edit quest screen (updates if the user edits / adds a new quest)
            Navigator.of(context).pushNamed(EditQuestScreen.routeName);
          },
          icon: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
