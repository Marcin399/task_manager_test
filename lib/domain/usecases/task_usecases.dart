import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';
import '../entities/task_entity.dart';
import '../entities/task_statistics_entity.dart';
import '../repositories/task_repository.dart';
import '../repositories/notification_repository.dart';
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart';

@injectable
class TaskUseCases {
  final TaskRepository _taskRepository;
  final NotificationRepository _notificationRepository;
  final Uuid _uuid = const Uuid();
  
  TaskUseCases(this._taskRepository, this._notificationRepository);
  
  Future<Result<TaskEntity>> createTask({
    required String title,
    String? description,
    required DateTime deadline,
    int? reminderMinutes,
    TaskPriority priority = TaskPriority.medium,
  }) async {
    if (title.trim().isEmpty) {
      return const Result.failure(ValidationFailure('Tytuł zadania jest wymagany'));
    }
    
    if (deadline.isBefore(DateTime.now())) {
      return const Result.failure(ValidationFailure('Termin wykonania nie może być w przeszłości'));
    }
    
    final task = TaskEntity(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      deadline: deadline,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      reminderMinutes: reminderMinutes,
      priority: priority,
    );
    
    final createResult = await _taskRepository.createTask(task);
    
    return createResult.when(
      success: (_) async {
        if (task.hasReminder) {
          await _notificationRepository.scheduleTaskReminder(task);
        }
        return Result.success(task);
      },
      failure: (failure) => Result.failure(failure),
    );
  }
  
  Future<Result<List<TaskEntity>>> getAllTasks() async {
    return await _taskRepository.getAllTasks();
  }
  
  Future<Result<List<TaskEntity>>> getTasksByStatus(bool isCompleted) async {
    return await _taskRepository.getTasksByStatus(isCompleted);
  }
  
  Future<Result<List<TaskEntity>>> getActiveTasks() async {
    final result = await _taskRepository.getTasksByStatus(false);
    
    return result.transform((tasks) {
      final sortedTasks = List<TaskEntity>.from(tasks);
      sortedTasks.sort((a, b) => a.deadline.compareTo(b.deadline));
      return sortedTasks;
    });
  }
  
  Future<Result<List<TaskEntity>>> getCompletedTasks() async {
    return await _taskRepository.getTasksByStatus(true);
  }
  
  Future<Result<void>> updateTask(TaskEntity task) async {
    if (task.title.trim().isEmpty) {
      return const Result.failure(ValidationFailure('Tytuł zadania jest wymagany'));
    }
    
    final updatedTask = task.copyWith(
      title: task.title.trim(),
      description: task.description?.trim(),
      updatedAt: DateTime.now(),
    );
    
    final updateResult = await _taskRepository.updateTask(updatedTask);
    
    return updateResult.when(
      success: (_) async {
        await _notificationRepository.cancelTaskReminder(task.id);
        if (updatedTask.hasReminder && !updatedTask.isCompleted) {
          await _notificationRepository.scheduleTaskReminder(updatedTask);
        }
        return const Result.success(null);
      },
      failure: (failure) => Result.failure(failure),
    );
  }
  
  Future<Result<void>> markTaskAsCompleted(String taskId) async {
    final taskResult = await _taskRepository.getTaskById(taskId);
    
    return taskResult.flatMapAsync((task) async {
      if (task == null) {
        return const Result.failure(NotFoundFailure('Zadanie nie zostało znalezione'));
      }
      
      if (task.isCompleted) {
        return const Result.failure(ValidationFailure('Zadanie jest już ukończone'));
      }
      
      final updateResult = await _taskRepository.markTaskAsCompleted(taskId);
      
      if (updateResult.isFailure) {
        return updateResult;
      }
      
      await _notificationRepository.cancelTaskReminder(taskId);
      return const Result.success(null);
    });
  }
  
  Future<Result<void>> markTaskAsIncomplete(String taskId) async {
    final taskResult = await _taskRepository.getTaskById(taskId);
    
    return taskResult.flatMapAsync((task) async {
      if (task == null) {
        return const Result.failure(NotFoundFailure('Zadanie nie zostało znalezione'));
      }
      
      if (!task.isCompleted) {
        return const Result.failure(ValidationFailure('Zadanie nie jest ukończone'));
      }
      
      final updateResult = await _taskRepository.markTaskAsIncomplete(taskId);
      
      if (updateResult.isFailure) {
        return updateResult;
      }
      
      if (task.hasReminder) {
        await _notificationRepository.scheduleTaskReminder(task);
      }
      return const Result.success(null);
    });
  }
  
  Future<Result<void>> deleteTask(String taskId) async {
    final deleteResult = await _taskRepository.deleteTask(taskId);
    
    return deleteResult.when(
      success: (_) async {
        // Cancel reminder notification
        await _notificationRepository.cancelTaskReminder(taskId);
        return const Result.success(null);
      },
      failure: (failure) => Result.failure(failure),
    );
  }
  
  Future<Result<List<TaskEntity>>> searchTasks(String query) async {
    if (query.trim().isEmpty) {
      return const Result.success([]);
    }
    
    return await _taskRepository.searchTasks(query.trim());
  }
  
  Future<Result<List<TaskEntity>>> getOverdueTasks() async {
    return await _taskRepository.getOverdueTasks();
  }

  Future<Result<List<TaskEntity>>> getTasksDueToday() async {
    return await _taskRepository.getTasksDueToday();
  }
  
  Future<Result<List<TaskEntity>>> getTasksDueTomorrow() async {
    return await _taskRepository.getTasksDueTomorrow();
  }
  
  Future<Result<List<TaskEntity>>> getTasksByPriority(TaskPriority priority) async {
    return await _taskRepository.getTasksByPriority(priority);
  }
  
  Future<Result<TaskStatisticsEntity>> getTaskStatistics() async {
    return await _taskRepository.getTaskStatistics();
  }
  
  Future<Result<List<ProductivityTrend>>> getProductivityTrend({
    int days = 30,
  }) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    
    return await _taskRepository.getProductivityTrend(startDate, endDate);
  }
  
  Future<Result<void>> deleteCompletedTasks() async {
    return await _taskRepository.deleteCompletedTasks();
  }
  
  Future<Result<void>> bulkUpdateTasks(List<TaskEntity> tasks) async {
    return await _taskRepository.bulkUpdateTasks(tasks);
  }
}
