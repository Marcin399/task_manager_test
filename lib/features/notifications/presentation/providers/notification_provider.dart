import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/usecases/notification_usecases.dart';
import '../../../../core/constants/app_constants.dart';

@injectable
class NotificationProvider extends ChangeNotifier {
  final NotificationUseCases _notificationUseCases;
  
  NotificationProvider(this._notificationUseCases);
  
  bool _areNotificationsEnabled = false;
  bool _hasPermissions = false;
  int _defaultReminderTime = AppConstants.defaultReminderMinutes;
  List<String> _pendingNotifications = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;
  
  bool get areNotificationsEnabled => _areNotificationsEnabled;
  bool get hasPermissions => _hasPermissions;
  int get defaultReminderTime => _defaultReminderTime;
  List<String> get pendingNotifications => _pendingNotifications;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isInitialized => _isInitialized;
  int get pendingNotificationsCount => _pendingNotifications.length;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      final initResult = await _notificationUseCases.initializeNotifications();
      
      await initResult.when(
        success: (_) async {
          await _loadSettings();
          _isInitialized = true;
        },
        failure: (failure) {
          _setError('Błąd podczas inicjalizacji powiadomień: ${failure.toString()}');
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadSettings() async {
    try {
      final permissionResult = await _notificationUseCases.checkNotificationPermissions();
      permissionResult.when(
        success: (hasPermissions) => _hasPermissions = hasPermissions,
        failure: (_) => _hasPermissions = false,
      );
      
      final enabledResult = await _notificationUseCases.areNotificationsEnabled();
      enabledResult.when(
        success: (enabled) => _areNotificationsEnabled = enabled,
        failure: (_) => _areNotificationsEnabled = false,
      );
      
      final reminderResult = await _notificationUseCases.getDefaultReminderTime();
      reminderResult.when(
        success: (time) => _defaultReminderTime = time,
        failure: (_) => _defaultReminderTime = AppConstants.defaultReminderMinutes,
      );
      
      await _loadPendingNotifications();
      
      notifyListeners();
    } catch (e) {
      _setError('Błąd podczas ładowania ustawień: ${e.toString()}');
    }
  }
  
  Future<void> _loadPendingNotifications() async {
    try {
      final result = await _notificationUseCases.getPendingNotifications();
      result.when(
        success: (notifications) {
          _pendingNotifications = notifications;
        },
        failure: (_) {
          _pendingNotifications = [];
        },
      );
    } catch (e) {
      _pendingNotifications = [];
    }
  }
  
  Future<bool> requestPermissions() async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _notificationUseCases.requestNotificationPermissions();
      
      return result.when(
        success: (hasPermissions) {
          _hasPermissions = hasPermissions;
          notifyListeners();
          return hasPermissions;
        },
        failure: (failure) {
          _setError('Błąd podczas żądania uprawnień: ${failure.toString()}');
          return false;
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> openAppSettings() async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _notificationUseCases.openAppSettings();
      
      return result.when(
        success: (opened) async {
          if (opened) {
            await Future.delayed(const Duration(milliseconds: 1500));
            await refresh();
          }
          return opened;
        },
        failure: (failure) {
          _setError('Błąd podczas otwierania ustawień: ${failure.toString()}');
          return false;
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> enableNotifications() async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _notificationUseCases.enableNotifications();
      
      result.when(
        success: (_) {
          _areNotificationsEnabled = true;
          notifyListeners();
        },
        failure: (failure) {
          _setError('Błąd podczas włączania powiadomień: ${failure.toString()}');
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> disableNotifications() async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _notificationUseCases.disableNotifications();
      
      result.when(
        success: (_) {
          _areNotificationsEnabled = false;
          _pendingNotifications.clear();
          notifyListeners();
        },
        failure: (failure) {
          _setError('Błąd podczas wyłączania powiadomień: ${failure.toString()}');
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> toggleNotifications() async {
    if (_areNotificationsEnabled) {
      await disableNotifications();
    } else {
      await refresh();
      
      if (!_hasPermissions) {
        final granted = await requestPermissions();
        if (!granted) {
          _setError('Brak uprawnień do powiadomień. Otwórz ustawienia aby je włączyć.');
          return;
        }
      }
      await enableNotifications();
    }
  }
  
  Future<void> setDefaultReminderTime(int minutes) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _notificationUseCases.setDefaultReminderTime(minutes);
      
      result.when(
        success: (_) {
          _defaultReminderTime = minutes;
          notifyListeners();
        },
        failure: (failure) {
          _setError('Błąd podczas ustawiania domyślnego czasu przypomnienia: ${failure.toString()}');
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> rescheduleAllReminders() async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _notificationUseCases.rescheduleAllReminders();
      
      result.when(
        success: (_) async {
          await _loadPendingNotifications();
          notifyListeners();
        },
        failure: (failure) {
          _setError('Błąd podczas ponownego planowania przypomnień: ${failure.toString()}');
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> clearAllNotifications() async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _notificationUseCases.clearAllNotifications();
      
      result.when(
        success: (_) {
          _pendingNotifications.clear();
          notifyListeners();
        },
        failure: (failure) {
          _setError('Błąd podczas czyszczenia powiadomień: ${failure.toString()}');
        },
      );
    } catch (e) {
      _setError('Nieoczekiwany błąd: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> refresh() async {
    await _loadSettings();
  }
  
  void clearError() {
    _clearError();
    notifyListeners();
  }
  
  List<ReminderTimeOption> getReminderTimeOptions() {
    return [
      ReminderTimeOption(0, 'Brak przypomnienia'),
      ReminderTimeOption(15, '15 minut przed'),
      ReminderTimeOption(30, '30 minut przed'),
      ReminderTimeOption(60, '1 godzina przed'),
      ReminderTimeOption(120, '2 godziny przed'),
      ReminderTimeOption(1440, '1 dzień przed'),
    ];
  }

  String getReminderTimeDisplayText(int? minutes) {
    if (minutes == null || minutes == 0) {
      return 'Brak przypomnienia';
    }
    
    if (minutes < 60) {
      return '$minutes minut przed';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      return hours == 1 ? '1 godzina przed' : '$hours godzin przed';
    } else {
      final days = minutes ~/ 1440;
      return days == 1 ? '1 dzień przed' : '$days dni przed';
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
  }
}

class ReminderTimeOption {
  final int minutes;
  final String displayText;
  
  const ReminderTimeOption(this.minutes, this.displayText);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderTimeOption &&
          runtimeType == other.runtimeType &&
          minutes == other.minutes;
  
  @override
  int get hashCode => minutes.hashCode;
}
