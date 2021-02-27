import 'package:flutter/material.dart';
import 'package:journal/widgets/MyAppBar.dart';
import 'package:journal/db/database.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:journal/styles.dart';

class EntryJournal extends StatefulWidget {
  static const routeName = 'Journal Entry Screen';
  @override
  _EntryJournalState createState() => _EntryJournalState();
}

class _EntryJournalState extends State<EntryJournal> {
  @override
  Widget build(BuildContext context) {
    //choosing the option to query the db for entry rather than passing as an object
    final id = ModalRoute.of(context).settings.arguments;
    final entry = DatabaseManager.getInstance().getEntryById(id);
    JournalEntry je;

    return FutureBuilder<JournalEntry>(
      future: entry,
      builder: (BuildContext context, AsyncSnapshot<JournalEntry> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          je = snapshot.data;
          child = ScaffoldWithSettings(
            title: je.date,
            body: Column(
              children: [
                Text('${je.title}', style: Styles.titleStyle),
                Text('${je.body}', style: Styles.bodyStyle),
              ],
            ),
          );
        } else {
          child = ScaffoldWithSettings(
              title: EntryJournal.routeName,
              body: Center(child: CircularProgressIndicator()));
        }
        return child;
      },
    );
  }
}
