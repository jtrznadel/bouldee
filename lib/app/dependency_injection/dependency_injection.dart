import 'package:bouldee/app/dependency_injection/dependency_injection.config.dart';
import 'package:bouldee/app/routing/app_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

@module
abstract class AppModule {
  @singleton
  GoTrueClient get supabaseAuth => Supabase.instance.client.auth;

  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @singleton
  AppRouter get router => AppRouter();

  @singleton
  Connectivity get connectivity => Connectivity();
}
