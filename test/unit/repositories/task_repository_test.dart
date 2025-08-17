import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/core/errors/failures.dart';
import '../../mocks/mock_task_repository.dart';
import '../../mocks/mock_data_factory.dart';

void main() {
  group('TaskRepository Tests', () {
    late MockTaskRepository repository;

    setUp(() {
      repository = MockTaskRepository();
    });

    tearDown(() {
      repository.clearMockTasks();
    });

    group('CRUD Operations', () {
      test('should create and retrieve tasks correctly', () async {
        // Arrange
        final task = MockDataFactory.createMockTask(title: 'Test Task');

        // Act
        final createResult = await repository.createTask(task);
        final getAllResult = await repository.getAllTasks();

        // Assert
        expect(createResult.isSuccess, true);
        expect(createResult.data, task.id);
        expect(getAllResult.isSuccess, true);
        expect(getAllResult.data!.length, 1);
        expect(getAllResult.data!.first.title, 'Test Task');
      });

      test('should update tasks correctly', () async {
        // Arrange
        final task = MockDataFactory.createMockTask(title: 'Original Title');
        await repository.createTask(task);

        // Act
        final updatedTask = task.copyWith(title: 'Updated Title');
        final updateResult = await repository.updateTask(updatedTask);
        final getResult = await repository.getTaskById(task.id);

        // Assert
        expect(updateResult.isSuccess, true);
        expect(getResult.isSuccess, true);
        expect(getResult.data!.title, 'Updated Title');
      });

      test('should delete tasks correctly', () async {
        // Arrange
        final task = MockDataFactory.createMockTask();
        await repository.createTask(task);

        // Act
        final deleteResult = await repository.deleteTask(task.id);
        final getResult = await repository.getTaskById(task.id);

        // Assert
        expect(deleteResult.isSuccess, true);
        expect(getResult.data, null);
      });

      test('should return not found when updating non-existent task', () async {
        // Arrange
        final task = MockDataFactory.createMockTask();

        // Act
        final result = await repository.updateTask(task);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, isA<NotFoundFailure>());
      });

      test('should return not found when deleting non-existent task', () async {
        // Act
        final result = await repository.deleteTask('non-existent-id');

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, isA<NotFoundFailure>());
      });
    });

    group('Task Status Operations', () {
      test('should mark tasks as completed', () async {
        // Arrange
        final task = MockDataFactory.createMockTask(isCompleted: false);
        await repository.createTask(task);

        // Act
        final markResult = await repository.markTaskAsCompleted(task.id);
        final getResult = await repository.getTaskById(task.id);

        // Assert
        expect(markResult.isSuccess, true);
        expect(getResult.data!.isCompleted, true);
      });

      test('should mark tasks as incomplete', () async {
        // Arrange
        final task = MockDataFactory.createMockTask(isCompleted: true);
        await repository.createTask(task);

        // Act
        final markResult = await repository.markTaskAsIncomplete(task.id);
        final getResult = await repository.getTaskById(task.id);

        // Assert
        expect(markResult.isSuccess, true);
        expect(getResult.data!.isCompleted, false);
      });
    });

    group('Filtering and Search', () {
      test('should filter tasks by status', () async {
        // Arrange
        final completedTask = MockDataFactory.createMockTask(isCompleted: true);
        final pendingTask = MockDataFactory.createMockTask(isCompleted: false);
        await repository.createTask(completedTask);
        await repository.createTask(pendingTask);

        // Act
        final completedResult = await repository.getTasksByStatus(true);
        final pendingResult = await repository.getTasksByStatus(false);

        // Assert
        expect(completedResult.data!.length, 1);
        expect(completedResult.data!.first.isCompleted, true);
        expect(pendingResult.data!.length, 1);
        expect(pendingResult.data!.first.isCompleted, false);
      });

      test('should search tasks by title and description', () async {
        // Arrange
        final task1 = MockDataFactory.createMockTask(title: 'Important Meeting');
        final task2 = MockDataFactory.createMockTask(title: 'Buy groceries', description: 'Important items');
        final task3 = MockDataFactory.createMockTask(title: 'Call mom');
        await repository.createTask(task1);
        await repository.createTask(task2);
        await repository.createTask(task3);

        // Act
        final searchResult = await repository.searchTasks('important');

        // Assert
        expect(searchResult.data!.length, 2);
        expect(searchResult.data!.any((task) => task.title.contains('Meeting')), true);
        expect(searchResult.data!.any((task) => task.title.contains('groceries')), true);
      });

      test('should filter tasks by priority', () async {
        // Arrange
        final highPriorityTask = MockDataFactory.createMockTask(priority: TaskPriority.high);
        final lowPriorityTask = MockDataFactory.createMockTask(priority: TaskPriority.low);
        await repository.createTask(highPriorityTask);
        await repository.createTask(lowPriorityTask);

        // Act
        final highPriorityResult = await repository.getTasksByPriority(TaskPriority.high);
        final lowPriorityResult = await repository.getTasksByPriority(TaskPriority.low);

        // Assert
        expect(highPriorityResult.data!.length, 1);
        expect(highPriorityResult.data!.first.priority, TaskPriority.high);
        expect(lowPriorityResult.data!.length, 1);
        expect(lowPriorityResult.data!.first.priority, TaskPriority.low);
      });
    });

    group('Statistics', () {
      test('should return task statistics', () async {
        // Arrange
        final tasks = MockDataFactory.createMockTasks(count: 10);
        repository.addMockTasks(tasks);

        // Act
        final statsResult = await repository.getTaskStatistics();

        // Assert
        expect(statsResult.isSuccess, true);
        expect(statsResult.data!.totalTasks, 10);
        expect(statsResult.data!.completedTasks, 5); // Half are completed
        expect(statsResult.data!.pendingTasks, 5); // Half are pending
      });

      test('should return productivity trend', () async {
        // Act
        final startDate = DateTime.now().subtract(const Duration(days: 7));
        final endDate = DateTime.now();
        final trendResult = await repository.getProductivityTrend(startDate, endDate);

        // Assert
        expect(trendResult.isSuccess, true);
        expect(trendResult.data!.length, 7);
      });
    });

    group('Bulk Operations', () {
      test('should delete completed tasks', () async {
        // Arrange
        final completedTask = MockDataFactory.createMockTask(isCompleted: true);
        final pendingTask = MockDataFactory.createMockTask(isCompleted: false);
        await repository.createTask(completedTask);
        await repository.createTask(pendingTask);

        // Act
        final deleteResult = await repository.deleteCompletedTasks();
        final allTasksResult = await repository.getAllTasks();

        // Assert
        expect(deleteResult.isSuccess, true);
        expect(allTasksResult.data!.length, 1);
        expect(allTasksResult.data!.first.isCompleted, false);
      });

      test('should bulk update tasks', () async {
        // Arrange
        final tasks = MockDataFactory.createMockTasks(count: 3);
        repository.addMockTasks(tasks);

        // Act
        final updatedTasks = tasks.map((task) => task.copyWith(title: 'Updated ${task.title}')).toList();
        final bulkUpdateResult = await repository.bulkUpdateTasks(updatedTasks);
        final allTasksResult = await repository.getAllTasks();

        // Assert
        expect(bulkUpdateResult.isSuccess, true);
        expect(allTasksResult.data!.every((task) => task.title.startsWith('Updated')), true);
      });
    });

    group('Error Handling', () {
      test('should handle failure scenarios', () async {
        // Arrange
        repository.setShouldFail(true, const DatabaseFailure('Database error'));
        final task = MockDataFactory.createMockTask();

        // Act
        final result = await repository.createTask(task);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, isA<DatabaseFailure>());
      });
    });
  });
}
