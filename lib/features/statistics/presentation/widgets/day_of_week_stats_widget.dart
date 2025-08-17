import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/statistics_provider.dart';
import '../../../../core/constants/app_constants.dart';

class DayOfWeekStatsWidget extends StatelessWidget {
  const DayOfWeekStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsProvider>(
      builder: (context, provider, child) {
        if (!provider.hasData) {
          return const SizedBox.shrink();
        }
        
        final dayStats = provider.getDayOfWeekStats();
        
        return Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produktywność w tygodniu',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Najproduktywniejszy dzień: ${provider.mostProductiveDayName}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildDayOfWeekChart(context, dayStats),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildDayOfWeekChart(BuildContext context, Map<String, int> dayStats) {
    if (dayStats.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Brak danych o produktywności'),
        ),
      );
    }
    
    final maxTasks = dayStats.values.isNotEmpty 
        ? dayStats.values.reduce((a, b) => a > b ? a : b)
        : 1;
    
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: dayStats.entries.map((entry) {
          return _buildDayBar(
            context,
            dayName: _getShortDayName(entry.key),
            taskCount: entry.value,
            maxTasks: maxTasks,
            isHighest: entry.value == maxTasks && maxTasks > 0,
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildDayBar(
    BuildContext context, {
    required String dayName,
    required int taskCount,
    required int maxTasks,
    required bool isHighest,
  }) {
    final theme = Theme.of(context);
    final barHeight = maxTasks > 0 ? (taskCount / maxTasks) * 130 : 0.0;
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Task count label
            Text(
              taskCount.toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isHighest ? theme.colorScheme.primary : null,
              ),
            ),
            const SizedBox(height: 4),
            
            // Bar
            Container(
              width: double.infinity,
              height: barHeight,
              decoration: BoxDecoration(
                color: isHighest 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withValues(alpha: 0.6),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Day name
            Text(
              dayName,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isHighest ? FontWeight.w600 : null,
                color: isHighest ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getShortDayName(String fullDayName) {
    switch (fullDayName) {
      case 'Poniedziałek':
        return 'Pon';
      case 'Wtorek':
        return 'Wt';
      case 'Środa':
        return 'Śr';
      case 'Czwartek':
        return 'Czw';
      case 'Piątek':
        return 'Pt';
      case 'Sobota':
        return 'Sob';
      case 'Niedziela':
        return 'Nd';
      default:
        return fullDayName.substring(0, 3);
    }
  }
}
