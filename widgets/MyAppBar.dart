import 'package:flutter/material.dart';
import 'Widgets.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final String title;
  final List<Widget> widgets = List<Widget>();

// use this to make an appbar with the settings drawer
  MyAppBar.withSettings({
    Key key,
    this.backgroundColor = Colors.blue,
    this.title = 'null Title',
  }) : super(key: key) {
    this.widgets.add(gearIcon());
  }

  MyAppBar({
    Key key,
    this.title = 'null Title',
    this.backgroundColor = Colors.green,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title), backgroundColor: backgroundColor, actions: widgets);
  }

  Builder gearIcon() {
    return Builder(
        builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ));
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class ScaffoldWithSettings extends StatefulWidget {
  Widget body;
  Widget appBar;
  final bool showAppBar;
  Widget endDrawer;
  final title;

  ScaffoldWithSettings({
    this.body,
    this.showAppBar = true,
    this.appBar,
    this.endDrawer,
    this.title,
  }) {
    this.endDrawer = SettingsDrawer();
    this.appBar = showAppBar ? MyAppBar.withSettings(title: title) : null;
  }

  @override
  _ScaffoldWithSettingsState createState() => _ScaffoldWithSettingsState();

  static FloatingActionButton floatingActionButton(
      BuildContext context, String routeName) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(routeName));
  }
}

class _ScaffoldWithSettingsState extends State<ScaffoldWithSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: this.widget.body,
        appBar: this.widget.appBar,
        endDrawer: this.widget.endDrawer);
  }
}
