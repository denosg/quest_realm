import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roulette/roulette.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/arrow_item.dart';
import '../widgets/custom_drawer.dart';
import '../providers/user_provider.dart';

class MyRoulette extends StatelessWidget {
  const MyRoulette({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final RouletteController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Roulette(
              // Provide controller to update its state
              controller: controller,
              // Configure roulette's appearance
              style: const RouletteStyle(
                dividerThickness: 4,
                textLayoutBias: .8,
                centerStickerColor: Colors.white,
              ),
            ),
          ),
        ),
        ArrowItem(),
      ],
    );
  }
}

class RouletteScreen extends StatefulWidget {
  static const routeName = '/roulette-screen';

  @override
  State<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends State<RouletteScreen>
    with SingleTickerProviderStateMixin {
  static final _random = Random();

  Future<bool> canPlay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime? lastPlayed = prefs.containsKey('lastPlayed')
        ? DateTime.parse(prefs.getString('lastPlayed')!)
        : null;
    DateTime now = DateTime.now();
    if (lastPlayed != null &&
        lastPlayed.year == now.year &&
        lastPlayed.month == now.month &&
        lastPlayed.day == now.day) {
      return false; // User has already played today
    } else {
      return true; // User can play today
    }
  }

  late RouletteController _controller;

  @override
  void initState() {
    // Initialize the controller
    final group = RouletteGroup([
      const RouletteUnit.text(
        '10',
        color: Color.fromRGBO(178, 154, 185, 1),
        weight: 0.5,
      ),
      const RouletteUnit.text(
        '0',
        color: Color.fromRGBO(157, 51, 172, 1),
        weight: 0.1,
      ),
      const RouletteUnit.text(
        '25',
        color: Color.fromRGBO(106, 36, 69, 1),
        weight: 0.3,
      ),
      const RouletteUnit.text(
        '75',
        color: Color.fromRGBO(29, 5, 16, 1),
        weight: 0.1,
      ),
    ]);
    _controller = RouletteController(vsync: this, group: group);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily gift'),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyRoulette(controller: _controller),
            const SizedBox(
              height: 20,
            ),
            Consumer<UserProvider>(
              builder: (context, userData, _) => Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () async {
                      final scaffoldContext = ScaffoldMessenger.of(context);
                      // verifies if user has already played today
                      bool canPlayToday = await canPlay();
                      // gets the chance of each points
                      if (canPlayToday) {
                        int index = 1 + _random.nextInt(100);
                        if (index <= 10) {
                          // 10 points
                          index = 1;
                        } else if (index <= 20) {
                          // 75 points
                          index = 3;
                        } else if (index <= 70) {
                          // 10 points
                          index = 0;
                        } else if (index <= 100) {
                          // 25 points
                          index = 2;
                        }
                        await _controller.rollTo(index,
                            offset: _random.nextDouble());
                        // saves the last played time
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString(
                            'lastPlayed', DateTime.now().toString());

                        // adds the points in the database
                        String? pointsWonString =
                            _controller.group.units[index].text;
                        if (pointsWonString != null) {
                          int pointsWon = int.parse(pointsWonString);
                          await userData.addPointsByAccQuest(
                              pointsWon, userData.user.userKey);
                        }

                        // shows congrats snackBar
                        scaffoldContext.showSnackBar(SnackBar(
                          content: Text(
                              'Congratulations, you won ${_controller.group.units[index].text} points today !'),
                          duration: const Duration(seconds: 2),
                        ));
                      } else {
                        // User has already played today, show a message or disable the button
                        scaffoldContext.showSnackBar(const SnackBar(
                          content: Text('Already played today !'),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: const Text('Roll!'),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
