import 'package:injectable/injectable.dart';
import '../entities/task_entity.dart';
import '../repositories/notification_repository.dart';
import '../repositories/task_repository.dart';
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';

@injectable
class NotificationUseCases {
  final NotificationRepository _notificationRepository;
  final TaskRepository _taskRepository;
  
  NotificationUseCases(this._notificationRepository, this._taskRepository);
  
  Future<Result<void>> initializeNotifications() async {
    final initResult = await _notificationRepository.initialize();
    
    if (initResult.isFailure) {
      return initResult;
    }
    
    final permissionResult = await _notificationRepository.requestPermissions();
    
    if (permissionResult.isFailure) {
      Logger.warning('Żądanie uprawnień nie powiodło się: ${permissionResult.failure}', tag: 'Notifications');
    }
    
    final hasPermissions = permissionResult.isSuccess && permissionResult.data!;
    
    if (hasPermissions) {
      final tasksResult = await _taskRepository.getTasksByStatus(false);
      if (tasksResult.isSuccess) {
        await _notificationRepository.rescheduleAllReminders(tasksResult.data!);
      }
    }
    
    return const Result.success(null);
  }
  
  Future<Result<bool>> checkNotificationPermissions() async {
    return await _notificationRepository.checkPermissions();
  }
  
  Future<Result<bool>> requestNotificationPermissions() async {
    return await _notificationRepository.requestPermissions();
  }

  Future<Result<bool>> openAppSettings() async {
    return await _notificationRepository.openAppSettings();
  }
  
  Future<Result<void>> scheduleTaskReminder(TaskEntity task) async {
    if (task.isCompleted) {
      return const Result.failure(
        ValidationFailure('Nie można ustawić przypomnienia dla ukończonego zadania')
      );
    }
    
    if (task.deadline.isBefore(DateTime.now())) {
      return const Result.failure(
        ValidationFailure('Nie można ustawić przypomnienia dla przeterminowanego zadania')
      );
    }
    
    final reminderTime = task.reminderTime;
    if (reminderTime != null && reminderTime.isBefore(DateTime.now())) {
      return const Result.failure(
        ValidationFailure('Czas przypomnienia jest w przeszłości')
      );
    }
    
    return await _notificationRepository.scheduleTaskReminder(task);
  }
  
  Future<Result<void>> cancelTaskReminder(String taskId) async {
    return await _notificationRepository.cancelTaskReminder(taskId);
  }
  
  Future<Result<void>> updateTaskReminder(
    String taskId, 
    int? reminderMinutes
  ) async {
    final taskResult = await _taskRepository.getTaskById(taskId);
    
    return taskResult.flatMapAsync((task) async {
      if (task == null) {
        return const Result.failure(NotFoundFailure('Zadanie nie zostało znalezione'));
      }
      
      await _notificationRepository.cancelTaskReminder(taskId);
      
      if (reminderMinutes != null) {
        final updatedTask = task.updateReminder(reminderMinutes);
        
        final updateResult = await _taskRepository.updateTask(updatedTask);
        
        if (updateResult.isFailure) {
          return updateResult;
        }
        
        return await _notificationRepository.scheduleTaskReminder(updatedTask);
      } else {
        final updatedTask = task.updateReminder(null);
        return await _taskRepository.updateTask(updatedTask);
      }
    });
  }
  
  Future<Result<void>> setDefaultReminderTime(int minutes) async {
    if (minutes < 0) {
      return const Result.failure(
        ValidationFailure('Czas przypomnienia nie może być ujemny')
      );
    }
    
    return await _notificationRepository.updateDefaultReminderTime(minutes);
  }
  
  Future<Result<int>> getDefaultReminderTime() async {
    final result = await _notificationRepository.getDefaultReminderTime();
    
    return result.when(
      success: (time) => Result.success(time),
      failure: (_) => const Result.success(AppConstants.defaultReminderMinutes),
    );
  }
  
  Future<Result<void>> enableNotifications() async {
    final permissionResult = await _notificationRepository.checkPermissions();
    
    return permissionResult.flatMapAsync((hasPermission) async {
      if (!hasPermission) {
        final requestResult = await _notificationRepository.requestPermissions();
        if (requestResult.isFailure) {
          return Result.failure(requestResult.failure!);
        }
        
        if (!requestResult.data!) {
          return const Result.failure(
            ValidationFailure('Brak uprawnień do powiadomień')
          );
        }
        return await _notificationRepository.enableNotifications();
      } else {
        return await _notificationRepository.enableNotifications();
      }
    });
  }
  
  Future<Result<void>> disableNotifications() async {
    final disableResult = await _notificationRepository.disableNotifications();
    
    if (disableResult.isFailure) {
      return disableResult;
    }
    
    return await _notificationRepository.cancelAllReminders();
  }
  
  Future<Result<bool>> areNotificationsEnabled() async {
    return await _notificationRepository.areNotificationsEnabled();
  }
  
  Future<Result<void>> rescheduleAllReminders() async {
    final tasksResult = await _taskRepository.getTasksByStatus(false);
    
    if (tasksResult.isFailure) {
      return Result.failure(tasksResult.failure!);
    }
    
    final tasksWithReminders = tasksResult.data!.where((task) => task.hasReminder).toList();
    return await _notificationRepository.rescheduleAllReminders(tasksWithReminders);
  }
  
  Future<Result<List<String>>> getPendingNotifications() async {
    return await _notificationRepository.getPendingNotifications();
  }
  
  Future<Result<void>> clearAllNotifications() async {
    return await _notificationRepository.cancelAllReminders();
  }
}
