import 'package:flutter/material.dart';
import 'package:journal/app.dart';

// a stateful SwitchListTile widget, provide a title name(switchName)
class Switcher extends StatefulWidget {
  final String switchName;
  final switchIcon;
  const Switcher({this.switchName, this.switchIcon});

  @override
  SwitcherState createState() => SwitcherState();
}

class SwitcherState extends State<Switcher> {
  bool _switchValue;
  void initState() {
    super.initState();
    _switchValue = false;
  }

  @override
  Widget build(BuildContext context) {
    MyAppState myApp = context
        .findAncestorStateOfType<MyAppState>(); //get state of MaterialApp
    _switchValue = myApp
        .preferenceTheme; //switch is set to the current theme from SharedPreference object
    final String myAppKey = MyApp.KEY;

    return SwitchListTile(
      title: Text('${widget.switchName}'),
      value: _switchValue,
      onChanged: (bool newValue) {
        _switchValue = newValue;
        myApp.setState(() {
          myApp.getPreference.setBool(myAppKey, newValue);
        });
      },
      secondary: widget.switchIcon,
    );
  }

// tells MaterialApp to rebuild based on _switchValue
  void toggleDarkMode(bool value, MyAppState myApp) {
    myApp.setState(() {
      myApp.getPreference.setBool(MyApp.KEY, value);
    });
  }
}

// returns a Drawer widget designed to be a menu of setting options, can be used with Scaffold drawer/endDrawer
class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
      Divider(),
      Switcher(
          switchName: 'Dark Mode', switchIcon: Icon(Icons.lightbulb_outline)),
      Divider(),
      Switcher(switchName: 'Brightness'),
    ]));
  }
}

class TestScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          // child: Text('$darkMode'),
          ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: toggleDarkMode,
      // ),
    );
  }
}
