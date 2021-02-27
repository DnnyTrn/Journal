import 'package:flutter/material.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:journal/widgets/MyAppBar.dart';
import 'dart:async';
import 'package:journal/widgets/Widgets.dart';
import 'package:journal/db/database.dart';

const screenName = 'New Journal Entry';

class NewEntry extends StatelessWidget {
  static const routeName = 'new_entry';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SettingsDrawer(),
      appBar: MyAppBar.withSettings(title: screenName, widgets: []),
      body: JournalForm(),
    );
  }

  void backToJournal(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class JournalForm extends StatefulWidget {
  @override
  _JournalFormState createState() => _JournalFormState();
}

class _JournalFormState extends State<JournalForm> {
  GlobalKey<FormState> formKey;
  JournalEntry journalEntry;

  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    journalEntry = JournalEntry();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          children: formFields(context),
        ),
      ),
    );
  }

  List<Widget> formFields(BuildContext context) {
    return [
      TextFormField(
          onSaved: (value) => journalEntry.title = value,
          validator: (value) => validateField(value),
          autofocus: true,
          decoration: InputDecoration(
              labelText: 'Title', border: OutlineInputBorder())),
      SizedBox(height: 10),
      TextFormField(
          onSaved: (value) => journalEntry.body = value,
          validator: (value) => validateField(value),
          decoration:
              InputDecoration(labelText: 'Body', border: OutlineInputBorder())),
      SizedBox(height: 10),
      // DropdownButtonFormField(
      //   validator: (value) => validateField(value),
      //   decoration: InputDecoration(
      //     labelText: 'Rating',
      //     border: OutlineInputBorder(),
      //   ),
      //   items: [DropdownMenuItem(child: Text('1'), value: 1)],
      //   onChanged: (_) {
      //     journalEntry.rating = 1;
      //   },
      // ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        RaisedButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop()),
        RaisedButton(
          child: Text('Submit'),
          onPressed: () async => submitForm(context),
        )
      ])
    ];
  }

  String validateField(String value) {
    return (value == null || value.isEmpty)
        ? 'This field cannot be blank.'
        : null;
  }

  void submitForm(BuildContext context) {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formKey.currentState.save();

      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Saving...')));
      // Scaffold.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //         'Title:${journalEntry.title}, Body:${journalEntry.body}, Rating:${journalEntry.rating}')));

      DatabaseManager.getInstance().insertRow(journalEntry);

      // go to My Journal screen after 1 second and successful save
      Timer(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    }
  }
}
