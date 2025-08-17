import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/repositories/notification_repository.dart';
import 'package:task_manager/core/utils/result.dart';
import 'package:task_manager/core/errors/failures.dart';

/// Enhanced Mock implementation of NotificationRepository for testing
class MockNotificationRepository implements NotificationRepository {
  bool _isInitialized = false;
  bool _hasPermissions = true;
  bool _notificationsEnabled = true;
  int _defaultReminderTime = 60; // minutes
  final Set<String> _scheduledReminders = <String>{};
  final List<String> _pendingNotifications = [];
  bool _shouldFailOnNextOperation = false;
  Failure? _nextFailure;

  // Test control methods
  void setShouldFail(bool shouldFail, [Failure? failure]) {
    _shouldFailOnNextOperation = shouldFail;
    _nextFailure = failure ?? const UnexpectedFailure('Mock notification failure');
  }

  void setPermissions(bool hasPermissions) {
    _hasPermissions = hasPermissions;
  }

  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
  }

  void addPendingNotification(String taskId) {
    _pendingNotifications.add(taskId);
  }

  void clearPendingNotifications() {
    _pendingNotifications.clear();
  }

  void reset() {
    _isInitialized = false;
    _hasPermissions = true;
    _notificationsEnabled = true;
    _defaultReminderTime = 60;
    _scheduledReminders.clear();
    _pendingNotifications.clear();
    _shouldFailOnNextOperation = false;
    _nextFailure = null;
  }

  Result<T>? _checkForFailure<T>() {
    if (_shouldFailOnNextOperation) {
      _shouldFailOnNextOperation = false; // Reset after use
      return Result.failure(_nextFailure ?? const UnexpectedFailure('Mock notification failure'));
    }
    return null; // No failure, continue with normal operation
  }

  @override
  Future<Result<void>> initialize() async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    _isInitialized = true;
    return const Result.success(null);
  }
  
  @override
  Future<Result<bool>> requestPermissions() async {
    final failureCheck = _checkForFailure<bool>();
    if (failureCheck != null) return failureCheck;
    
    // Simulate user interaction - sometimes they might deny
    return Result.success(_hasPermissions);
  }
  
  @override
  Future<Result<bool>> checkPermissions() async {
    final failureCheck = _checkForFailure<bool>();
    if (failureCheck != null) return failureCheck;
    
    return Result.success(_hasPermissions);
  }
  
  @override
  Future<Result<bool>> openAppSettings() async {
    final failureCheck = _checkForFailure<bool>();
    if (failureCheck != null) return failureCheck;
    
    return const Result.success(true);
  }
  
  @override
  Future<Result<void>> scheduleTaskReminder(TaskEntity task) async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    if (!_isInitialized) {
      return const Result.failure(UnexpectedFailure('Notifications not initialized'));
    }
    
    if (!_hasPermissions) {
      return const Result.failure(UnauthorizedFailure('No notification permissions'));
    }
    
    if (!_notificationsEnabled) {
      return const Result.failure(ValidationFailure('Notifications are disabled'));
    }
    
    if (task.isCompleted) {
      return const Result.failure(ValidationFailure('Cannot schedule reminder for completed task'));
    }
    
    if (task.reminderTime != null && task.reminderTime!.isBefore(DateTime.now())) {
      return const Result.failure(ValidationFailure('Reminder time is in the past'));
    }
    
    _scheduledReminders.add(task.id);
    _pendingNotifications.add(task.id);
    return const Result.success(null);
  }
  
  @override
  Future<Result<void>> cancelTaskReminder(String taskId) async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    _scheduledReminders.remove(taskId);
    _pendingNotifications.remove(taskId);
    return const Result.success(null);
  }
  
  @override
  Future<Result<void>> cancelAllReminders() async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    _scheduledReminders.clear();
    _pendingNotifications.clear();
    return const Result.success(null);
  }
  
  @override
  Future<Result<void>> updateDefaultReminderTime(int minutes) async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    if (minutes < 0) {
      return const Result.failure(ValidationFailure('Reminder time cannot be negative'));
    }
    
    _defaultReminderTime = minutes;
    return const Result.success(null);
  }
  
  @override
  Future<Result<int>> getDefaultReminderTime() async {
    final failureCheck = _checkForFailure<int>();
    if (failureCheck != null) return failureCheck;
    
    return Result.success(_defaultReminderTime);
  }
  
  @override
  Future<Result<void>> rescheduleAllReminders(List<TaskEntity> tasks) async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    if (!_hasPermissions || !_notificationsEnabled) {
      return const Result.success(null); // Silent fail if no permissions
    }
    
    _scheduledReminders.clear();
    _pendingNotifications.clear();
    
    for (final task in tasks) {
      if (!task.isCompleted && task.hasReminder) {
        _scheduledReminders.add(task.id);
        _pendingNotifications.add(task.id);
      }
    }
    
    return const Result.success(null);
  }
  
  @override
  Future<Result<List<String>>> getPendingNotifications() async {
    final failureCheck = _checkForFailure<List<String>>();
    if (failureCheck != null) return failureCheck;
    
    return Result.success(List.from(_pendingNotifications));
  }
  
  @override
  Future<Result<void>> enableNotifications() async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    if (!_hasPermissions) {
      return const Result.failure(UnauthorizedFailure('No notification permissions'));
    }
    
    _notificationsEnabled = true;
    return const Result.success(null);
  }
  
  @override
  Future<Result<void>> disableNotifications() async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    _notificationsEnabled = false;
    // Cancel all reminders when disabling
    _scheduledReminders.clear();
    _pendingNotifications.clear();
    return const Result.success(null);
  }
  
  @override
  Future<Result<bool>> areNotificationsEnabled() async {
    final failureCheck = _checkForFailure<bool>();
    if (failureCheck != null) return failureCheck;
    
    return Result.success(_notificationsEnabled && _hasPermissions);
  }
}
