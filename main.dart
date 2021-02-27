// Created by Danny Tran
import 'package:flutter/material.dart';
import 'package:journal/app.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db/database.dart';
import 'models/journal_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  await DatabaseManager.initialize();

  runApp(MyApp(
      appName: 'My Journal',
      preferences: await SharedPreferences.getInstance()));
}
