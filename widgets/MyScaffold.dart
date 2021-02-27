import 'package:flutter/material.dart';
import 'package:journal/widgets/MyAppBar.dart';
import 'package:journal/widgets/Widgets.dart';

class ScaffoldWithSettings extends StatelessWidget {
  Widget body;
  AppBar appBar;
  Widget endDrawer;
  final title;

  ScaffoldWithSettings({this.body, this.appBar, this.endDrawer, this.title}) {
    this.endDrawer = SettingsDrawer();
    this.appBar = MyAppBar.withSettings(widgets: [], title: title) as AppBar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: this.body, appBar: this.appBar, endDrawer: this.endDrawer);
  }

// creates a floating action button widget (+) that invokes Navigator.of(context).pushNamed()
  static FloatingActionButton floatingActionButton(
    BuildContext context,
    String routeName,
  ) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(routeName));
  }
}
