
import 'package:hepl_progra_mobile/Controller/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';
import '../domain/User.dart';

class UserController {
  static Future<List<Map<String, dynamic>>> getUser() async {
  final db = await DatabaseController.getDatabase();

  final List<Map<String, dynamic>> userMap = await db.query(
  'users'
  );
  return userMap;

}
  static Future<void> insertUser(String username, String password) async{
    User user = User(name: username, password: password);
    final db = await DatabaseController.getDatabase();

    await db.insert(
      "users",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}