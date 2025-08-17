import 'package:injectable/injectable.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource _localDataSource;
  
  NotificationRepositoryImpl(this._localDataSource);
  
  @override
  Future<Result<void>> initialize() async {
    try {
      await _localDataSource.initialize();
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<bool>> requestPermissions() async {
    try {
      final hasPermission = await _localDataSource.requestPermissions();
      return Result.success(hasPermission);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
    @override
  Future<Result<bool>> checkPermissions() async {
    try {
      final hasPermission = await _localDataSource.checkPermissions();
      return Result.success(hasPermission);
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }

  @override
  Future<Result<bool>> openAppSettings() async {
    try {
      final result = await _localDataSource.openAppSettings();
      return Result.success(result);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> scheduleTaskReminder(TaskEntity task) async {
    try {
      await _localDataSource.scheduleTaskReminder(task);
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> cancelTaskReminder(String taskId) async {
    try {
      await _localDataSource.cancelTaskReminder(taskId);
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> cancelAllReminders() async {
    try {
      await _localDataSource.cancelAllReminders();
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> updateDefaultReminderTime(int minutes) async {
    try {
      if (minutes < 0) {
        return const Result.failure(ValidationFailure('Czas przypomnienia nie może być ujemny'));
      }
      
      await _localDataSource.updateDefaultReminderTime(minutes);
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<int>> getDefaultReminderTime() async {
    try {
      final reminderTime = await _localDataSource.getDefaultReminderTime();
      return Result.success(reminderTime);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> rescheduleAllReminders(List<TaskEntity> tasks) async {
    try {
      await _localDataSource.rescheduleAllReminders(tasks);
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<List<String>>> getPendingNotifications() async {
    try {
      final notifications = await _localDataSource.getPendingNotifications();
      return Result.success(notifications);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> enableNotifications() async {
    try {
      await _localDataSource.enableNotifications();
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<void>> disableNotifications() async {
    try {
      await _localDataSource.disableNotifications();
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
  
  @override
  Future<Result<bool>> areNotificationsEnabled() async {
    try {
      final isEnabled = await _localDataSource.areNotificationsEnabled();
      return Result.success(isEnabled);
    } on AppException catch (e) {
      return Result.failure(UnexpectedFailure(e.message));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Nieoczekiwany błąd: ${e.toString()}'));
    }
  }
}
