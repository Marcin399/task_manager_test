import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

void setupDatabaseFactory() {
  if (kIsWeb) {
    Logger.info('Wykryto platformę web - używanie pamięci w pamięci', tag: 'Database');
    return;
  } else {
    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        (defaultTargetPlatform == TargetPlatform.macOS && !kIsWeb)) {
      Logger.info('Wykryto platformę desktop - inicjalizacja bazy danych FFI', tag: 'Database');
      databaseFactory = databaseFactoryFfi;
    }
  }
}
