import 'package:sqflite/sqflite.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

const SQL_PATH = 'assets/schema_1.sql.txt';

class DatabaseManager {
  static const DATABASE_FILENAME = 'journal.sqlite3.db';
  // static const CREATE_SCHEMA =
  // 'CREATE TABLE IF NOT EXISTS journal_entries(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, body TEXT, rating INTEGER, date TEXT)';
  static const String TABLE_NAME = 'journal_entries';

  static DatabaseManager _instance;
  final Database db;
  // final String tableName;
  DatabaseManager._({
    Database database,
  }) : db = database;

  factory DatabaseManager.getInstance() {
    if (_instance == null) {
      initialize();
    }
    // assert(_instance != null);
    return _instance;
  }

  static Future initialize() async {
    String cREATE_SCHEMA = await rootBundle.loadString(SQL_PATH);
    // create database
    final db = await openDatabase(DATABASE_FILENAME, version: 1,
        onCreate: (Database db, int version) {
      createTables(db, cREATE_SCHEMA);
    });
    // assign database object to instance
    _instance = DatabaseManager._(database: db);
  }

  static void createTables(Database db, String query) async {
    await db.execute(query);
  }

  void insertRow(JournalEntry journal) async {
    await db.insert(
      TABLE_NAME,
      journal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    // query table for all journal entries, returns List of Objects
    final List<Map<String, dynamic>> journalRecords =
        await db.query(TABLE_NAME);

    if (journalRecords.isEmpty) return null;
    // convert query List into List<JournalEntry>
    return List.generate(journalRecords.length, (i) {
      return JournalEntry.fromJSON(journalRecords[i]);
    });
  }

  void deleteRow(id) async {
    await db.delete(TABLE_NAME, where: "id=?", whereArgs: [id]);
  }

  Future<JournalEntry> getEntryById(int id) async {
    final List<Map<String, dynamic>> entry =
        await db.query(TABLE_NAME, where: 'id=?', whereArgs: [id]);

    return JournalEntry.fromJSON(entry[0]);
  }
}

// DatabaseManager singleton = DatabaseManager.getInstance();
