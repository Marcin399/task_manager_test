import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/task_entity.dart';
import '../../../../domain/usecases/task_usecases.dart';
import '../../../../domain/usecases/notification_usecases.dart';

@injectable
class TaskProvider extends ChangeNotifier {
  final TaskUseCases _taskUseCases;
  // ignore: unused_field
  final NotificationUseCases _notificationUseCases; 
  
  VoidCallback? _onTasksChanged;

  TaskProvider(this._taskUseCases, this._notificationUseCases);
  
  void setOnTasksChangedCallback(VoidCallback callback) {
    _onTasksChanged = callback;
  }

  final List<TaskEntity> _allTasks = <TaskEntity>[];

  String _searchQuery = '';
  TaskFilter _currentFilter = TaskFilter.all;
  TaskSortOption _currentSort = TaskSortOption.deadline;

  String? _errorMessage;

  bool _initialized = false;
  bool _disposed = false;

  UnmodifiableListView<TaskEntity> get allTasks => UnmodifiableListView(_allTasks);
  UnmodifiableListView<TaskEntity> get filteredTasks => UnmodifiableListView(_computeFiltered());

  UnmodifiableListView<TaskEntity> get activeTasks =>
      UnmodifiableListView(_allTasks.where((t) => !t.isCompleted));

  UnmodifiableListView<TaskEntity> get completedTasks =>
      UnmodifiableListView(_allTasks.where((t) => t.isCompleted));

  UnmodifiableListView<TaskEntity> get overdueTasks =>
      UnmodifiableListView(_allTasks.where((t) => !t.isCompleted && t.isOverdue));

  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  String get searchQuery => _searchQuery;
  TaskFilter get currentFilter => _currentFilter;
  TaskSortOption get currentSort => _currentSort;

  int get activeTasksCount => _allTasks.where((t) => !t.isCompleted).length;
  int get completedTasksCount => _allTasks.where((t) => t.isCompleted).length;
  int get overdueTasksCount => _allTasks.where((t) => !t.isCompleted && t.isOverdue).length;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await loadTasks();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> loadTasks() async {
    _clearError();
    try {
      final result = await _taskUseCases.getAllTasks();
      result.when(
        success: (tasks) {
          _allTasks
            ..clear()
            ..addAll(tasks);
          _emit();
        },
        failure: (failure) {
          _setError(_friendlyError(failure));
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } 
  }

  Future<void> createTask({
    required String title,
    String? description,
    required DateTime deadline,
    int? reminderMinutes,
    TaskPriority priority = TaskPriority.medium,
  }) async {
    _clearError();
    try {
      final result = await _taskUseCases.createTask(
        title: title,
        description: description,
        deadline: deadline,
        reminderMinutes: reminderMinutes,
        priority: priority,
      );
      result.when(
        success: (task) {
          _allTasks.add(task);
          _onTasksChanged?.call();
          _emit();
        },
        failure: (failure) {
          _setError(_friendlyError(failure));
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } 
  }

  Future<void> updateTask(TaskEntity task) async {
    _clearError();
    try {
      final result = await _taskUseCases.updateTask(task);
      result.when(
        success: (_) {
          final i = _allTasks.indexWhere((t) => t.id == task.id);
          if (i != -1) {
            _allTasks[i] = task;
          }
          _onTasksChanged?.call();
          _emit();
        },
        failure: (failure) {
          _setError(_friendlyError(failure));
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  Future<void> markTaskAsCompleted(String taskId) async {
    _clearError();
    try {
      final result = await _taskUseCases.markTaskAsCompleted(taskId);
      result.when(
        success: (_) {
          final i = _allTasks.indexWhere((t) => t.id == taskId);
          if (i != -1) {
            _allTasks[i] = _allTasks[i].markAsCompleted();
          }
          _onTasksChanged?.call();
          _emit();
        },
        failure: (failure) {
          _setError(_friendlyError(failure));
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  Future<void> markTaskAsIncomplete(String taskId) async {
    _clearError();
    try {
      final result = await _taskUseCases.markTaskAsIncomplete(taskId);
      result.when(
        success: (_) {
          final i = _allTasks.indexWhere((t) => t.id == taskId);
          if (i != -1) {
            _allTasks[i] = _allTasks[i].markAsIncomplete();
          }
          _onTasksChanged?.call();
          _emit();
        },
        failure: (failure) {
          _setError(_friendlyError(failure));
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } 
  }

  Future<void> deleteTask(String taskId) async {
    _clearError();
    try {
      final result = await _taskUseCases.deleteTask(taskId);
      result.when(
        success: (_) {
          _allTasks.removeWhere((t) => t.id == taskId);
          _onTasksChanged?.call();
          _emit();
        },
        failure: (failure) {
          _setError(_friendlyError(failure));
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } 
  }

  void searchTasks(String query) {
    final q = query.trim();
    if (q == _searchQuery) return;
    _searchQuery = q;
    _emit();
  }

  void applyFilter(TaskFilter filter) {
    if (filter == _currentFilter) return;
    _currentFilter = filter;
    _emit();
  }

  void applySorting(TaskSortOption sortOption) {
    if (sortOption == _currentSort) return;
    _currentSort = sortOption;
    _emit();
  }

  void clearSearch() {
    if (_searchQuery.isEmpty) return;
    _searchQuery = '';
    _emit();
  }

  void clearError() {
    if (_errorMessage == null) return;
    _clearError();
  }

  TaskEntity? getTaskById(String id) {
    try {
      return _allTasks.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteCompletedTasks() async {
    _clearError();
    try {
      final result = await _taskUseCases.deleteCompletedTasks();
      result.when(
        success: (_) {
          _allTasks.removeWhere((t) => t.isCompleted);
          _onTasksChanged?.call();
          _emit();
        },
        failure: (failure) {
          _setError(_friendlyError(failure));
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } 
  }

  void _setError(String? error) {
    _errorMessage = error;
    _emit();
  }

  void _clearError() {
    _errorMessage = null;
    _emit();
  }

  void _emit() {
    if (_disposed) return;
    notifyListeners();
  }

  List<TaskEntity> _computeFiltered() {

    Iterable<TaskEntity> base = _allTasks;
    switch (_currentFilter) {
      case TaskFilter.active:
        base = base.where((t) => !t.isCompleted);
        break;
      case TaskFilter.completed:
        base = base.where((t) => t.isCompleted);
        break;
      case TaskFilter.highPriority:
        base = base.where((t) => !t.isCompleted &&
            (t.priority == TaskPriority.high || t.priority == TaskPriority.urgent));
        break;
      case TaskFilter.all:

        break;
    }


    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      base = base.where((t) {
        final title = t.title.toLowerCase();
        final desc = t.description?.toLowerCase();
        return title.contains(q) || (desc?.contains(q) ?? false);
      });
    }

    final tasks = List<TaskEntity>.of(base);
    tasks.sort((a, b) {
      switch (_currentSort) {
        case TaskSortOption.deadline:
          return a.deadline.compareTo(b.deadline);
        case TaskSortOption.priority:
          return b.priority.value.compareTo(a.priority.value);
        case TaskSortOption.title:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case TaskSortOption.createdAt:
          return b.createdAt.compareTo(a.createdAt);
      }
    });

    return tasks;
  }

  String _friendlyError(Object failure) {
    return failure.toString();
  }
}

enum TaskFilter {
  all,
  active,
  completed,
  highPriority,
}

enum TaskSortOption {
  deadline,
  priority,
  title,
  createdAt,
}
