import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/acc_quests.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/acc_quest_u_item.dart';

class AccQuestsScreen extends StatelessWidget {
  static const routeName = '/acc-quests-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted Quests'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: Provider.of<AccQuests>(context, listen: false)
            .fetchAndSetAccQuests(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<AccQuests>(
              builder: (context, accQuestData, _) => ListView.builder(
                itemCount: accQuestData.accQuests.length,
                itemBuilder: (ctx, index) =>
                    AccQuestUItem(accQuestData.accQuests[index]),
              ),
            );
          }
        },
      ),
    );
  }
}
