import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/core/errors/failures.dart';
import '../../mocks/mock_notification_repository.dart';
import '../../mocks/mock_data_factory.dart';

void main() {
  group('NotificationRepository Tests', () {
    late MockNotificationRepository repository;

    setUp(() {
      repository = MockNotificationRepository();
    });

    tearDown(() {
      repository.reset();
    });

    group('Initialization', () {
      test('should initialize correctly', () async {
        // Act
        final result = await repository.initialize();

        // Assert
        expect(result.isSuccess, true);
      });

      test('should handle initialization failure', () async {
        // Arrange
        repository.setShouldFail(true, const UnexpectedFailure('Init failed'));

        // Act
        final result = await repository.initialize();

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, isA<UnexpectedFailure>());
      });
    });

    group('Permissions', () {
      test('should handle permissions correctly', () async {
        // Act
        final checkResult = await repository.checkPermissions();
        final requestResult = await repository.requestPermissions();

        // Assert
        expect(checkResult.data, true);
        expect(requestResult.data, true);
      });

      test('should handle permission denial', () async {
        // Arrange
        repository.setPermissions(false);

        // Act
        final checkResult = await repository.checkPermissions();
        final requestResult = await repository.requestPermissions();

        // Assert
        expect(checkResult.data, false);
        expect(requestResult.data, false);
      });

      test('should open app settings', () async {
        // Act
        final result = await repository.openAppSettings();

        // Assert
        expect(result.isSuccess, true);
        expect(result.data, true);
      });
    });

    group('Task Reminders', () {
      test('should schedule task reminders', () async {
        // Arrange
        await repository.initialize();
        final task = MockDataFactory.createMockTask(reminderMinutes: 60);

        // Act
        final scheduleResult = await repository.scheduleTaskReminder(task);
        final pendingResult = await repository.getPendingNotifications();

        // Assert
        expect(scheduleResult.isSuccess, true);
        expect(pendingResult.data!.contains(task.id), true);
      });

      test('should cancel task reminders', () async {
        // Arrange
        await repository.initialize();
        final task = MockDataFactory.createMockTask(reminderMinutes: 60);
        await repository.scheduleTaskReminder(task);

        // Act
        final cancelResult = await repository.cancelTaskReminder(task.id);
        final pendingResult = await repository.getPendingNotifications();

        // Assert
        expect(cancelResult.isSuccess, true);
        expect(pendingResult.data!.contains(task.id), false);
      });

      test('should cancel all reminders', () async {
        // Arrange
        await repository.initialize();
        final task1 = MockDataFactory.createMockTask(reminderMinutes: 60);
        final task2 = MockDataFactory.createMockTask(reminderMinutes: 30);
        await repository.scheduleTaskReminder(task1);
        await repository.scheduleTaskReminder(task2);

        // Act
        final cancelResult = await repository.cancelAllReminders();
        final pendingResult = await repository.getPendingNotifications();

        // Assert
        expect(cancelResult.isSuccess, true);
        expect(pendingResult.data!.isEmpty, true);
      });

      test('should fail to schedule reminder for completed task', () async {
        // Arrange
        await repository.initialize();
        final completedTask = MockDataFactory.createMockTask(
          isCompleted: true,
          reminderMinutes: 60,
        );

        // Act
        final result = await repository.scheduleTaskReminder(completedTask);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, isA<ValidationFailure>());
      });

      test('should fail to schedule reminder without permissions', () async {
        // Arrange
        await repository.initialize();
        repository.setPermissions(false);
        final task = MockDataFactory.createMockTask(reminderMinutes: 60);

        // Act
        final result = await repository.scheduleTaskReminder(task);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, isA<UnauthorizedFailure>());
      });

      test('should fail to schedule reminder when notifications disabled', () async {
        // Arrange
        await repository.initialize();
        repository.setNotificationsEnabled(false);
        final task = MockDataFactory.createMockTask(reminderMinutes: 60);

        // Act
        final result = await repository.scheduleTaskReminder(task);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, isA<ValidationFailure>());
      });
    });

    group('Reminder Settings', () {
      test('should update default reminder time', () async {
        // Act
        final updateResult = await repository.updateDefaultReminderTime(30);
        final getResult = await repository.getDefaultReminderTime();

        // Assert
        expect(updateResult.isSuccess, true);
        expect(getResult.data, 30);
      });

      test('should validate reminder time', () async {
        // Act
        final result = await repository.updateDefaultReminderTime(-5);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, isA<ValidationFailure>());
      });
    });

    group('Notification Settings', () {
      test('should enable notifications', () async {
        // Act
        final enableResult = await repository.enableNotifications();
        final statusResult = await repository.areNotificationsEnabled();

        // Assert
        expect(enableResult.isSuccess, true);
        expect(statusResult.data, true);
      });

      test('should disable notifications', () async {
        // Arrange
        await repository.initialize();
        final task = MockDataFactory.createMockTask(reminderMinutes: 60);
        await repository.scheduleTaskReminder(task);

        // Act
        final disableResult = await repository.disableNotifications();
        final statusResult = await repository.areNotificationsEnabled();
        final pendingResult = await repository.getPendingNotifications();

        // Assert
        expect(disableResult.isSuccess, true);
        expect(statusResult.data, false);
        expect(pendingResult.data!.isEmpty, true); // Should cancel all reminders
      });

      test('should fail to enable notifications without permissions', () async {
        // Arrange
        repository.setPermissions(false);

        // Act
        final result = await repository.enableNotifications();

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, isA<UnauthorizedFailure>());
      });
    });

    group('Bulk Operations', () {
      test('should reschedule all reminders', () async {
        // Arrange
        await repository.initialize();
        final tasks = [
          MockDataFactory.createMockTask(reminderMinutes: 60, isCompleted: false),
          MockDataFactory.createMockTask(reminderMinutes: 30, isCompleted: false),
          MockDataFactory.createMockTask(reminderMinutes: null, isCompleted: false), // No reminder
          MockDataFactory.createMockTask(reminderMinutes: 60, isCompleted: true), // Completed
        ];

        // Act
        final rescheduleResult = await repository.rescheduleAllReminders(tasks);
        final pendingResult = await repository.getPendingNotifications();

        // Assert
        expect(rescheduleResult.isSuccess, true);
        expect(pendingResult.data!.length, 2); // Only 2 tasks should have reminders
      });

      test('should handle reschedule without permissions gracefully', () async {
        // Arrange
        await repository.initialize();
        repository.setPermissions(false);
        final tasks = [MockDataFactory.createMockTask(reminderMinutes: 60)];

        // Act
        final result = await repository.rescheduleAllReminders(tasks);

        // Assert
        expect(result.isSuccess, true); // Should succeed but not schedule anything
      });
    });

    group('Error Handling', () {
      test('should handle failure scenarios', () async {
        // Arrange
        repository.setShouldFail(true, const UnexpectedFailure('Network error'));

        // Act
        final result = await repository.initialize();

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, isA<UnexpectedFailure>());
      });
    });
  });
}
