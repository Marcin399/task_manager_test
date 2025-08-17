import '../entities/task_entity.dart';
import '../entities/task_statistics_entity.dart';
import '../../core/utils/result.dart';

abstract class TaskRepository {
  // CRUD Operations
  Future<Result<List<TaskEntity>>> getAllTasks();
  Future<Result<TaskEntity?>> getTaskById(String id);
  Future<Result<String>> createTask(TaskEntity task);
  Future<Result<void>> updateTask(TaskEntity task);
  Future<Result<void>> deleteTask(String id);
  
  // Filtering and Sorting
  Future<Result<List<TaskEntity>>> getTasksByStatus(bool isCompleted);
  Future<Result<List<TaskEntity>>> getTasksByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Result<List<TaskEntity>>> getOverdueTasks();
  Future<Result<List<TaskEntity>>> getTasksDueToday();
  Future<Result<List<TaskEntity>>> getTasksDueTomorrow();
  Future<Result<List<TaskEntity>>> getTasksByPriority(TaskPriority priority);
  
  // Searching
  Future<Result<List<TaskEntity>>> searchTasks(String query);
  
  // Bulk Operations
  Future<Result<void>> markTaskAsCompleted(String id);
  Future<Result<void>> markTaskAsIncomplete(String id);
  Future<Result<void>> deleteCompletedTasks();
  Future<Result<void>> bulkUpdateTasks(List<TaskEntity> tasks);
  
  // Statistics
  Future<Result<TaskStatisticsEntity>> getTaskStatistics();
  Future<Result<List<ProductivityTrend>>> getProductivityTrend(
    DateTime startDate,
    DateTime endDate,
  );
}
