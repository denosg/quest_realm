import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './models/custom_material_color.dart';
import './widgets/tabs_navigation.dart';
import './screens/quest_details_screen.dart';

void main() {
  //Makes it so SystemChrome.setPreferredOrientations works
  WidgetsFlutterBinding.ensureInitialized();
  //Sets preffered orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //Runs the app on boot
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuestRealm',
      theme: ThemeData(
        scaffoldBackgroundColor:
            createMaterialColor(const Color.fromARGB(10, 14, 18, 255)),
        fontFamily: 'Lato',
        primarySwatch:
            createMaterialColor(const Color.fromARGB(10, 14, 18, 255)),
        primaryColor:
            createMaterialColor(const Color.fromARGB(10, 14, 18, 255)),
        accentColor: createMaterialColor(const Color.fromRGBO(48, 25, 52, 1)),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      routes: {
        // Main page
        '/': (context) => TabsNavigation(),
        // Quest details
        QuestDetailsScreen.routeName: (context) => QuestDetailsScreen(),
      },
    );
  }
}
