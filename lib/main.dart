import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:quest_realm/screens/quest_details_screen.dart';
import 'package:quest_realm/screens/roulette_screen.dart';

import './providers/acc_quests.dart';
import './providers/auth.dart';
import './providers/quest_provider.dart';
import './screens/acc_quests_screen.dart';
import './screens/edit_quest_screen.dart';
import './screens/my_quests_screen.dart';
import './providers/user_provider.dart';
import './models/custom_material_color.dart';
import './widgets/tabs_navigation.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/ranking_screen.dart';

void main() async {
  //Loads the API key for firebase
  await dotenv.load(fileName: ".env");
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, QuestProvider>(
          create: (context) => QuestProvider(null, null),
          update: (context, authData, previousQuests) => QuestProvider(
            authData.token,
            authData.userId,
          ),
        ),
        ListenableProxyProvider<Auth, UserProvider>(
          update: (context, authData, previousUser) => UserProvider(
            authToken: authData.token,
            userId: authData.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, AccQuests>(
          create: (context) => AccQuests(null, null),
          update: (context, authData, previousAccQuest) => AccQuests(
            authData.token,
            authData.userId,
          ),
        ),
      ],
      // gets the AuthData here ->
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QuestRealm',
          // the theme of the app
          theme: ThemeData(
            fontFamily: 'Lato',
            primarySwatch:
                createMaterialColor(const Color.fromRGBO(106, 36, 69, 1)),
            primaryColor: Colors.white,
            accentColor: const Color.fromRGBO(106, 36, 69, 1),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          // the screen that shows first when the app loads
          home: authData.isAuth
              // Main page
              ? TabsNavigation()
              // Auth Screen
              : FutureBuilder(
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                  // app tries autoLogin after the app has been closed by the user
                  future: authData.tryAutoLogin(),
                ),
          routes: {
            // Edit Quest Screen
            EditQuestScreen.routeName: (context) => EditQuestScreen(),
            // My Quests Screen
            MyQuestsScreen.routeName: (context) => MyQuestsScreen(),
            // Accepted Quests Screen
            AccQuestsScreen.routeName: (context) => AccQuestsScreen(),
            // Ranking Screen
            RankingScreen.routeName: (context) => RankingScreen(),
            // Roulette Screen
            RouletteScreen.routeName: (context) => RouletteScreen(),
            // Quest Details Screen
            QuestDetailsScreen.routeName: (context) => QuestDetailsScreen(),
          },
        ),
      ),
    );
  }
}
