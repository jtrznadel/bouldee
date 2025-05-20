// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bouldee/app/dependency_injection/dependency_injection.dart'
    as _i722;
import 'package:bouldee/app/dependency_injection/modules/training_session_module.dart'
    as _i818;
import 'package:bouldee/app/routing/app_router.dart' as _i78;
import 'package:bouldee/features/auth/data/auth_repository.dart' as _i551;
import 'package:bouldee/features/auth/presentation/bloc/auth_bloc.dart' as _i30;
import 'package:bouldee/features/auth/presentation/bloc/sign_in/bloc/sign_in_bloc.dart'
    as _i714;
import 'package:bouldee/features/auth/presentation/bloc/sign_up/bloc/sign_up_bloc.dart'
    as _i153;
import 'package:bouldee/features/auth/repository/auth_repository.dart' as _i818;
import 'package:bouldee/features/boulder_details/data/data_sources/boulder_details_remote_data_source.dart'
    as _i664;
import 'package:bouldee/features/boulder_details/data/repositories/boulder_details_repository_impl.dart'
    as _i504;
import 'package:bouldee/features/boulder_details/domain/repositories/boulder_details_repository.dart'
    as _i461;
import 'package:bouldee/features/boulder_details/domain/usecases/get_boulder_details_usecase.dart'
    as _i653;
import 'package:bouldee/features/boulder_details/presentation/bloc/boulder_details_bloc.dart'
    as _i68;
import 'package:bouldee/features/club_map/data/data_sources/club_map_remote_data_source.dart'
    as _i967;
import 'package:bouldee/features/club_map/data/repositories/club_map_repository_impl.dart'
    as _i54;
import 'package:bouldee/features/club_map/domain/repositories/club_map_repository.dart'
    as _i965;
import 'package:bouldee/features/club_map/domain/usecases/get_club_map_data.dart'
    as _i557;
import 'package:bouldee/features/club_map/presentation/bloc/club_map_bloc.dart'
    as _i587;
import 'package:bouldee/features/training_session/data/data_sources/training_session_local_data_source.dart'
    as _i930;
import 'package:bouldee/features/training_session/data/data_sources/training_session_remote_data_source.dart'
    as _i624;
import 'package:bouldee/features/training_session/data/repositories/training_session_repository_impl.dart'
    as _i376;
import 'package:bouldee/features/training_session/domain/repositories/training_session_repository.dart'
    as _i178;
import 'package:bouldee/features/training_session/domain/usecases/add_boulder_usecase.dart'
    as _i553;
import 'package:bouldee/features/training_session/domain/usecases/end_session_usecase.dart'
    as _i895;
import 'package:bouldee/features/training_session/domain/usecases/get_active_session_usecase.dart'
    as _i130;
import 'package:bouldee/features/training_session/domain/usecases/start_session_usecase.dart'
    as _i301;
import 'package:bouldee/features/training_session/domain/usecases/update_boulder_usecase.dart'
    as _i40;
import 'package:bouldee/features/training_session/presentation/bloc/training_session_bloc.dart'
    as _i827;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sqflite/sqflite.dart' as _i779;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    final trainingSessionModule = _$TrainingSessionModule();
    gh.singleton<_i454.GoTrueClient>(() => appModule.supabaseAuth);
    gh.singleton<_i454.SupabaseClient>(() => appModule.supabaseClient);
    gh.singleton<_i78.AppRouter>(() => appModule.router);
    gh.singleton<_i895.Connectivity>(() => appModule.connectivity);
    await gh.singletonAsync<_i779.Database>(
      () => trainingSessionModule.database,
      preResolve: true,
    );
    gh.factory<_i930.TrainingSessionLocalDataSource>(
        () => _i930.TrainingSessionLocalDataSourceImpl());
    gh.factory<_i664.BoulderDetailsRemoteDataSource>(() =>
        _i664.BoulderDetailsRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i967.ClubMapRemoteDataSource>(
        () => _i967.ClubMapRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i624.TrainingSessionRemoteDataSource>(() =>
        _i624.TrainingSessionRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i461.BoulderDetailsRepository>(() =>
        _i504.BoulderDetailsRepositoryImpl(
            gh<_i664.BoulderDetailsRemoteDataSource>()));
    gh.factory<_i965.ClubMapRepository>(
        () => _i54.ClubMapRepositoryImpl(gh<_i967.ClubMapRemoteDataSource>()));
    gh.factory<_i178.TrainingSessionRepository>(
        () => _i376.TrainingSessionRepositoryImpl(
              gh<_i624.TrainingSessionRemoteDataSource>(),
              gh<_i930.TrainingSessionLocalDataSource>(),
              gh<_i895.Connectivity>(),
            ));
    gh.factory<_i818.IAuthRepository>(
        () => _i551.AuthRepository(gh<_i454.GoTrueClient>()));
    gh.factory<_i714.SignInBloc>(
        () => _i714.SignInBloc(gh<_i818.IAuthRepository>()));
    gh.factory<_i30.AuthBloc>(() => _i30.AuthBloc(gh<_i818.IAuthRepository>()));
    gh.factory<_i153.SignUpBloc>(
        () => _i153.SignUpBloc(gh<_i818.IAuthRepository>()));
    gh.factory<_i40.UpdateBoulderUsecase>(
        () => _i40.UpdateBoulderUsecase(gh<_i178.TrainingSessionRepository>()));
    gh.factory<_i130.GetActiveSessionUsecase>(() =>
        _i130.GetActiveSessionUsecase(gh<_i178.TrainingSessionRepository>()));
    gh.factory<_i301.StartSessionUsecase>(
        () => _i301.StartSessionUsecase(gh<_i178.TrainingSessionRepository>()));
    gh.factory<_i895.EndSessionUsecase>(
        () => _i895.EndSessionUsecase(gh<_i178.TrainingSessionRepository>()));
    gh.factory<_i553.AddBoulderUsecase>(
        () => _i553.AddBoulderUsecase(gh<_i178.TrainingSessionRepository>()));
    gh.factory<_i557.GetClubMapDataUseCase>(
        () => _i557.GetClubMapDataUseCase(gh<_i965.ClubMapRepository>()));
    gh.factory<_i653.GetBoulderDetailsUsecase>(() =>
        _i653.GetBoulderDetailsUsecase(gh<_i461.BoulderDetailsRepository>()));
    gh.factory<_i827.TrainingSessionBloc>(() => _i827.TrainingSessionBloc(
          gh<_i301.StartSessionUsecase>(),
          gh<_i895.EndSessionUsecase>(),
          gh<_i553.AddBoulderUsecase>(),
          gh<_i40.UpdateBoulderUsecase>(),
          gh<_i130.GetActiveSessionUsecase>(),
        ));
    gh.factory<_i587.ClubMapBloc>(
        () => _i587.ClubMapBloc(gh<_i557.GetClubMapDataUseCase>()));
    gh.factory<_i68.BoulderDetailsBloc>(
        () => _i68.BoulderDetailsBloc(gh<_i653.GetBoulderDetailsUsecase>()));
    return this;
  }
}

class _$AppModule extends _i722.AppModule {}

class _$TrainingSessionModule extends _i818.TrainingSessionModule {}
