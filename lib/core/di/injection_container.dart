import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection_container.config.dart';
import '../storage/database_helper.dart';
import '../storage/database_factory_setup.dart';
import '../utils/logger.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();

// Setup all dependencies
Future<void> setupDependencies() async {
  Logger.info('Konfigurowanie zależności...', tag: 'DI');
  
  // Setup platform-specific database factory
  setupDatabaseFactory();
  
  await configureDependencies();
  Logger.info('Zależności skonfigurowane', tag: 'DI');
  
  // Initialize database
  Logger.info('Inicjalizacja bazy danych...', tag: 'DI');
  try {
    final databaseHelper = getIt<DatabaseHelper>();
    final db = await databaseHelper.database; // This will trigger database initialization
    Logger.info('Baza danych zainicjalizowana: ${db.path}', tag: 'DI');
  } catch (e) {
    Logger.warning('Inicjalizacja bazy danych nie powiodła się (prawdopodobnie platforma Web): $e', tag: 'DI');
    Logger.info('Kontynuowanie z alternatywnym magazynem...', tag: 'DI');
  }
  
  // Dependencies are automatically registered via @injectable annotations
  // Additional manual registrations can be added here if needed
  Logger.info('Aplikacja gotowa do uruchomienia!', tag: 'DI');
}
