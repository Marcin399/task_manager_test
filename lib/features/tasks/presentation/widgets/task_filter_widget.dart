import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/input_decorators.dart';

class TaskFilterWidget extends StatelessWidget {
  const TaskFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...TaskFilter.values.map((filter) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_getFilterLabel(filter)),
                        selected: taskProvider.currentFilter == filter,
                        onSelected: (selected) {
                          if (selected) {
                            taskProvider.applyFilter(filter);
                          }
                        },
                        showCheckmark: false,
                        disabledColor: Colors.white,
                        backgroundColor: Colors.white,

                        selectedColor: Theme.of(context).colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color: taskProvider.currentFilter == filter
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DropdownButtonFormField<TaskSortOption>(
                      value: taskProvider.currentSort,
                      decoration: TaskInputDecorators.taskSort,
                      items: TaskSortOption.values.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(_getSortLabel(option)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          taskProvider.applySorting(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  String _getFilterLabel(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return 'Wszystkie';
      case TaskFilter.active:
        return 'Aktywne';
      case TaskFilter.completed:
        return 'Ukończone';
      case TaskFilter.highPriority:
        return 'Wysoki priorytet';
    }
  }
  
  String _getSortLabel(TaskSortOption option) {
    switch (option) {
      case TaskSortOption.deadline:
        return 'Termin';
      case TaskSortOption.priority:
        return 'Priorytet';
      case TaskSortOption.title:
        return 'Nazwa';
      case TaskSortOption.createdAt:
        return 'Daty utworzenia';
    }
  }
}
