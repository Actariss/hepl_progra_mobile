import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController {
static Future<Database> getDatabase() async {
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
}