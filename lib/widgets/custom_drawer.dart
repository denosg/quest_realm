import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_realm/screens/acc_quests_screen.dart';

import '../screens/my_quests_screen.dart';
import '../providers/auth.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello !'),
            automaticallyImplyLeading: false,
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.assignment_turned_in_outlined),
            title: const Text('Accepted Quests'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(AccQuestsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.quiz_outlined),
              title: const Text('MyQuests'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(MyQuestsScreen.routeName);
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
