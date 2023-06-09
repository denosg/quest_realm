import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_realm/screens/ranking_screen.dart';

import '../providers/user_provider.dart';
import '../screens/acc_quests_screen.dart';
import '../providers/auth.dart';
import '../screens/roulette_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Consumer<UserProvider>(
            builder: (context, userData, _) => AppBar(
              title: Text('Hello, ${userData.user.username} !'),
              automaticallyImplyLeading: false,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.assignment_turned_in_outlined),
            title: const Text('Accepted Quests'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushReplacementNamed(AccQuestsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.person_4_outlined),
              title: const Text('Ranking'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushReplacementNamed(RankingScreen.routeName);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('Daily gift'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushReplacementNamed(RouletteScreen.routeName);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.exit_to_app_rounded),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }
}
