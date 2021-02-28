import 'package:flutter/material.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:journal/widgets/MyAppBar.dart';
import 'package:journal/widgets/Widgets.dart';
import 'journal_entry_screen.dart';
import 'journal_screen.dart';
import 'package:journal/screens/new_entry_screen.dart';
import 'package:journal/db/database.dart';

class MainScaffold extends StatefulWidget {
  static const routeName = '/';
  Future<JournalEntry> firstJournal;
  @override
  MainScaffoldState createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  final valueNotifier = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SettingsDrawer(),
      appBar: MyAppBar.withSettings(title: 'My Journal'),
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
        ValueListenableBuilder<int>(
          builder: (BuildContext context, int value, Widget child) {
            valueNotifier.value = 0;
            return Expanded(child: EntryJournal(showAppBar: false));
          },
          valueListenable: valueNotifier,
          // child: child parameter is most helpful if the child is expensive to build and does not depend on the value from the notifier.
        ),
      ],
    );
  }

  Widget verticalLayout() {
    return JournalScreen(showAppBar: false);
  }
}
