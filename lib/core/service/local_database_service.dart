import 'package:restaurant_app/core/model/restaurants.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static const String _databaseName = "restaurant_app.db";
  static const int _databaseVersion = 1;
  static const String _tableName = "restaurant";

  Future<Database> initDatabase() async {
    return openDatabase(
      _databaseName,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await createTablesRestaurant(db);
      },
    );
  }

  Future<void> createTablesRestaurant(Database database) async {
    await database.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
    ''');
  }

  Future<int> insertRestaurant(Restaurants restaurant) async {
    final db = await initDatabase();
    final id = await db.insert(
      _tableName,
      restaurant.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Restaurants>> getAllRestaurants() async {
    final db = await initDatabase();
    final results = await db.query(_tableName);
    print("All restaurants: $results");

    return results.map((map) => Restaurants.fromJson(map)).toList();
  }

  Future<Restaurants?> getRestaurantById(String id) async {
    final db = await initDatabase();
    final results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return Restaurants.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<int> deleteRestaurant(String id) async {
    final db = await initDatabase();
    final results = await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results;
  }
}
