import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quest_realm/providers/auth.dart';

import './models/custom_material_color.dart';
import './widgets/tabs_navigation.dart';
import './screens/quest_details_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
      ],
      // gets the AuthData here ->
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QuestRealm',
          // the theme of the app
          theme: ThemeData(
            scaffoldBackgroundColor:
                createMaterialColor(const Color.fromARGB(10, 14, 18, 255)),
            fontFamily: 'Lato',
            primarySwatch:
                createMaterialColor(const Color.fromARGB(10, 14, 18, 255)),
            primaryColor:
                createMaterialColor(const Color.fromARGB(10, 14, 18, 255)),
            accentColor:
                createMaterialColor(const Color.fromRGBO(48, 25, 52, 1)),
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
            // Quest details
            QuestDetailsScreen.routeName: (context) => QuestDetailsScreen(),
          },
        ),
      ),
    );
  }
}
