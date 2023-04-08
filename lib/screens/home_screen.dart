import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_realm/providers/quest_provider.dart';
import 'package:quest_realm/widgets/custom_drawer.dart';

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
    return Scaffold(
      appBar: AppBar(
        //title on top
        title: Container(
          padding: const EdgeInsets.only(top: 10),
          child: const Text(
            'Home',
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
            child: Center(
              child: Text('75 points',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
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
      ),
    );
  }
}
