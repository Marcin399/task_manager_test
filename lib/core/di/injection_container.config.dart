// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/datasources/notification_local_datasource.dart' as _i701;
import '../../data/datasources/task_local_datasource.dart' as _i479;
import '../../data/repositories/notification_repository_impl.dart' as _i950;
import '../../data/repositories/task_repository_impl.dart' as _i337;
import '../../domain/repositories/notification_repository.dart' as _i1060;
import '../../domain/repositories/task_repository.dart' as _i250;
import '../../domain/usecases/notification_usecases.dart' as _i166;
import '../../domain/usecases/task_usecases.dart' as _i209;
import '../../features/notifications/presentation/providers/notification_provider.dart'
    as _i918;
import '../../features/statistics/presentation/providers/statistics_provider.dart'
    as _i743;
import '../../features/tasks/presentation/providers/task_provider.dart'
    as _i578;
import '../storage/database_helper.dart' as _i386;
import '../storage/local_storage.dart' as _i329;
import 'injection_modules.dart' as _i835;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i386.DatabaseHelper>(() => registerModule.databaseHelper);
    gh.lazySingleton<_i329.LocalStorage>(() => registerModule.localStorage);
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
      () => registerModule.flutterLocalNotificationsPlugin,
    );
    gh.lazySingleton<_i479.TaskLocalDataSource>(
      () => _i479.TaskLocalDataSourceImpl(gh<_i386.DatabaseHelper>()),
    );
    gh.lazySingleton<_i250.TaskRepository>(
      () => _i337.TaskRepositoryImpl(gh<_i479.TaskLocalDataSource>()),
    );
    gh.lazySingleton<_i701.NotificationLocalDataSource>(
      () => _i701.NotificationLocalDataSourceImpl(
        gh<_i163.FlutterLocalNotificationsPlugin>(),
        gh<_i329.LocalStorage>(),
      ),
    );
    gh.lazySingleton<_i1060.NotificationRepository>(
      () => _i950.NotificationRepositoryImpl(
        gh<_i701.NotificationLocalDataSource>(),
      ),
    );
    gh.factory<_i166.NotificationUseCases>(
      () => _i166.NotificationUseCases(
        gh<_i1060.NotificationRepository>(),
        gh<_i250.TaskRepository>(),
      ),
    );
    gh.factory<_i918.NotificationProvider>(
      () => _i918.NotificationProvider(gh<_i166.NotificationUseCases>()),
    );
    gh.factory<_i209.TaskUseCases>(
      () => _i209.TaskUseCases(
        gh<_i250.TaskRepository>(),
        gh<_i1060.NotificationRepository>(),
      ),
    );
    gh.factory<_i743.StatisticsProvider>(
      () => _i743.StatisticsProvider(gh<_i209.TaskUseCases>()),
    );
    gh.factory<_i578.TaskProvider>(
      () => _i578.TaskProvider(
        gh<_i209.TaskUseCases>(),
        gh<_i166.NotificationUseCases>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i835.RegisterModule {}
