import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/user_rank.dart';
import '../widgets/custom_drawer.dart';

class RankingScreen extends StatefulWidget {
  static const routeName = '/ranking-scren';

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  Widget build(BuildContext context) {
    //get the user list

    return Consumer<UserProvider>(
      builder: (context, userData, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Ranking'),
        ),
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView.builder(
            itemBuilder: (context, index) => UserRank(
              index: index,
              username: userData.userList[index].username,
              points: userData.userList[index].points,
            ),
            itemCount: userData.userList.length,
          ),
        ),
      ),
    );
  }
}
