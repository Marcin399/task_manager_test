import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/statistics_provider.dart';
import '../../../../core/constants/app_constants.dart';

class StatisticsOverviewWidget extends StatelessWidget {
  const StatisticsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsProvider>(
      builder: (context, provider, child) {
        if (!provider.hasData) {
          return const SizedBox.shrink();
        }
        
        return Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Przegląd',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                _buildPeriodStats(
                  context,
                  title: 'Dzisiaj',
                  completedTasks: provider.completedTasksToday,
                  completionRate: provider.getCompletionRateForPeriod(StatisticsPeriod.today),
                  icon: Icons.today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                
                const SizedBox(height: 12),
                
                _buildPeriodStats(
                  context,
                  title: 'Ten tydzień',
                  completedTasks: provider.completedTasksThisWeek,
                  completionRate: provider.getCompletionRateForPeriod(StatisticsPeriod.thisWeek),
                  icon: Icons.date_range,
                  color: Colors.green,
                ),
                
                const SizedBox(height: 12),
                
                _buildPeriodStats(
                  context,
                  title: 'Ten miesiąc',
                  completedTasks: provider.completedTasksThisMonth,
                  completionRate: provider.getCompletionRateForPeriod(StatisticsPeriod.thisMonth),
                  icon: Icons.calendar_month,
                  color: Colors.orange,
                ),
                
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildOverallStatCard(
                        context,
                        title: 'Wszystkie zadania',
                        value: provider.totalTasks.toString(),
                        icon: Icons.assignment,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOverallStatCard(
                        context,
                        title: 'Ukończone',
                        value: provider.statistics!.completedTasks.toString(),
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildOverallStatCard(
                        context,
                        title: 'Oczekujące',
                        value: provider.pendingTasks.toString(),
                        icon: Icons.pending,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOverallStatCard(
                        context,
                        title: 'Przeterminowane',
                        value: provider.overdueTasksCount.toString(),
                        icon: Icons.warning,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.analytics,
                         color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ogólny wskaźnik ukończenia',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${provider.completionRate.toStringAsFixed(1)}%',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: provider.completionRate / 100,
                                    backgroundColor: Colors.black,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildPeriodStats(
    BuildContext context, {
    required String title,
    required int completedTasks,
    required double completionRate,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$completedTasks zadań',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${completionRate.toStringAsFixed(1)}%)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOverallStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
