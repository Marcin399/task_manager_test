import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';
import '../../core/storage/database_helper.dart';
import '../../core/errors/exceptions.dart' as app_exceptions;

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<TaskModel?> getTaskById(String id);
  Future<String> createTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<List<TaskModel>> getTasksByStatus(bool isCompleted);
  Future<List<TaskModel>> getTasksByDateRange(int startDate, int endDate);
  Future<List<TaskModel>> getOverdueTasks();
  Future<List<TaskModel>> getTasksDueToday();
  Future<List<TaskModel>> getTasksDueTomorrow();
  Future<List<TaskModel>> getTasksByPriority(int priority);
  Future<List<TaskModel>> searchTasks(String query);
  Future<void> markTaskAsCompleted(String id);
  Future<void> markTaskAsIncomplete(String id);
  Future<void> deleteCompletedTasks();
  Future<void> bulkUpdateTasks(List<TaskModel> tasks);
  Future<Map<String, dynamic>> getTaskStatistics();
  Future<List<Map<String, dynamic>>> getProductivityTrend(int startDate, int endDate);
}

@LazySingleton(as: TaskLocalDataSource)
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper _databaseHelper;
  
  TaskLocalDataSourceImpl(this._databaseHelper);
  
  Future<Database> get _database async => await _databaseHelper.database;
  
  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        orderBy: 'deadline ASC',
      );
      
      return maps.map((map) => TaskModel.fromDatabase(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas pobierania zadań: ${e.toString()}');
    }
  }
  
  @override
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      
      if (maps.isEmpty) return null;
      return TaskModel.fromDatabase(maps.first);
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas pobierania zadania: ${e.toString()}');
    }
  }
  
  @override
  Future<String> createTask(TaskModel task) async {
    try {
      final db = await _database;
      await db.insert(
        'tasks',
        task.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return task.id;
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas tworzenia zadania: ${e.toString()}');
    }
  }
  
  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      final db = await _database;
      final count = await db.update(
        'tasks',
        task.toDatabase(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      
      if (count == 0) {
        throw const app_exceptions.NotFoundException('Zadanie nie zostało znalezione');
      }
    } catch (e) {
      if (e is app_exceptions.NotFoundException) rethrow;
      throw app_exceptions.DatabaseException('Błąd podczas aktualizacji zadania: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteTask(String id) async {
    try {
      final db = await _database;
      final count = await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (count == 0) {
        throw const app_exceptions.NotFoundException('Zadanie nie zostało znalezione');
      }
    } catch (e) {
      if (e is app_exceptions.NotFoundException) rethrow;
      throw app_exceptions.DatabaseException('Błąd podczas usuwania zadania: ${e.toString()}');
    }
  }
  
  @override
  Future<List<TaskModel>> getTasksByStatus(bool isCompleted) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'isCompleted = ?',
        whereArgs: [isCompleted ? 1 : 0],
        orderBy: isCompleted ? 'updatedAt DESC' : 'deadline ASC',
      );
      
      return maps.map((map) => TaskModel.fromDatabase(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas pobierania zadań: ${e.toString()}');
    }
  }
  
  @override
  Future<List<TaskModel>> getTasksByDateRange(int startDate, int endDate) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'deadline >= ? AND deadline <= ?',
        whereArgs: [startDate, endDate],
        orderBy: 'deadline ASC',
      );
      
      return maps.map((map) => TaskModel.fromDatabase(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas pobierania zadań: ${e.toString()}');
    }
  }
  
  @override
  Future<List<TaskModel>> getOverdueTasks() async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'deadline < ? AND isCompleted = 0',
        whereArgs: [now],
        orderBy: 'deadline ASC',
      );
      
      return maps.map((map) => TaskModel.fromDatabase(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas pobierania przeterminowanych zadań: ${e.toString()}');
    }
  }
  
  @override
  Future<List<TaskModel>> getTasksDueToday() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).millisecondsSinceEpoch;
      
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'deadline >= ? AND deadline <= ?',
        whereArgs: [startOfDay, endOfDay],
        orderBy: 'deadline ASC',
      );
      
      return maps.map((map) => TaskModel.fromDatabase(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas pobierania dzisiejszych zadań: ${e.toString()}');
    }
  }
  
  @override
  Future<List<TaskModel>> getTasksDueTomorrow() async {
    try {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final startOfDay = DateTime(tomorrow.year, tomorrow.month, tomorrow.day).millisecondsSinceEpoch;
      final endOfDay = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59, 59).millisecondsSinceEpoch;
      
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'deadline >= ? AND deadline <= ?',
        whereArgs: [startOfDay, endOfDay],
        orderBy: 'deadline ASC',
      );
      
      return maps.map((map) => TaskModel.fromDatabase(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas pobierania jutrzejszych zadań: ${e.toString()}');
    }
  }
  
  @override
  Future<List<TaskModel>> getTasksByPriority(int priority) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'priority = ?',
        whereArgs: [priority],
        orderBy: 'deadline ASC',
      );
      
      return maps.map((map) => TaskModel.fromDatabase(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas pobierania zadań według priorytetu: ${e.toString()}');
    }
  }
  
  @override
  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      final db = await _database;
      final searchQuery = '%$query%';
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: [searchQuery, searchQuery],
        orderBy: 'deadline ASC',
      );
      
      return maps.map((map) => TaskModel.fromDatabase(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas wyszukiwania zadań: ${e.toString()}');
    }
  }
  
  @override
  Future<void> markTaskAsCompleted(String id) async {
    try {
      final db = await _database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final count = await db.update(
        'tasks',
        {
          'isCompleted': 1,
          'updatedAt': now,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (count == 0) {
        throw const app_exceptions.NotFoundException('Zadanie nie zostało znalezione');
      }
      
      // Add to statistics
      final task = await getTaskById(id);
      if (task != null) {
        final completedAt = DateTime.now();
        await db.insert(
          'task_statistics',
          {
            'id': '${id}_${completedAt.millisecondsSinceEpoch}',
            'taskId': id,
            'completedAt': completedAt.millisecondsSinceEpoch,
            'dayOfWeek': completedAt.weekday,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      if (e is app_exceptions.NotFoundException) rethrow;
      throw app_exceptions.DatabaseException('Błąd podczas oznaczania zadania jako ukończone: ${e.toString()}');
    }
  }
  
  @override
  Future<void> markTaskAsIncomplete(String id) async {
    try {
      final db = await _database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final count = await db.update(
        'tasks',
        {
          'isCompleted': 0,
          'updatedAt': now,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (count == 0) {
        throw const app_exceptions.NotFoundException('Zadanie nie zostało znalezione');
      }
      
      // Remove from statistics
      await db.delete(
        'task_statistics',
        where: 'taskId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      if (e is app_exceptions.NotFoundException) rethrow;
      throw app_exceptions.DatabaseException('Błąd podczas oznaczania zadania jako nieukończone: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteCompletedTasks() async {
    try {
      final db = await _database;
      await db.delete(
        'tasks',
        where: 'isCompleted = 1',
      );
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas usuwania ukończonych zadań: ${e.toString()}');
    }
  }
  
  @override
  Future<void> bulkUpdateTasks(List<TaskModel> tasks) async {
    try {
      final db = await _database;
      final batch = db.batch();
      
      for (final task in tasks) {
        batch.update(
          'tasks',
          task.toDatabase(),
          where: 'id = ?',
          whereArgs: [task.id],
        );
      }
      
      await batch.commit(noResult: true);
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas aktualizacji zadań: ${e.toString()}');
    }
  }
  
  @override
  Future<Map<String, dynamic>> getTaskStatistics() async {
    try {
      final db = await _database;
      final now = DateTime.now();
      
      // Today's statistics
      final startOfToday = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59).millisecondsSinceEpoch;
      
      // This week's statistics
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeekTimestamp = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day).millisecondsSinceEpoch;
      
      // This month's statistics
      final startOfMonth = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
      
      final totalTasks = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM tasks')) ?? 0;
      final completedTasks = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM tasks WHERE isCompleted = 1')) ?? 0;
      final pendingTasks = totalTasks - completedTasks;
      
      final completedToday = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM task_statistics WHERE completedAt >= ? AND completedAt <= ?',
        [startOfToday, endOfToday]
      )) ?? 0;
      
      final completedThisWeek = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM task_statistics WHERE completedAt >= ?',
        [startOfWeekTimestamp]
      )) ?? 0;
      
      final completedThisMonth = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM task_statistics WHERE completedAt >= ?',
        [startOfMonth]
      )) ?? 0;
      
      final overdueTasks = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM tasks WHERE deadline < ? AND isCompleted = 0',
        [now.millisecondsSinceEpoch]
      )) ?? 0;
      
      // Get completion by day of week
      final dayStats = await db.rawQuery('''
        SELECT dayOfWeek, COUNT(*) as count 
        FROM task_statistics 
        GROUP BY dayOfWeek
      ''');
      
      final completedByDay = <int, int>{};
      for (final stat in dayStats) {
        completedByDay[stat['dayOfWeek'] as int] = stat['count'] as int;
      }
      
      // Find most productive day
      int mostProductiveDay = 1; 
      int maxCompletions = 0;
      for (final entry in completedByDay.entries) {
        if (entry.value > maxCompletions) {
          maxCompletions = entry.value;
          mostProductiveDay = entry.key;
        }
      }
      
      final completionRate = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0;
      
      return {
        'completedTasksToday': completedToday,
        'completedTasksThisWeek': completedThisWeek,
        'completedTasksThisMonth': completedThisMonth,
        'totalTasks': totalTasks,
        'completedTasks': completedTasks,
        'pendingTasks': pendingTasks,
        'overdueTasks': overdueTasks,
        'completedTasksByDay': completedByDay,
        'completionRate': completionRate,
        'mostProductiveDayOfWeek': mostProductiveDay,
      };
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas pobierania statystyk: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getProductivityTrend(int startDate, int endDate) async {
    try {
      final db = await _database;
      
      final trends = await db.rawQuery('''
        SELECT 
          DATE(completedAt / 1000, 'unixepoch') as date,
          COUNT(*) as completedTasks
        FROM task_statistics 
        WHERE completedAt >= ? AND completedAt <= ?
        GROUP BY DATE(completedAt / 1000, 'unixepoch')
        ORDER BY date ASC
      ''', [startDate, endDate]);
      
      return trends;
    } catch (e) {
      throw app_exceptions.DatabaseException('Błąd podczas pobierania trendu produktywności: ${e.toString()}');
    }
  }
}
