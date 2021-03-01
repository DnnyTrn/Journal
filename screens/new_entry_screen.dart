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
      appBar: MyAppBar.withSettings(title: screenName),
      body: JournalForm(),
    );
  }
}

class JournalForm extends StatefulWidget {
  @override
  _JournalFormState createState() => _JournalFormState();
}

class _JournalFormState extends State<JournalForm> {
  GlobalKey<FormState> formKey;
  JournalEntry journalEntry;
  // bool _firstPress = true;

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
      DropdownButtonFormField(
        validator: (value) => validateChoice(value),
        decoration: InputDecoration(
          labelText: 'Rating',
          border: OutlineInputBorder(),
        ),
        items: dropDownItems(5),
        onChanged: (value) {
          setState(() {
            journalEntry.rating = value;
          });
        },
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        RaisedButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop()),
        ElevatedButton(
          child: Text('Submit'),
          onPressed: () async =>
              submitForm(context), //implement a way to disable double presses
        )
      ])
    ];
  }

  String validateChoice(value) =>
      value == null ? 'This field cannot be blank.' : null;

  String validateField(value) =>
      value.isEmpty ? 'This field cannot be blank.' : null;

  void submitForm(BuildContext context) async {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formKey.currentState.save();

      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Saving...')));

      try {
        DatabaseManager.getInstance().insertRow(journalEntry);
      } catch (err) {
        print(err);
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('An error has occurred')));
      } finally {
        // go to My Journal screen after 1 second
        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  List<DropdownMenuItem> dropDownItems(int length) {
    return List.generate(length, (i) {
      return DropdownMenuItem<int>(child: Text('${i + 1}'), value: i + 1);
    });
  }
}
