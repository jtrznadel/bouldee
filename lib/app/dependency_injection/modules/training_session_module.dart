import 'package:bouldee/features/training_session/data/data_sources/training_session_local_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

@module
abstract class TrainingSessionModule {
  @preResolve
  @singleton
  Future<Database> get database async {
    final impl = TrainingSessionLocalDataSourceImpl();
    return impl.database;
  }
}
