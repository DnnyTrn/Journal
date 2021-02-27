import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'styles.dart';
import 'screens/new_entry_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/journal_entry_screen.dart';
import 'screens/home_screen.dart';

class MyApp extends StatefulWidget {
  final String appName;
  final SharedPreferences preferences;
  static const KEY = 'DARK_MODE_KEY';
  const MyApp({this.appName = 'null', @required this.preferences});

  static final routes = {
    MainScaffold.routeName: (context) => MainScaffold(),
    JournalScreen.routeName: (context) => JournalScreen(),
    NewEntry.routeName: (context) => NewEntry(),
    EntryJournal.routeName: (countext) => EntryJournal(),
  };

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: this.widget.appName,
      theme: getThemeData,
      routes: MyApp.routes,
    );
  }

  bool get preferenceTheme => widget.preferences.getBool(MyApp.KEY) ?? false;
  ThemeData get getThemeData =>
      preferenceTheme ? Styles.darkTheme : Styles.lightTheme;
  SharedPreferences get getPreference => widget.preferences;
}
