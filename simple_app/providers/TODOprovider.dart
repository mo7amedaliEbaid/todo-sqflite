import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo_model.dart';


class TODOProvider {
  static final TODOProvider instance = TODOProvider._init();
  static Database? _database;

  TODOProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('newtodos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableOftodos ( 
  ${TODOFields.id} $idType, 
  ${TODOFields.title} $textType,
  ${TODOFields.description} $textType,
  ${TODOFields.time} $textType
  )
''');
  }

  Future<TODO> create(TODO todo) async {
    final db = await instance.database;

    final id = await db.insert(tableOftodos, todo.toJson());
    return todo.copy(id: id);
  }

  Future<TODO> readTODO(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableOftodos,
      columns: TODOFields.values,
      where: '${TODOFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TODO.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<TODO>> readAllTODOs() async {
    final db = await instance.database;

    const orderBy = '${TODOFields.time} ASC';

    final result = await db.query(tableOftodos, orderBy: orderBy);

    return result.map((json) => TODO.fromJson(json)).toList();
  }

  Future<int> update(TODO todo) async {
    final db = await instance.database;

    return db.update(
      tableOftodos,
      todo.toJson(),
      where: '${TODOFields.id} = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableOftodos,
      where: '${TODOFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

}