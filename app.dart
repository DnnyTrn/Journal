import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'styles.dart';
import 'screens/new_entry_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/journal_entry_screen.dart';

class MyApp extends StatefulWidget {
  final String appName;
  final SharedPreferences preferences;
  static const KEY = 'DARK_MODE_KEY';
  const MyApp({this.appName = 'null', @required this.preferences});

  static final routes = {
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

class ThemeManager extends InheritedWidget {
  final SharedPreferences preferences;
  static const DARK_MODE_KEY = 'DARK_MODE_KEY';
  ThemeData get getTheme => darkMode ? Styles.darkTheme : Styles.lightTheme;
  bool get darkMode => preferences.getBool(MyApp.KEY) ?? false;

  ThemeManager(this.preferences);

  static ThemeManager of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeManager>();
  }

  @override
  bool updateShouldNotify(ThemeManager old) => darkMode != old.darkMode;
}

class MyHomePage extends StatefulWidget {
  static final routeName = '/';
  final String title;
  MyHomePage({Key key, this.title = 'my home page'}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void pushJournalEntryScreen(BuildContext context) {
    Navigator.of(context).pushNamed(NewEntry.routeName, arguments: _counter);
  }

  void backToJournal(BuildContext context) {
    Navigator.of(context).pop();
  }

  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyHomePage'), actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.settings),
            onPressed: _incrementCounter,
          ),
        )
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {pushJournalEntryScreen(context), _incrementCounter()},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
