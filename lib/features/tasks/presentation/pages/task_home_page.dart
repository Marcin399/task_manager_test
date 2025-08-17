import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../../../statistics/presentation/providers/statistics_provider.dart';
import '../widgets/task_list_widget.dart';
import '../widgets/task_filter_widget.dart';
import 'add_task_page.dart';
import '../../../statistics/presentation/pages/statistics_page.dart';
import '../../../../core/constants/app_constants.dart';

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = context.read<TaskProvider>();
      final statisticsProvider = context.read<StatisticsProvider>();
      taskProvider.setOnTasksChangedCallback(() {
        statisticsProvider.refresh();
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _TasksView(),
          StatisticsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Zadania',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Statystyki',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => _navigateToAddTask(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
  
  void _navigateToAddTask(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddTaskPage(),
      ),
    );
    
    context.read<StatisticsProvider>().refresh();
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text(AppConstants.appName),
              floating: true,
              snap: true,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TaskFilterWidget(),
                  
                  if (taskProvider.hasError)
                    Container(
                      margin: const EdgeInsets.all(AppConstants.defaultPadding),
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
                                  taskProvider.errorMessage!,
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
                                onPressed: () => taskProvider.clearError(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (taskProvider.filteredTasks.isEmpty)
              SliverFillRemaining(
                child: _buildEmptyState(context, taskProvider),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                sliver: TaskListWidget(tasks: taskProvider.filteredTasks),
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildEmptyState(BuildContext context, TaskProvider taskProvider) {
    final hasSearchQuery = taskProvider.searchQuery.isNotEmpty;
    final isFiltered = taskProvider.currentFilter != TaskFilter.all;
    
    String title;
    String subtitle;
    IconData icon;
    
    if (hasSearchQuery) {
      title = 'Brak wyników';
      subtitle = 'Nie znaleziono zadań pasujących do frazy "${taskProvider.searchQuery}"';
      icon = Icons.search_off;
    } else if (isFiltered) {
      title = 'Brak zadań';
      subtitle = 'Nie ma zadań w wybranej kategorii';
      icon = Icons.filter_list_off;
    } else {
      title = 'Brak zadań';
      subtitle = 'Dodaj swoje pierwsze zadanie, aby rozpocząć organizację pracy';
      icon = Icons.task_alt;
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (!hasSearchQuery && !isFiltered) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddTaskPage(),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Dodaj zadanie'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TaskSearchDelegate extends SearchDelegate<String> {
  final TaskProvider taskProvider;
  
  TaskSearchDelegate(this.taskProvider);
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          taskProvider.clearSearch();
        },
      ),
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    taskProvider.searchTasks(query);
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        if (provider.filteredTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Brak wyników dla "$query"',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: provider.filteredTasks.length,
          itemBuilder: (context, index) {
            final task = provider.filteredTasks[index];
            return Card(
              child: ListTile(
                title: Text(task.title),
                subtitle: task.description?.isNotEmpty == true 
                    ? Text(task.description!)
                    : null,
                trailing: task.isCompleted
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () {
                  close(context, task.id);
                },
              ),
            );
          },
        );
      },
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Wpisz nazwę zadania, aby wyszukać'),
      );
    }
    
    taskProvider.searchTasks(query);
    return buildResults(context);
  }
}
