import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController {
static Future<Database> getDatabaseUser() async {
  return openDatabase(
    join(await getDatabasesPath(), 'user_db.db'),
    onCreate: (db, version)
    {
      return db.execute(
          "CREATE TABLE users(name TEXT PRIMARY KEY, password TEXT)"
      );
    },
    version: 1,
  );
}
static Future<Database> getDatabaseTask() async {
  return openDatabase(
    join(await getDatabasesPath(), 'task_db.db'),
    onCreate: (db, version)
    {
      return db.execute(
          "CREATE TABLE tasks(task_name TEXT PRIMARY KEY, checked TEXT)"
      );
    },
    version: 1,
  );
}
}