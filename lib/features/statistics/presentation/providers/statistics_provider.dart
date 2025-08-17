import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/task_statistics_entity.dart';
import '../../../../domain/usecases/task_usecases.dart';


@injectable
class StatisticsProvider extends ChangeNotifier {
  final TaskUseCases _taskUseCases;
  
  StatisticsProvider(this._taskUseCases);
  
  TaskStatisticsEntity? _statistics;
  List<ProductivityTrend> _productivityTrend = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedTrendDays = 30;
  TaskStatisticsEntity? get statistics => _statistics;
  List<ProductivityTrend> get productivityTrend => _productivityTrend;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasData => _statistics != null;
  int get selectedTrendDays => _selectedTrendDays;
  

  int get completedTasksToday => _statistics?.completedTasksToday ?? 0;
  int get completedTasksThisWeek => _statistics?.completedTasksThisWeek ?? 0;
  int get completedTasksThisMonth => _statistics?.completedTasksThisMonth ?? 0;
  int get totalTasks => _statistics?.totalTasks ?? 0;
  int get pendingTasks => _statistics?.pendingTasks ?? 0;
  int get overdueTasksCount => _statistics?.overdueTasks ?? 0;
  double get completionRate => _statistics?.completionRate ?? 0.0;
  String get mostProductiveDayName => _statistics?.mostProductiveDayName ?? 'Brak danych';
  

  Future<void> initialize() async {
    await loadStatistics();
    await loadProductivityTrend();
  }
  

  Future<void> loadStatistics() async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _taskUseCases.getTaskStatistics();
      
      result.when(
        success: (stats) {
          _statistics = stats;
        },
        failure: (failure) {
          _setError('Błąd podczas ładowania statystyk: ${failure.toString()}');
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  

  Future<void> loadProductivityTrend({int? days}) async {
    if (days != null) {
      _selectedTrendDays = days;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _taskUseCases.getProductivityTrend(days: _selectedTrendDays);
      
      result.when(
        success: (trends) {
          _productivityTrend = trends;
        },
        failure: (failure) {
          _setError('Błąd podczas ładowania trendu produktywności: ${failure.toString()}');
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  

  Future<void> refresh() async {
    await Future.wait([
      loadStatistics(),
      loadProductivityTrend(),
    ]);
  }
  

  double getCompletionRateForPeriod(StatisticsPeriod period) {
    if (_statistics == null) return 0.0;
    
    switch (period) {
      case StatisticsPeriod.today:
        return _statistics!.hasCompletedTasksToday ? 100.0 : 0.0;
      case StatisticsPeriod.thisWeek:
        return _statistics!.weeklyCompletionRate;
      case StatisticsPeriod.thisMonth:
        return _statistics!.monthlyCompletionRate;
      case StatisticsPeriod.overall:
        return _statistics!.completionRate;
    }
  }
  

  int getCompletedTasksForPeriod(StatisticsPeriod period) {
    if (_statistics == null) return 0;
    
    switch (period) {
      case StatisticsPeriod.today:
        return _statistics!.completedTasksToday;
      case StatisticsPeriod.thisWeek:
        return _statistics!.completedTasksThisWeek;
      case StatisticsPeriod.thisMonth:
        return _statistics!.completedTasksThisMonth;
      case StatisticsPeriod.overall:
        return _statistics!.completedTasks;
    }
  }
  

  double getProductivityScore() {
    if (_statistics == null) return 0.0;
    
    double score = 0.0;
    
    score += (_statistics!.completionRate * 0.6);
    
    final consistencyBonus = _calculateConsistencyBonus();
    score += consistencyBonus;
    
    final recentActivityBonus = _calculateRecentActivityBonus();
    score += recentActivityBonus;
    
    return score.clamp(0.0, 100.0);
  }
  

  int getCompletionStreak() {
    if (_productivityTrend.isEmpty) return 0;
    
    int streak = 0;
    final sortedTrends = List<ProductivityTrend>.from(_productivityTrend)
      ..sort((a, b) => b.date.compareTo(a.date));
    
    for (final trend in sortedTrends) {
      if (trend.completedTasks > 0) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }
  

  double getAverageTasksPerDay() {
    if (_productivityTrend.isEmpty) return 0.0;
    
    final totalCompleted = _productivityTrend
        .map((trend) => trend.completedTasks)
        .fold(0, (sum, count) => sum + count);
    
    return totalCompleted / _productivityTrend.length;
  }
  

  Map<String, int> getDayOfWeekStats() {
    if (_statistics == null) return {};
    
    const dayNames = [
      'Poniedziałek', 
      'Wtorek',
      'Środa',
      'Czwartek',
      'Piątek',
      'Sobota',
      'Niedziela',
    ];
    
    final dayStats = <String, int>{};
    for (int i = 0; i < dayNames.length; i++) {
      final weekday = i == 6 ? 7 : i + 1;
      dayStats[dayNames[i]] = _statistics!.getCompletedTasksForDay(weekday);
    }
    
    return dayStats;
  }
  

  void clearError() {
    _clearError();
    notifyListeners();
  }
  

  double _calculateConsistencyBonus() {
    if (_productivityTrend.length < 7) return 0.0;
    
    final recentWeek = _productivityTrend.take(7);
    final daysWithActivity = recentWeek.where((trend) => trend.completedTasks > 0).length;
    
    return (daysWithActivity / 7.0) * 20.0;
  }
  
  double _calculateRecentActivityBonus() {
    if (_statistics == null) return 0.0;
    
    double bonus = 0.0;
    
    if (_statistics!.hasCompletedTasksToday) {
      bonus += 10.0;
    }
    
    if (_statistics!.hasCompletedTasksThisWeek) {
      bonus += 5.0;
    }
    
    if (_statistics!.overdueTasks == 0) {
      bonus += 5.0;
    }
    
    return bonus;
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
  }
}

enum StatisticsPeriod {
  today,
  thisWeek,
  thisMonth,
  overall,
}
