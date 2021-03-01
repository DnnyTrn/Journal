import 'package:flutter/material.dart';
import 'package:journal/widgets/MyAppBar.dart';
import 'package:journal/db/database.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:journal/styles.dart';
import 'package:journal/widgets/Widgets.dart';

class EntryJournal extends StatefulWidget {
  static const routeName = 'Journal Entry Screen';
  final bool showAppBar;
  Future<JournalEntry> entry;
  EntryJournal({Key key, this.showAppBar = true}) : super(key: key);

  @override
  _EntryJournalState createState() => _EntryJournalState();
}

class _EntryJournalState extends State<EntryJournal> {
  @override
  Widget build(BuildContext context) {
    //id can be null to signal screen loaded in landscape mode
    var id = ModalRoute.of(context).settings.arguments;

    final db = DatabaseManager.getInstance();
    if (id == null) {
      widget.entry = db.getFirstRow(); //query 1st row if in landscape mode
    } else {
      widget.entry =
          db.getEntryById(id); //this screen is coupled with previous screen
    }

    return FutureBuilder<JournalEntry>(
      future: widget.entry,
      builder: (BuildContext context, AsyncSnapshot<JournalEntry> snapshot) {
        JournalEntry je;
        Widget child;
        if (snapshot.hasData) {
          je = snapshot.data;
          child = ScaffoldWithSettings(
            showAppBar: widget.showAppBar,
            title: je.date,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${je.title}', style: Styles.titleStyle),
                  Text('Rating: ${je.rating}', style: Styles.ratingStyle),
                  Text('${je.body}', style: Styles.bodyStyle),
                ],
              ),
            ),
          );
        } else {
          child = ScaffoldWithSettings(
              showAppBar: widget.showAppBar,
              title: EntryJournal.routeName,
              body: LoadingWidget());
        }
        return child;
      },
    );
  }
}
