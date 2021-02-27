import 'package:flutter/material.dart';
import 'package:journal/widgets/MyAppBar.dart';
import 'package:journal/widgets/Widgets.dart';
import 'journal_entry_screen.dart';
import 'journal_screen.dart';
import 'package:journal/screens/new_entry_screen.dart';

class MainScaffold extends StatefulWidget {
  static const routeName = '/';

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SettingsDrawer(),
      appBar: MyAppBar.withSettings(
        widgets: [],
        title: 'My Journal',
      ),
      body: LayoutBuilder(
        builder: layoutDecider,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(NewEntry.routeName)
                .then((value) => setState(() {}));
          }),
    );
  }

  Widget layoutDecider(BuildContext context, BoxConstraints constraints) {
    return constraints.maxWidth < 500 ? verticalLayout() : horizontalLayout();
  }

  Widget horizontalLayout() {
    return Row(
      children: [
        Expanded(child: JournalScreen(showAppBar: false)),
        Expanded(child: EntryJournal(showAppBar: false)),
      ],
    );
  }

  Widget verticalLayout() {
    return JournalScreen(showAppBar: false);
  }
}
