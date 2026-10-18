import '../models/user.dart';
import '../utils/database_helper.dart';

class UserController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> isEmailExist(String email) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty;
  }

  Future<bool> register(User user) async {
    if (await isEmailExist(user.email)) return false;
    final db = await _dbHelper.database;
    await db.insert('users', user.toMap());
    return true;
  }

  Future<User?> login(String email, String password) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }
}
