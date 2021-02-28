import 'package:flutter/material.dart';
import 'package:journal/screens/home_screen.dart';
import 'package:journal/screens/journal_entry_screen.dart';
import 'package:journal/widgets/MyAppBar.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:journal/widgets/Widgets.dart';
import 'package:journal/db/database.dart';

const myJournal = 'My Journal';

class JournalScreen extends StatefulWidget {
  static const routeName = 'Journal Screen';
  final bool showAppBar;

  const JournalScreen({Key key, this.showAppBar = true}) : super(key: key);

  @override
  State createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  Journal journal;
  DatabaseManager db = DatabaseManager.getInstance();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSettings(
      showAppBar: widget.showAppBar,
      title: JournalScreen.routeName,
      body: FutureBuilder<List<JournalEntry>>(
          future: db.getJournalEntries(),
          builder: (BuildContext context,
              AsyncSnapshot<List<JournalEntry>> journalEntries) {
            Widget child;
            if (journalEntries.hasData) {
              journal = Journal(entries: journalEntries.data);
              child = ListView.builder(
                  itemCount: journal.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              EntryJournal.routeName,
                              arguments: journalEntries.data[index].id);
                        },
                        trailing: OptionButton(
                            journal.entries[index], deleteButtonLogic),
                        title: Text('${journal.entries[index].title}'),
                        subtitle: Text(journal.entries[index].date));
                  });
            } else if (journalEntries.data == null) {
              child = WelcomeWidget();
            } else {
              child = LoadingWidget();
            }
            return child;
          }),
    );
  }

  void deleteButtonLogic(JournalEntry je) {
    db.deleteRow(je.id);
    Navigator.of(context).pop();
    setState(() {
      MainScaffoldState parent =
          context.findAncestorStateOfType<MainScaffoldState>();
      parent.valueNotifier.value = 1;
    });
  }
}

//   icon: Icon(Icons.more_horiz),
//   onPressed: () {
//     final action = CupertinoActionSheet(
//         title: Text('Choose Option'),
//         actions: [
//           CupertinoActionSheetAction(
//             onPressed: () {
//               db.deleteRow(snapshot.data[index].id);
//               Navigator.of(context).pop();
//               setState(() {
//                 MainScaffoldState parent =
//                     context.findAncestorStateOfType<
//                         MainScaffoldState>();
//                 parent.valueNotifier.value = 1;
//               });
//             },
//             isDestructiveAction: true,
//             child: Text('Delete'),
//           )
//         ]);
//     showCupertinoModalPopup(
//         context: context, builder: (context) => action);
//   },
// ),
