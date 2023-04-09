import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quest_provider.dart';
import '../screens/edit_quest_screen.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/my_quest_item.dart';
import '../providers/user_provider.dart';

class MyQuestsScreen extends StatelessWidget {
  static const routeName = '/my-quests-screen';
  // We need to have listen: false, otherwise it gets in an infinite loop
  // show the quests created by each user
  Future<void> _refreshQuests(BuildContext context) async {
    await Provider.of<QuestProvider>(context, listen: false)
        .fetchAndSetQuests(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title on top
        title: Container(
          padding: const EdgeInsets.only(top: 10),
          child: const Text(
            'MyQuests',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 7),
            // the amount of points the user has
            child: Consumer<UserProvider>(
              builder: (context, userData, _) => Center(
                child: Text('${userData.user.points.toString()} points',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
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
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        // loads the products by user
        future: _refreshQuests(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshQuests(context),
                    child: Consumer<QuestProvider>(
                      builder: (ctx, questData, _) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: ListView.builder(
                          itemBuilder: (context, index) => MyQuestItem(
                            id: questData.items[index].id,
                            title: questData.items[index].title,
                            description: questData.items[index].description,
                            points: questData.items[index].points,
                          ),
                          itemCount: questData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
