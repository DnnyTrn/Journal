import 'package:flutter/cupertino.dart';
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
    final String myAppKey = MyApp.KEY; //remove hard coded as param.

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
      // Switcher(switchName: 'Brightness'),
      // add more ListTiles or Switchers here
    ]));
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class WelcomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Icon(Icons.book, size: 124.0)));
  }
}

// Icon button that displays CupertinoActionSheet when pressed
// pass in function to buttonLogic
class OptionButton extends StatelessWidget {
  final Function buttonLogic;
  final object;
  final String name;
  OptionButton({this.object, this.buttonLogic, this.name = 'null name'});

  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () {
        final action =
            CupertinoActionSheet(title: Text('Choose Option'), actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              buttonLogic(this.object);
            },
            isDestructiveAction: true,
            child: Text('$name'),
          )
        ]);
        showCupertinoModalPopup(context: context, builder: (context) => action);
      },
    );
  }
}
