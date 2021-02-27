import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal/screens/journal_entry_screen.dart';
import 'package:journal/screens/new_entry_screen.dart';
import 'package:journal/widgets/MyAppBar.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:journal/widgets/Widgets.dart';
import 'package:journal/db/database.dart';

const myJournal = 'My Journal';

class JournalScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  State createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  Journal journal;
  DatabaseManager db = DatabaseManager.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.withSettings(title: myJournal, widgets: []),
      endDrawer: SettingsDrawer(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(NewEntry.routeName)
                .then((value) => setState(() {}));
          }),
      body: FutureBuilder<List<JournalEntry>>(
          future: db.getJournalEntries(),
          builder: (BuildContext context,
              AsyncSnapshot<List<JournalEntry>> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              journal = Journal(entries: snapshot.data);
              child = ListView.builder(
                  itemCount: journal.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              EntryJournal.routeName,
                              arguments: snapshot.data[index].id);
                        },
                        leading: FlutterLogo(),
                        trailing: IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: () {
                            final action = CupertinoActionSheet(
                                title: Text('Choose Option'),
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      db.deleteRow(snapshot.data[index].id);
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                    isDestructiveAction: true,
                                    child: Text('Delete'),
                                  )
                                ]);
                            showCupertinoModalPopup(
                                context: context, builder: (context) => action);
                          },
                        ),
                        title: Text('${journal.entries[index].title}'),
                        subtitle: Text(journal.entries[index].date));
                  });
            } else if (snapshot.data == null) {
              child = Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Placeholder(
                  color: Colors.red,
                ),
              ));
            } else {
              child = Center(child: CircularProgressIndicator());
            }
            return child;
          }),
    );
  }

  Widget journalBody() {
    if (journal == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (journal.length > 0) {
      return ListView.builder(
          itemCount: journal.length,
          itemBuilder: (context, index) {
            return ListTile(
                leading: FlutterLogo(),
                trailing: Icon(Icons.more_horiz),
                title: Text(journal.entries[index].title),
                subtitle: Text(journal.entries[index].body));
          });
    }
    return Text('Welcome');
  }

  void backToJournal(BuildContext context) {
    Navigator.of(context).pop();
  }
}
