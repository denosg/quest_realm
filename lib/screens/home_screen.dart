import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_realm/providers/quest_provider.dart';

import '../widgets/quest_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // fetches the quests from the firebase database
    Future.delayed(Duration.zero).then((value) {
      Provider.of<QuestProvider>(context, listen: false).fetchAndSetQuests();
    });
    super.initState();
  }

  // refreshes the loaded quests
  Future<void> _refreshQuests(BuildContext context) async {
    await Provider.of<QuestProvider>(context, listen: false)
        .fetchAndSetQuests();
  }

  @override
  Widget build(BuildContext context) {
    // gets the quests and saves them in a var
    final questData = Provider.of<QuestProvider>(context);
    // saves the quests here:
    final questsList = questData.items;
    return FutureBuilder(
      future: _refreshQuests(context),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.active
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshQuests(ctx),
                  child: ListView.builder(
                    itemBuilder: ((context, index) {
                      var id = questsList[index].id;
                      var title = questsList[index].title;
                      var description = questsList[index].description;
                      var points = questsList[index].points;
                      return QuestItem(
                          id: id,
                          title: title,
                          description: description,
                          points: points);
                    }),
                    itemCount: questsList.length,
                  ),
                ),
    );
  }
}
