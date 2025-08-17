import 'package:injectable/injectable.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_statistics_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;
  
  TaskRepositoryImpl(this._localDataSource);
  
  @override
  Future<Result<List<TaskEntity>>> getAllTasks() async {
    try {
      final tasks = await _localDataSource.getAllTasks();
      return Result.success(tasks.map((task) => task.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<TaskEntity?>> getTaskById(String id) async {
    try {
      final task = await _localDataSource.getTaskById(id);
      return Result.success(task?.toEntity());
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<String>> createTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final taskId = await _localDataSource.createTask(taskModel);
      return Result.success(taskId);
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> updateTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await _localDataSource.updateTask(taskModel);
      return const Result.success(null);
    } on NotFoundException catch (e) {
      return Result.failure(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> deleteTask(String id) async {
    try {
      await _localDataSource.deleteTask(id);
      return const Result.success(null);
    } on NotFoundException catch (e) {
      return Result.failure(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<List<TaskEntity>>> getTasksByStatus(bool isCompleted) async {
    try {
      final tasks = await _localDataSource.getTasksByStatus(isCompleted);
      return Result.success(tasks.map((task) => task.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<List<TaskEntity>>> getTasksByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final tasks = await _localDataSource.getTasksByDateRange(
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      );
      return Result.success(tasks.map((task) => task.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<List<TaskEntity>>> getOverdueTasks() async {
    try {
      final tasks = await _localDataSource.getOverdueTasks();
      return Result.success(tasks.map((task) => task.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<List<TaskEntity>>> getTasksDueToday() async {
    try {
      final tasks = await _localDataSource.getTasksDueToday();
      return Result.success(tasks.map((task) => task.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<List<TaskEntity>>> getTasksDueTomorrow() async {
    try {
      final tasks = await _localDataSource.getTasksDueTomorrow();
      return Result.success(tasks.map((task) => task.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<List<TaskEntity>>> getTasksByPriority(TaskPriority priority) async {
    try {
      final tasks = await _localDataSource.getTasksByPriority(priority.value);
      return Result.success(tasks.map((task) => task.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<List<TaskEntity>>> searchTasks(String query) async {
    try {
      final tasks = await _localDataSource.searchTasks(query);
      return Result.success(tasks.map((task) => task.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> markTaskAsCompleted(String id) async {
    try {
      await _localDataSource.markTaskAsCompleted(id);
      return const Result.success(null);
    } on NotFoundException catch (e) {
      return Result.failure(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> markTaskAsIncomplete(String id) async {
    try {
      await _localDataSource.markTaskAsIncomplete(id);
      return const Result.success(null);
    } on NotFoundException catch (e) {
      return Result.failure(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> deleteCompletedTasks() async {
    try {
      await _localDataSource.deleteCompletedTasks();
      return const Result.success(null);
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> bulkUpdateTasks(List<TaskEntity> tasks) async {
    try {
      final taskModels = tasks.map((task) => TaskModel.fromEntity(task)).toList();
      await _localDataSource.bulkUpdateTasks(taskModels);
      return const Result.success(null);
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<TaskStatisticsEntity>> getTaskStatistics() async {
    try {
      final statistics = await _localDataSource.getTaskStatistics();
      
      final entity = TaskStatisticsEntity(
        completedTasksToday: statistics['completedTasksToday'] as int,
        completedTasksThisWeek: statistics['completedTasksThisWeek'] as int,
        completedTasksThisMonth: statistics['completedTasksThisMonth'] as int,
        totalTasks: statistics['totalTasks'] as int,
        completedTasks: statistics['completedTasks'] as int,
        pendingTasks: statistics['pendingTasks'] as int,
        overdueTasks: statistics['overdueTasks'] as int,
        completedTasksByDay: Map<int, int>.from(statistics['completedTasksByDay'] as Map),
        completionRate: (statistics['completionRate'] as num).toDouble(),
        mostProductiveDayOfWeek: statistics['mostProductiveDayOfWeek'] as int,
      );
      
      return Result.success(entity);
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<List<ProductivityTrend>>> getProductivityTrend(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final trends = await _localDataSource.getProductivityTrend(
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      );
      
      final entities = trends.map((trend) {
        final dateStr = trend['date'] as String;
        final date = DateTime.parse(dateStr);
        return ProductivityTrend(
          date: date,
          completedTasks: trend['completedTasks'] as int,
          totalTasks: trend['completedTasks'] as int, // For now, assuming completed = total for that day
        );
      }).toList();
      
      return Result.success(entities);
    } on DatabaseException catch (e) {
      return Result.failure(DatabaseFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
}
