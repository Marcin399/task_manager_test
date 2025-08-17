import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/statistics_provider.dart';
import '../widgets/statistics_overview_widget.dart';
import '../widgets/day_of_week_stats_widget.dart';
import '../../../../core/constants/app_constants.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatisticsProvider>().refresh();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StatisticsProvider>().refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StatisticsProvider>(
      builder: (context, statisticsProvider, child) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Statystyki'),
              floating: true,
              snap: true,
            ),
            
            SliverPadding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (statisticsProvider.hasError)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(AppConstants.defaultPadding),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    statisticsProvider.errorMessage!,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Theme.of(context).colorScheme.onErrorContainer,
                                  ),
                                  onPressed: () => statisticsProvider.clearError(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    
                    if (statisticsProvider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    
                    else if (statisticsProvider.hasData) ...[
                      const StatisticsOverviewWidget(),
                      
                      const SizedBox(height: 24),
                      
                      const DayOfWeekStatsWidget(),
                      
                      const SizedBox(height: 24),
                    ]
                    
                    else
                      _buildEmptyState(context),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Brak danych statystycznych',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Utworz i ukończ kilka zadań, aby zobaczyć swoje statystyki produktywności',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
