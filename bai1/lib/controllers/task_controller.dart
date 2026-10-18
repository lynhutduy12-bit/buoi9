import 'package:bai1/models/task.dart';
import 'package:bai1/utils/database_helper.dart';

class TaskController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertTask(Task task) async {
    final db = await _dbHelper.database;
    return db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(Task task) async {
    final db = await _dbHelper.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await _dbHelper.database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isTaskExist(String title) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'tasks',
      where: 'title = ?',
      whereArgs: [title],
    );
    return maps.isNotEmpty;
  }

  Future<List<Task>> searchTasks(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<List<Task>> fetchTasks() async {
    final db = await _dbHelper.database;
    final maps = await db.query('tasks', orderBy: 'id ASC');
    return maps.map((m) => Task.fromMap(m)).toList();
  }
}
