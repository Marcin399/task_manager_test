import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../../core/constants/app_constants.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  
  const TaskItemWidget({
    super.key,
    required this.task,
    this.onTap,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = task.isOverdue;
    final isDueToday = task.isDueToday;
    
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.white,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => onToggle?.call(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            decoration: task.isCompleted 
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? theme.colorScheme.onSurfaceVariant
                                : null,
                          ),
                        ),
                        
                        if (task.description?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: task.isCompleted
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onSurfaceVariant,
                              decoration: task.isCompleted 
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: isOverdue
                                  ? theme.colorScheme.error
                                  : isDueToday
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDeadline(task.deadline),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isOverdue
                                    ? theme.colorScheme.error
                                    : isDueToday
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                fontWeight: isOverdue || isDueToday
                                    ? FontWeight.w600
                                    : null,
                              ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            _buildPriorityChip(context, task.priority),
                            
                            const Spacer(),
                            
                            if (task.hasReminder) ...[
                              Icon(
                                Icons.notifications_active,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                            ],
                            
                            PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuAction(value),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Edytuj'),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'toggle',
                                  child: ListTile(
                                    leading: Icon(
                                      task.isCompleted 
                                          ? Icons.undo 
                                          : Icons.check,
                                    ),
                                    title: Text(
                                      task.isCompleted 
                                          ? 'Oznacz jako nieukończone'
                                          : 'Oznacz jako ukończone',
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(Icons.delete, color: Colors.red),
                                    title: Text('Usuń', style: TextStyle(color: Colors.red)),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                              child: Icon(
                                Icons.more_vert,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              if (isOverdue && !task.isCompleted) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 16,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Przeterminowane',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPriorityChip(BuildContext context, TaskPriority priority) {
    final theme = Theme.of(context);
    
    Color backgroundColor;
    Color textColor;
    String label;
    
    switch (priority) {
      case TaskPriority.low:
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        label = 'Niski';
        break;
      case TaskPriority.medium:
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        label = 'Średni';
        break;
      case TaskPriority.high:
        backgroundColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        label = 'Wysoki';
        break;
      case TaskPriority.urgent:
        backgroundColor = Colors.purple.withValues(alpha: 0.1);
        textColor = Colors.purple;
        label = 'Pilne';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
  
  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(deadline.year, deadline.month, deadline.day);
    
    if (taskDate.isAtSameMomentAs(today)) {
      return 'Dzisiaj ${DateFormat('HH:mm').format(deadline)}';
    } else if (taskDate.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
      return 'Jutro ${DateFormat('HH:mm').format(deadline)}';
    } else if (taskDate.isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
      return 'Wczoraj ${DateFormat('HH:mm').format(deadline)}';
    } else {
      return DateFormat('dd.MM.yyyy HH:mm').format(deadline);
    }
  }
  
  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        onTap?.call();
        break;
      case 'toggle':
        onToggle?.call();
        break;
      case 'delete':
        onDelete?.call();
        break;
    }
  }
}
