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
  
  // Initialize Notification System
  Future<Result<void>> initializeNotifications() async {
    final initResult = await _notificationRepository.initialize();
    
    if (initResult.isFailure) {
      return initResult;
    }
    
    // Try to request permissions, but don't fail if user denies
    final permissionResult = await _notificationRepository.requestPermissions();
    
    if (permissionResult.isFailure) {
      // Log the error but continue initialization
      Logger.warning('Żądanie uprawnień nie powiodło się: ${permissionResult.failure}', tag: 'Notifications');
    }
    
    final hasPermissions = permissionResult.isSuccess && permissionResult.data!;
    
    if (hasPermissions) {
      // Only reschedule if we have permissions
      final tasksResult = await _taskRepository.getTasksByStatus(false);
      if (tasksResult.isSuccess) {
        await _notificationRepository.rescheduleAllReminders(tasksResult.data!);
      }
    }
    
    // Always return success - permissions can be granted later
    return const Result.success(null);
  }
  
  // Check and Request Permissions
  Future<Result<bool>> checkNotificationPermissions() async {
    return await _notificationRepository.checkPermissions();
  }
  
  Future<Result<bool>> requestNotificationPermissions() async {
    return await _notificationRepository.requestPermissions();
  }

  Future<Result<bool>> openAppSettings() async {
    return await _notificationRepository.openAppSettings();
  }
  
  // Schedule Task Reminder
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
  
  // Cancel Task Reminder
  Future<Result<void>> cancelTaskReminder(String taskId) async {
    return await _notificationRepository.cancelTaskReminder(taskId);
  }
  
  // Update Task Reminder
  Future<Result<void>> updateTaskReminder(
    String taskId, 
    int? reminderMinutes
  ) async {
    final taskResult = await _taskRepository.getTaskById(taskId);
    
    return taskResult.flatMapAsync((task) async {
      if (task == null) {
        return const Result.failure(NotFoundFailure('Zadanie nie zostało znalezione'));
      }
      
      // Cancel existing reminder
      await _notificationRepository.cancelTaskReminder(taskId);
      
      if (reminderMinutes != null) {
        final updatedTask = task.updateReminder(reminderMinutes);
        
        // Update task in repository
        final updateResult = await _taskRepository.updateTask(updatedTask);
        
        if (updateResult.isFailure) {
          return updateResult;
        }
        
        // Schedule new reminder
        return await _notificationRepository.scheduleTaskReminder(updatedTask);
      } else {
        // Just remove the reminder
        final updatedTask = task.updateReminder(null);
        return await _taskRepository.updateTask(updatedTask);
      }
    });
  }
  
  // Set Default Reminder Time
  Future<Result<void>> setDefaultReminderTime(int minutes) async {
    if (minutes < 0) {
      return const Result.failure(
        ValidationFailure('Czas przypomnienia nie może być ujemny')
      );
    }
    
    return await _notificationRepository.updateDefaultReminderTime(minutes);
  }
  
  // Get Default Reminder Time
  Future<Result<int>> getDefaultReminderTime() async {
    final result = await _notificationRepository.getDefaultReminderTime();
    
    return result.when(
      success: (time) => Result.success(time),
      failure: (_) => const Result.success(AppConstants.defaultReminderMinutes),
    );
  }
  
  // Enable/Disable Notifications
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
    
    // Cancel all existing reminders
    return await _notificationRepository.cancelAllReminders();
  }
  
  // Check if notifications are enabled
  Future<Result<bool>> areNotificationsEnabled() async {
    return await _notificationRepository.areNotificationsEnabled();
  }
  
  // Reschedule all reminders (useful after app update or settings change)
  Future<Result<void>> rescheduleAllReminders() async {
    final tasksResult = await _taskRepository.getTasksByStatus(false);
    
    if (tasksResult.isFailure) {
      return Result.failure(tasksResult.failure!);
    }
    
    final tasksWithReminders = tasksResult.data!.where((task) => task.hasReminder).toList();
    return await _notificationRepository.rescheduleAllReminders(tasksWithReminders);
  }
  
  // Get pending notifications
  Future<Result<List<String>>> getPendingNotifications() async {
    return await _notificationRepository.getPendingNotifications();
  }
  
  // Clear all notifications
  Future<Result<void>> clearAllNotifications() async {
    return await _notificationRepository.cancelAllReminders();
  }
}
