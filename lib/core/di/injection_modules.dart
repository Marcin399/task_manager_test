import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import '../storage/database_helper.dart';
import '../storage/local_storage.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  DatabaseHelper get databaseHelper => DatabaseHelper();
  
  @lazySingleton
  LocalStorage get localStorage => LocalStorageImpl();
  
  @lazySingleton
  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin => 
      FlutterLocalNotificationsPlugin();
}
