import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/input_decorators.dart';

class AddTaskPage extends StatefulWidget {
  final TaskEntity? taskToEdit;
  
  const AddTaskPage({
    super.key,
    this.taskToEdit,
  });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime _selectedDeadline = DateTime.now().add(const Duration(hours: 1));
  TaskPriority _selectedPriority = TaskPriority.medium;
  int? _selectedReminderMinutes;
  
  bool get _isEditing => widget.taskToEdit != null;
  
  @override
  void initState() {
    super.initState();
    
    if (_isEditing) {
      final task = widget.taskToEdit!;
      _titleController.text = task.title;
      _descriptionController.text = task.description ?? '';
      _selectedDeadline = task.deadline;
      _selectedPriority = task.priority;
      _selectedReminderMinutes = task.reminderMinutes;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notificationProvider = context.read<NotificationProvider>();
        setState(() {
          _selectedReminderMinutes = notificationProvider.defaultReminderTime;
        });
      });
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edytuj zadanie' : 'Nowe zadanie'),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: const Text('Zapisz'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: TaskInputDecorators.taskTitle,
              textInputAction: TextInputAction.next,
              maxLength: AppConstants.maxTitleLength,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tytuł zadania jest wymagany';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              decoration: TaskInputDecorators.taskDescription,
              maxLines: 3,
              maxLength: AppConstants.maxDescriptionLength,
              textInputAction: TextInputAction.newline,
            ),
            
            const SizedBox(height: 24),
            
            Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Termin wykonania',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Data'),
                      subtitle: Text(DateFormat('EEEE, dd MMMM yyyy', 'pl_PL')
                          .format(_selectedDeadline)),
                      onTap: _selectDate,
                      contentPadding: EdgeInsets.zero,
                    ),
                    
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Godzina'),
                      subtitle: Text(DateFormat('HH:mm').format(_selectedDeadline)),
                      onTap: _selectTime,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priorytet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    
                    DropdownButtonFormField<TaskPriority>(
                      value: _selectedPriority,
                      decoration: TaskInputDecorators.taskPriority,
                      items: TaskPriority.values.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: _buildPriorityOption(priority),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Przypomnienie',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        
                        if (!notificationProvider.hasPermissions) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Brak uprawnień do powiadomień',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final granted = await notificationProvider.requestPermissions();
                                    if (!granted) {
                                      if (context.mounted) {
                                        final shouldOpenSettings = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Uprawnienia do powiadomień'),
                                            content: const Text(
                                              'Aby otrzymywać przypomnienia o zadaniach, '
                                              'musisz włączyć uprawnienia do powiadomień.\n\n'
                                              'Na iOS: Ustawienia > Ta aplikacja > Powiadomienia\n'
                                              'Na Androidzie: Ustawienia aplikacji > Powiadomienia',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: const Text('Anuluj'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(true),
                                                child: const Text('Otwórz ustawienia'),
                                              ),
                                            ],
                                          ),
                                        );
                                        
                                        if (shouldOpenSettings == true) {
                                          await notificationProvider.openAppSettings();
                                        }
                                      }
                                    }
                                  },
                                  child: const Text('Udziel'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        
                        DropdownButtonFormField<int?>(
                          value: _selectedReminderMinutes,
                          decoration: TaskInputDecorators.taskReminder,
                          items: notificationProvider.getReminderTimeOptions()
                              .map((option) => DropdownMenuItem<int?>(
                            value: option.minutes == 0 ? null : option.minutes,
                            child: Text(option.displayText),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedReminderMinutes = value;
                            });
                          },
                        ),
                        
                        if (_selectedReminderMinutes != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Przypomnienie: ${_getReminderText()}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            FilledButton(
              onPressed: _saveTask,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  _isEditing ? 'Zaktualizuj zadanie' : 'Utwórz zadanie',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPriorityOption(TaskPriority priority) {
    Color color;
    String label;
    
    switch (priority) {
      case TaskPriority.low:
        color = Colors.green;
        label = 'Niski';
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        label = 'Średni';
        break;
      case TaskPriority.high:
        color = Colors.red;
        label = 'Wysoki';
        break;
      case TaskPriority.urgent:
        color = Colors.purple;
        label = 'Pilne';
        break;
    }
    
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
  
  String _getReminderText() {
    if (_selectedReminderMinutes == null) return '';
    
    final reminderTime = _selectedDeadline.subtract(
      Duration(minutes: _selectedReminderMinutes!),
    );
    
    return DateFormat('dd.MM.yyyy HH:mm').format(reminderTime);
  }
  
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDeadline = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDeadline.hour,
          _selectedDeadline.minute,
        );
      });
    }
  }
  
  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDeadline = DateTime(
          _selectedDeadline.year,
          _selectedDeadline.month,
          _selectedDeadline.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }
  
  void _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedDeadline.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Termin wykonania nie może być w przeszłości'),
        ),
      );
      return;
    }
    
    final taskProvider = context.read<TaskProvider>();
    
    try {
      if (_isEditing) {
        final updatedTask = widget.taskToEdit!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty 
              ? null 
              : _descriptionController.text.trim(),
          deadline: _selectedDeadline,
          priority: _selectedPriority,
          reminderMinutes: _selectedReminderMinutes,
          updatedAt: DateTime.now(),
        );
        
        await taskProvider.updateTask(updatedTask);
      } else {
        await taskProvider.createTask(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty 
              ? null 
              : _descriptionController.text.trim(),
          deadline: _selectedDeadline,
          priority: _selectedPriority,
          reminderMinutes: _selectedReminderMinutes,
        );
      }
      
      if (mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing 
                  ? 'Zadanie zostało zaktualizowane'
                  : 'Zadanie zostało utworzone',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
