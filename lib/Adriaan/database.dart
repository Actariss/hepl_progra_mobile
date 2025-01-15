import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class User {
  final String username;
  final String password;

  const User({
    required this.username,
    required this.password,
  });
  Map<String, Object?> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User{username: $username, password: $password}';
  }
}

Future<Database> getDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  return openDatabase(
    join(await getDatabasesPath(), 'user_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE users(username TEXT PRIMARY KEY, password TEXT)',
      );
    },
    version: 1,
  );
}

Future<void> insertUser(User user) async {
  final db = await getDatabase();

  await db.insert(
    'users',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace, // prevent duplicates
  );
}

Future<bool> checkUser(String username, String password) async {
  final db = await getDatabase();

  final List<Map<String, dynamic>> maps = await db.query(
    'users',
    where: 'username = ? AND password = ?',
    whereArgs: [username, password],
  );
  // If a user is found, return it as a User object
 return maps.isNotEmpty;
}