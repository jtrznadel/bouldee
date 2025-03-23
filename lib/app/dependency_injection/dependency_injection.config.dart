// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bouldee/app/dependency_injection/app_module.dart' as _i511;
import 'package:bouldee/app/routing/app_router.dart' as _i78;
import 'package:bouldee/features/auth/data/auth_repository.dart' as _i551;
import 'package:bouldee/features/auth/presentation/bloc/auth_bloc.dart' as _i30;
import 'package:bouldee/features/auth/presentation/bloc/sign_in/bloc/sign_in_bloc.dart'
    as _i714;
import 'package:bouldee/features/auth/presentation/bloc/sign_up/bloc/sign_up_bloc.dart'
    as _i153;
import 'package:bouldee/features/auth/repository/auth_repository.dart' as _i818;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i454.GoTrueClient>(() => appModule.supabaseAuth);
    gh.singleton<_i78.AppRouter>(() => appModule.router);
    gh.factory<_i818.IAuthRepository>(
        () => _i551.AuthRepository(gh<_i454.GoTrueClient>()));
    gh.factory<_i714.SignInBloc>(
        () => _i714.SignInBloc(gh<_i818.IAuthRepository>()));
    gh.factory<_i153.SignUpBloc>(
        () => _i153.SignUpBloc(gh<_i818.IAuthRepository>()));
    gh.singleton<_i30.AuthBloc>(
        () => _i30.AuthBloc(gh<_i818.IAuthRepository>()));
    return this;
  }
}

class _$AppModule extends _i511.AppModule {}
