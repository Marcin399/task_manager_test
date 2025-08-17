class AppConstants {
  // App Info
  static const String appName = 'Task Manager';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'task_manager.db';
  static const int databaseVersion = 1;
  
  // Storage Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationEnabled = 'notification_enabled';
  static const String keyDefaultReminderTime = 'default_reminder_time';
  
  // Notifications
  static const String notificationChannelId = 'task_reminders';
  static const String notificationChannelName = 'Task Reminders';
  static const String notificationChannelDescription = 'Notifications for task deadlines';
  static const int defaultReminderMinutes = 60; // 1 hour before
  
  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Validation
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
}
