import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UserRank extends StatelessWidget {
  final int index;
  final String username;
  final int points;

  const UserRank(
      {required this.index, required this.username, required this.points});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // sorted users
          Text(
            '${index + 1}. $username',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          // points of the user
          Text(
            '$points points',
            style: const TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}
