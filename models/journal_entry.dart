import 'package:intl/intl.dart';

class JournalEntry {
  String title, body;
  String date;
  int rating, id;

  JournalEntry({
    this.id,
    this.rating = -1,
    this.title = 'null title',
    this.body = 'null body',
  }) {
    this.date = new DateFormat("EEEE, MMMM d, yyyy").format(DateTime.now());
  }

  JournalEntry.fromJSON(Map<String, dynamic> json)
      : this.id = json['id'],
        this.body = json['body'],
        this.title = json['title'],
        this.date = json['date'],
        this.rating = json['rating'];

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'body': this.body,
      'rating': this.rating,
      'date': this.date
    };
  }
}

class Journal {
  List<JournalEntry> entries;
  Journal({List<JournalEntry> entries = const <JournalEntry>[]})
      : this.entries = entries;
  int get length => entries.length;
}
