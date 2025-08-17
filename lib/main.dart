import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/injection_container.dart';
import 'core/constants/app_constants.dart';
import 'features/tasks/presentation/providers/task_provider.dart';
import 'features/statistics/presentation/providers/statistics_provider.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';
import 'features/tasks/presentation/pages/task_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  tz.initializeTimeZones();
  await initializeDateFormatting('pl_PL', null);
  await setupDependencies();
  
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>(
          create: (context) => getIt<TaskProvider>()..initialize(),
        ),
        ChangeNotifierProvider<StatisticsProvider>(
          create: (context) => getIt<StatisticsProvider>()..initialize(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (context) => getIt<NotificationProvider>()..initialize(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: _buildTheme(),
        home: const TaskHomePage(),
        debugShowCheckedModeBanner: false,
        locale: const Locale('pl', 'PL'),
        supportedLocales: const [
          Locale('pl', 'PL'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color.fromARGB(255, 238, 251, 255),
      colorScheme: ColorScheme.fromSeed(
        primaryContainer: const Color.fromARGB(255, 151, 149, 255),
        primary: const Color.fromARGB(255, 122, 120, 255),
        seedColor: const Color.fromARGB(255, 38, 0, 255),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 238, 251, 255),
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
        filled: true,
      ),
    );
  }
}
