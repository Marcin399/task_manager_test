import '../entities/task_entity.dart';
import '../../core/utils/result.dart';

abstract class NotificationRepository {
  // Initialize notifications
  Future<Result<void>> initialize();
  
  // Permission management
  Future<Result<bool>> requestPermissions();
  Future<Result<bool>> checkPermissions();
  Future<Result<bool>> openAppSettings();
  
  // Schedule notifications
  Future<Result<void>> scheduleTaskReminder(TaskEntity task);
  Future<Result<void>> cancelTaskReminder(String taskId);
  Future<Result<void>> cancelAllReminders();
  
  // Update reminder settings
  Future<Result<void>> updateDefaultReminderTime(int minutes);
  Future<Result<int>> getDefaultReminderTime();
  
  // Notification history and management
  Future<Result<void>> rescheduleAllReminders(List<TaskEntity> tasks);
  Future<Result<List<String>>> getPendingNotifications();
  
  // Settings
  Future<Result<void>> enableNotifications();
  Future<Result<void>> disableNotifications();
  Future<Result<bool>> areNotificationsEnabled();
}
