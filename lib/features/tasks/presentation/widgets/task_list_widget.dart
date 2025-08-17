import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/task_entity.dart';
import '../providers/task_provider.dart';
import '../pages/add_task_page.dart';
import 'task_item_widget.dart';
import '../../../../core/constants/app_constants.dart';

class TaskListWidget extends StatelessWidget {
  final List<TaskEntity> tasks;
  
  const TaskListWidget({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final task = tasks[index];
          final previousTask = index > 0 ? tasks[index - 1] : null;
          
          final showDateHeader = _shouldShowDateHeader(task, previousTask);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDateHeader) ...[
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppConstants.defaultPadding,
                    bottom: 8,
                  ),
                  child: _buildDateHeader(context, task),
                ),
              ],
              TaskItemWidget(
                key: ValueKey(task.id),
                task: task,
                onTap: () => _onTaskTap(context, task),
                onToggle: () => _onTaskToggle(context, task),
                onDelete: () => _onTaskDelete(context, task),
              ),
            ],
          );
        },
        childCount: tasks.length,
      ),
    );
  }
  
  bool _shouldShowDateHeader(TaskEntity task, TaskEntity? previousTask) {
    if (previousTask == null) return true;
    
    final taskDate = DateTime(
      task.deadline.year,
      task.deadline.month,
      task.deadline.day,
    );
    final previousDate = DateTime(
      previousTask.deadline.year,
      previousTask.deadline.month,
      previousTask.deadline.day,
    );
    
    return !taskDate.isAtSameMomentAs(previousDate);
  }
  
  Widget _buildDateHeader(BuildContext context, TaskEntity task) {
    final now = DateTime.now();
    final taskDate = DateTime(
      task.deadline.year,
      task.deadline.month,
      task.deadline.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    
    String dateText;
    Color? textColor;
    
    if (taskDate.isAtSameMomentAs(today)) {
      dateText = 'Dzisiaj';
      textColor = Theme.of(context).colorScheme.primary;
    } else if (taskDate.isAtSameMomentAs(tomorrow)) {
      dateText = 'Jutro';
    } else if (taskDate.isAtSameMomentAs(yesterday)) {
      dateText = 'Wczoraj';
      textColor = Theme.of(context).colorScheme.error;
    } else if (taskDate.isBefore(today)) {
      dateText = 'Przeterminowane - ${DateFormat('dd.MM.yyyy').format(taskDate)}';
      textColor = Theme.of(context).colorScheme.error;
    } else {
      dateText = DateFormat('EEEE, dd MMMM yyyy', 'pl_PL').format(taskDate);
    }
    
    return Text(
      dateText,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
  
  void _onTaskTap(BuildContext context, TaskEntity task) {
    _navigateToEditTask(context, task);
  }
  
  void _navigateToEditTask(BuildContext context, TaskEntity task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTaskPage(taskToEdit: task),
      ),
    );
  }
  
  void _onTaskToggle(BuildContext context, TaskEntity task) {
    final taskProvider = context.read<TaskProvider>();
    
    if (task.isCompleted) {
      taskProvider.markTaskAsIncomplete(task.id);
    } else {
      taskProvider.markTaskAsCompleted(task.id);
    }
  }
  
  void _onTaskDelete(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuń zadanie'),
        content: Text('Czy na pewno chcesz usunąć zadanie "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TaskProvider>().deleteTask(task.id);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Usunięto zadanie "${task.title}"'),
                ),
              );
            },
            child: const Text('Usuń'),
          ),
        ],
      ),
    );
  }
}
