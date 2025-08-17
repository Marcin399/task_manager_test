import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;
  
  DatabaseHelper._internal();
  
  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }
  
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    Logger.debug('Pobieranie ścieżki bazy danych...', tag: 'Database');
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);
    Logger.debug('Ścieżka bazy danych: $path', tag: 'Database');
    
    Logger.debug('Otwieranie bazy danych...', tag: 'Database');
    final database = await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
    );
    Logger.info('Baza danych została otwarta pomyślnie', tag: 'Database');
    
    return database;
  }
  
  Future<void> _onCreate(Database db, int version) async {
    Logger.info('Tworzenie tabel bazy danych...', tag: 'Database');
    await _createTables(db);
    Logger.info('Tabele bazy danych zostały utworzone', tag: 'Database');
  }
  
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        deadline INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        reminderMinutes INTEGER,
        priority INTEGER DEFAULT 0
      )
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS task_statistics (
        id TEXT PRIMARY KEY,
        taskId TEXT NOT NULL,
        completedAt INTEGER NOT NULL,
        dayOfWeek INTEGER NOT NULL,
        FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_tasks_deadline ON tasks (deadline)
    ''');
    
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_tasks_completed ON tasks (isCompleted)
    ''');
    
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_statistics_completed_at ON task_statistics (completedAt)
    ''');
    
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_statistics_day_of_week ON task_statistics (dayOfWeek)
    ''');
  }
  
  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
  
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
