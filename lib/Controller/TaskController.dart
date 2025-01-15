import 'package:hepl_progra_mobile/Controller/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

class TaskController {
  static Future<void> insertTask(String taskName, bool checkboxState) async {
    final db = await DatabaseController.getDatabaseTask();
    await db.insert("tasks", {"task_name" : taskName, "checked" : checkboxState.toString()}, conflictAlgorithm: ConflictAlgorithm.replace);
}
static Future<bool?> getTaskState(String taskName) async{
    final db = await DatabaseController.getDatabaseTask();
    final List<Map<String, Object?>> taskList = await db.query(
        "tasks",
        where: "task_name = ?",
        whereArgs: [taskName]);
    if (taskList.isNotEmpty){
  if (taskList[0]["checked"] != null){
    return taskList[0]["checked"].toString().toLowerCase() == "true";
  }
  }
    return false;
}
  static Future<List<Map<String, Object?>>> getTasks() async{
    final db = await DatabaseController.getDatabaseTask();
    final List<Map<String, Object?>> taskList = await db.query("tasks");
    if (taskList.isNotEmpty){
        return taskList;
      }
    else {return [];}
    }
static Future<void> setTaskState(String taskName, bool taskState) async{
  final db = await DatabaseController.getDatabaseTask();
  await db.update(
    "tasks",
      {"checked":taskState.toString()},
    where: "task_name = ?",
      whereArgs: [taskName]
  );
}
}
