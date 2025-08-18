import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_statistics_entity.freezed.dart';

@freezed
class TaskStatisticsEntity with _$TaskStatisticsEntity {
  const factory TaskStatisticsEntity({
    required int completedTasksToday,
    required int completedTasksThisWeek,
    required int completedTasksThisMonth,
    required int totalTasks,
    required int completedTasks,
    required int pendingTasks,
    required int overdueTasks,
    required Map<int, int> completedTasksByDay, 
    required double completionRate,
    required int mostProductiveDayOfWeek,
  }) = _TaskStatisticsEntity;
  
  const TaskStatisticsEntity._();
  
  int get incompleteTasks => totalTasks - completedTasks;
  
  bool get hasCompletedTasksToday => completedTasksToday > 0;
  
  bool get hasCompletedTasksThisWeek => completedTasksThisWeek > 0;
  
  bool get hasCompletedTasksThisMonth => completedTasksThisMonth > 0;
  
  String get mostProductiveDayName {
    const dayNames = {
      1: 'Poniedziałek',
      2: 'Wtorek', 
      3: 'Środa',
      4: 'Czwartek',
      5: 'Piątek',
      6: 'Sobota',
      7: 'Niedziela',
    };
    
    return dayNames[mostProductiveDayOfWeek] ?? 'Brak danych';
  }
  
  int getCompletedTasksForDay(int dayOfWeek) {
    return completedTasksByDay[dayOfWeek] ?? 0;
  }
  
  double get weeklyCompletionRate {
    if (completedTasksThisWeek == 0) return 0.0;
    final totalThisWeek = completedTasksThisWeek + pendingTasks;
    return totalThisWeek > 0 ? (completedTasksThisWeek / totalThisWeek) * 100 : 0.0;
  }
  
  double get monthlyCompletionRate {
    if (completedTasksThisMonth == 0) return 0.0;
    final totalThisMonth = completedTasksThisMonth + pendingTasks;
    return totalThisMonth > 0 ? (completedTasksThisMonth / totalThisMonth) * 100 : 0.0;
  }
}

@freezed
class ProductivityTrend with _$ProductivityTrend {
  const factory ProductivityTrend({
    required DateTime date,
    required int completedTasks,
    required int totalTasks,
  }) = _ProductivityTrend;
  
  const ProductivityTrend._();
  
  double get completionRate {
    return totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0;
  }
}
