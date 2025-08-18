import 'package:injectable/injectable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart' as permission;
import '../../domain/entities/task_entity.dart';
import '../../core/storage/local_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';

abstract class NotificationLocalDataSource {
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<bool> checkPermissions();
  Future<bool> openAppSettings();
  Future<void> scheduleTaskReminder(TaskEntity task);
  Future<void> cancelTaskReminder(String taskId);
  Future<void> cancelAllReminders();
  Future<void> updateDefaultReminderTime(int minutes);
  Future<int> getDefaultReminderTime();
  Future<void> rescheduleAllReminders(List<TaskEntity> tasks);
  Future<List<String>> getPendingNotifications();
  Future<void> enableNotifications();
  Future<void> disableNotifications();
  Future<bool> areNotificationsEnabled();
}

@LazySingleton(as: NotificationLocalDataSource)
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final LocalStorage _localStorage;
  
  NotificationLocalDataSourceImpl(this._flutterLocalNotificationsPlugin, this._localStorage);
  
  @override
  Future<void> initialize() async {
    try {
      Logger.info('Inicjalizacja systemu powiadomień...', tag: 'Notifications');
      
      const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const iosInitializationSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: null,
      );
      
      const initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
        macOS: iosInitializationSettings,
      );
      
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      
      Logger.info('Wtyczka powiadomień zainicjowana', tag: 'Notifications');
      
      await _createNotificationChannel();
      
      Logger.info('Inicjalizacja systemu powiadomień zakończona', tag: 'Notifications');
    } catch (e) {
      Logger.error('Błąd inicjalizacji powiadomień', error: e, tag: 'Notifications');
      throw AppException('Błąd podczas inicjalizacji powiadomień: ${e.toString()}');
    }
  }
  
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    Logger.info('Notification tapped: ${notificationResponse.payload}', tag: 'Notifications');
  }
  
  Future<void> _createNotificationChannel() async {
    const androidNotificationChannel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDescription,
      importance: Importance.high,
      playSound: true,
    );
    
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }
  
  @override
  Future<bool> requestPermissions() async {
    try {
      Logger.info('Rozpoczynanie procesu żądania uprawnień...', tag: 'Notifications');
      
      final iosImpl = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final macosImpl = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
      
      bool hasPermission = false;
      
      if (iosImpl != null) {
        Logger.debug('Żądanie uprawnień iOS...', tag: 'Notifications');
        final iosPermission = await iosImpl.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        hasPermission = iosPermission ?? false;
        Logger.info('Uprawnienia iOS przyznane: $hasPermission', tag: 'Notifications');
      } else if (macosImpl != null) {
        Logger.debug('Żądanie uprawnień macOS...', tag: 'Notifications');
        final macosPermission = await macosImpl.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        hasPermission = macosPermission ?? false;
        Logger.info('Uprawnienia macOS przyznane: $hasPermission', tag: 'Notifications');
      } else {
        Logger.debug('Żądanie uprawnień Android...', tag: 'Notifications');
        final status = await permission.Permission.notification.request();
        hasPermission = status.isGranted;
        Logger.info('Uprawnienia Android przyznane: $hasPermission', tag: 'Notifications');
      }
      
      final actualStatus = await _getActualPermissionStatus();
      final finalResult = hasPermission || actualStatus;
      
      Logger.info('Końcowy wynik uprawnień: $finalResult', tag: 'Notifications');
      
      await _localStorage.setBool(AppConstants.keyNotificationEnabled, finalResult);
      
      return finalResult;
    } catch (e) {
      Logger.error('Błąd podczas żądania uprawnień', error: e, tag: 'Notifications');
      throw AppException('Błąd podczas żądania uprawnień: ${e.toString()}');
    }
  }
  
    @override
  Future<bool> checkPermissions() async {
    try {
      return await _getActualPermissionStatus();
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _getActualPermissionStatus() async {
    try {
      final iosImpl = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final macosImpl = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
      
      if (iosImpl != null) {
        try {
          Logger.debug('Sprawdzanie uprawnień iOS...', tag: 'Notifications');
          final iosSettings = await iosImpl.checkPermissions();
          final hasPermission = iosSettings?.isAlertEnabled == true || 
                               iosSettings?.isBadgeEnabled == true || 
                               iosSettings?.isSoundEnabled == true;
          Logger.verbose('iOS uprawnienia: alert=${iosSettings?.isAlertEnabled}, badge=${iosSettings?.isBadgeEnabled}, sound=${iosSettings?.isSoundEnabled}', tag: 'Notifications');
          Logger.info('Końcowy wynik: $hasPermission', tag: 'Notifications');
          return hasPermission;
        } catch (e) {
          Logger.error('Błąd sprawdzania uprawnień iOS', error: e, tag: 'Notifications');
          return false;
        }
      } else if (macosImpl != null) {
        try {
          Logger.debug('Sprawdzanie uprawnień macOS...', tag: 'Notifications');
          final macosSettings = await macosImpl.checkPermissions();
          final hasPermission = macosSettings?.isAlertEnabled == true || 
                               macosSettings?.isBadgeEnabled == true || 
                               macosSettings?.isSoundEnabled == true;
          Logger.verbose('macOS uprawnienia: alert=${macosSettings?.isAlertEnabled}, badge=${macosSettings?.isBadgeEnabled}, sound=${macosSettings?.isSoundEnabled}', tag: 'Notifications');
          return hasPermission;
        } catch (e) {
          Logger.error('Błąd sprawdzania uprawnień macOS', error: e, tag: 'Notifications');
          return false;
        }
      } else {
        Logger.debug('Sprawdzanie uprawnień Android...', tag: 'Notifications');
        final notificationStatus = await permission.Permission.notification.status;
        final hasPermission = notificationStatus.isGranted;
        Logger.info('Uprawnienia Android: $hasPermission', tag: 'Notifications');
        return hasPermission;
      }
    } catch (e) {
      Logger.error('Ogólny błąd sprawdzania uprawnień', error: e, tag: 'Notifications');
      return false;
    }
  }

  @override
  Future<bool> openAppSettings() async {
    try {
      Logger.info('Otwieranie ustawień aplikacji...', tag: 'Notifications');
      
      final iosImpl = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      
      bool settingsOpened = false;
      
      if (iosImpl != null) {
        Logger.debug('Ponowne żądanie uprawnień iOS (może otworzyć ustawienia)...', tag: 'Notifications');
        final permissionGranted = await iosImpl.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        
        if (permissionGranted != true) {
          settingsOpened = await permission.openAppSettings();
        } else {
          settingsOpened = true;
        }
      } else {
        settingsOpened = await permission.openAppSettings();
      }
      
      Logger.info('Ustawienia otwarte: $settingsOpened', tag: 'Notifications');
      
      if (settingsOpened) {
        await Future.delayed(const Duration(seconds: 2));
        final hasPermissions = await checkPermissions();
        
        Logger.info('Status uprawnień po powrocie z ustawień: $hasPermissions', tag: 'Notifications');
        
        await _localStorage.setBool(AppConstants.keyNotificationEnabled, hasPermissions);
        
        return hasPermissions;
      }
      
      return false;
    } catch (e) {
      Logger.error('Błąd podczas otwierania ustawień', error: e, tag: 'Notifications');
      throw AppException('Błąd podczas otwierania ustawień: ${e.toString()}');
    }
  }

  @override
  Future<void> scheduleTaskReminder(TaskEntity task) async {
    try {
      Logger.info('Próba zaplanowania przypomnienia dla zadania: ${task.title}', tag: 'Notifications');
      
      if (!task.hasReminder || task.isCompleted) {
        Logger.warning('Zadanie nie ma przypomnienia lub jest ukończone', tag: 'Notifications');
        return;
      }
      
      final reminderTime = task.reminderTime!;
      Logger.debug('Czas przypomnienia: $reminderTime', tag: 'Notifications');
      
      if (reminderTime.isBefore(DateTime.now())) {
        Logger.warning('Czas przypomnienia jest w przeszłości', tag: 'Notifications');
        return;
      }
      
      final notificationId = _getNotificationId(task.id);
      Logger.debug('ID powiadomienia: $notificationId', tag: 'Notifications');
      
      const androidDetails = AndroidNotificationDetails(
        AppConstants.notificationChannelId,
        AppConstants.notificationChannelName,
        channelDescription: AppConstants.notificationChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );
      
      final scheduledDate = tz.TZDateTime.from(reminderTime, tz.local);
      
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Przypomnienie o zadaniu',
        task.title,
        scheduledDate,
        notificationDetails,
        payload: task.id,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      
      Logger.info('Przypomnienie zostało zaplanowane na: $scheduledDate', tag: 'Notifications');
    } catch (e) {
      Logger.error('Błąd podczas planowania przypomnienia', error: e, tag: 'Notifications');
      throw AppException('Błąd podczas planowania przypomnienia: ${e.toString()}');
    }
  }
  
  @override
  Future<void> cancelTaskReminder(String taskId) async {
    try {
      final notificationId = _getNotificationId(taskId);
      await _flutterLocalNotificationsPlugin.cancel(notificationId);
    } catch (e) {
      throw AppException('Błąd podczas anulowania przypomnienia: ${e.toString()}');
    }
  }
  
  @override
  Future<void> cancelAllReminders() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      throw AppException('Błąd podczas anulowania wszystkich przypomnień: ${e.toString()}');
    }
  }
  
  @override
  Future<void> updateDefaultReminderTime(int minutes) async {
    try {
      await _localStorage.setInt(AppConstants.keyDefaultReminderTime, minutes);
    } catch (e) {
      throw AppException('Błąd podczas aktualizacji domyślnego czasu przypomnienia: ${e.toString()}');
    }
  }
  
  @override
  Future<int> getDefaultReminderTime() async {
    try {
      final reminderTime = await _localStorage.getInt(AppConstants.keyDefaultReminderTime);
      return reminderTime ?? AppConstants.defaultReminderMinutes;
    } catch (e) {
      return AppConstants.defaultReminderMinutes;
    }
  }
  
  @override
  Future<void> rescheduleAllReminders(List<TaskEntity> tasks) async {
    try {
      await cancelAllReminders();
      
      for (final task in tasks) {
        if (task.hasReminder && !task.isCompleted) {
          await scheduleTaskReminder(task);
        }
      }
    } catch (e) {
      throw AppException('Błąd podczas ponownego planowania przypomnień: ${e.toString()}');
    }
  }
  
  @override
  Future<List<String>> getPendingNotifications() async {
    try {
      final pendingRequests = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
      return pendingRequests
          .map((request) => request.payload ?? '')
          .where((payload) => payload.isNotEmpty)
          .toList();
    } catch (e) {
      throw AppException('Błąd podczas pobierania oczekujących powiadomień: ${e.toString()}');
    }
  }
  
  @override
  Future<void> enableNotifications() async {
    try {
      await _localStorage.setBool(AppConstants.keyNotificationEnabled, true);
    } catch (e) {
      throw AppException('Błąd podczas włączania powiadomień: ${e.toString()}');
    }
  }
  
  @override
  Future<void> disableNotifications() async {
    try {
      await _localStorage.setBool(AppConstants.keyNotificationEnabled, false);
      await cancelAllReminders();
    } catch (e) {
      throw AppException('Błąd podczas wyłączania powiadomień: ${e.toString()}');
    }
  }
  
  @override
  Future<bool> areNotificationsEnabled() async {
    try {
      final isEnabled = await _localStorage.getBool(AppConstants.keyNotificationEnabled);
      return isEnabled ?? false;
    } catch (e) {
      return false;
    }
  }
  
  int _getNotificationId(String taskId) {
    return taskId.hashCode & 0x7FFFFFFF; 
  }
}
