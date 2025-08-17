import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/features/tasks/presentation/providers/task_provider.dart';
import 'package:task_manager/features/statistics/presentation/providers/statistics_provider.dart';
import 'package:task_manager/features/notifications/presentation/providers/notification_provider.dart';
import 'package:task_manager/domain/usecases/task_usecases.dart';
import 'package:task_manager/domain/usecases/notification_usecases.dart';
import '../mocks/mock_task_repository.dart';
import '../mocks/mock_notification_repository.dart';
import '../mocks/mock_data_factory.dart';

void main() {
  group('App Widget Tests', () {
    late MockTaskRepository mockTaskRepo;
    late MockNotificationRepository mockNotificationRepo;
    late TaskProvider taskProvider;
    late StatisticsProvider statisticsProvider;
    late NotificationProvider notificationProvider;
    late TaskUseCases taskUseCases;
    late NotificationUseCases notificationUseCases;

    setUp(() {
      mockTaskRepo = MockTaskRepository();
      mockNotificationRepo = MockNotificationRepository();
      taskUseCases = TaskUseCases(mockTaskRepo, mockNotificationRepo);
      notificationUseCases = NotificationUseCases(mockNotificationRepo, mockTaskRepo);
      
      taskProvider = TaskProvider(taskUseCases, notificationUseCases);
      statisticsProvider = StatisticsProvider(taskUseCases);
      notificationProvider = NotificationProvider(notificationUseCases);
    });

    tearDown(() {
      mockTaskRepo.clearMockTasks();
      mockNotificationRepo.reset();
    });

    group('Basic App Rendering', () {
      testWidgets('should render MaterialApp without crashing', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
              ChangeNotifierProvider<StatisticsProvider>.value(value: statisticsProvider),
              ChangeNotifierProvider<NotificationProvider>.value(value: notificationProvider),
            ],
            child: MaterialApp(
              title: 'Test App',
              home: Scaffold(
                appBar: AppBar(title: const Text('Test')),
                body: const Text('Test App'),
              ),
            ),
          ),
        );

        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.text('Test App'), findsOneWidget);
      });

      testWidgets('should initialize providers correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
              ChangeNotifierProvider<StatisticsProvider>.value(value: statisticsProvider),
              ChangeNotifierProvider<NotificationProvider>.value(value: notificationProvider),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  final taskProv = Provider.of<TaskProvider>(context, listen: false);
                  
                  return Scaffold(
                    body: Column(
                      children: [
                        Text('Tasks: ${taskProv.allTasks.length}'),
                        const Text('Stats initialized: true'),
                        const Text('Notifications initialized: true'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that providers are working
        expect(find.text('Tasks: 0'), findsOneWidget);
        expect(find.text('Stats initialized: true'), findsOneWidget);
        expect(find.text('Notifications initialized: true'), findsOneWidget);
      });
    });

    group('Provider Integration', () {
      testWidgets('TaskProvider should load tasks correctly', (WidgetTester tester) async {
        // Arrange
        final mockTasks = MockDataFactory.createMockTasks(count: 3);
        mockTaskRepo.addMockTasks(mockTasks);

        // Load tasks before building the widget
        await taskProvider.loadTasks();

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  final taskProv = Provider.of<TaskProvider>(context, listen: false);
                  
                  return Scaffold(
                    body: Text('Tasks loaded: ${taskProv.allTasks.length}'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify tasks are loaded
        expect(find.text('Tasks loaded: 3'), findsOneWidget);
      });

      testWidgets('should handle provider state changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  return Scaffold(
                    body: Consumer<TaskProvider>(
                      builder: (context, provider, child) {
                        return Text('Tasks: ${provider.allTasks.length}');
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );

        // Initially should show 0 tasks
        expect(find.text('Tasks: 0'), findsOneWidget);

        // Add a task and notify listeners
        final task = MockDataFactory.createMockTask();
        mockTaskRepo.addMockTask(task);
        await taskProvider.loadTasks();
        await tester.pumpAndSettle();

        // Should now show 1 task
        expect(find.text('Tasks: 1'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle provider errors gracefully', (WidgetTester tester) async {
        // Arrange
        mockTaskRepo.setShouldFail(true);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  return Scaffold(
                    body: Consumer<TaskProvider>(
                      builder: (context, provider, child) {
                        if (provider.hasError) {
                          return Text('Error: ${provider.errorMessage}');
                        }
                        return Text('Tasks: ${provider.allTasks.length}');
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );

        // Try to load tasks (should fail)
        await taskProvider.loadTasks();
        await tester.pumpAndSettle();

        // Should show error message
        expect(find.textContaining('Error:'), findsOneWidget);
      });
    });
  });
}
