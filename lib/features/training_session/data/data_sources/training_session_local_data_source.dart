import 'package:bouldee/features/training_session/data/models/training_session_model.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class TrainingSessionLocalDataSource {
  Future<TrainingSessionModel?> getActiveSession();
  Future<void> cacheSession(TrainingSessionModel session);
  Future<void> deleteSession(String sessionId);
  Future<List<TrainingSessionModel>> getPendingSyncSessions();
  Future<TrainingSessionModel> getSessionById(String sessionId);
}

@Injectable(as: TrainingSessionLocalDataSource)
class TrainingSessionLocalDataSourceImpl
    implements TrainingSessionLocalDataSource {
  static Database? _database;
  static const String _dbName = 'bouldee.db';
  static const int _dbVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        start_time TEXT NOT NULL,
        end_time TEXT,
        is_active INTEGER DEFAULT 0,
        device_id TEXT,
        pending_sync INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE session_boulders (
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        boulder_id TEXT NOT NULL,
        status TEXT NOT NULL,
        attempts INTEGER DEFAULT 1,
        notes TEXT,
        created_at TEXT NOT NULL,
        pending_sync INTEGER DEFAULT 0,
        FOREIGN KEY (session_id) REFERENCES sessions (id) ON DELETE CASCADE
      )
    ''');
  }

  @override
  Future<TrainingSessionModel?> getActiveSession() async {
    final db = await database;

    try {
      final sessionResults = await db.query(
        'sessions',
        where: 'is_active = ?',
        whereArgs: [1],
        orderBy: 'start_time DESC',
        limit: 1,
      );

      if (sessionResults.isEmpty) {
        return null;
      }

      final session = TrainingSessionModel.fromMap(sessionResults.first);

      final boulderResults = await db.query(
        'session_boulders',
        where: 'session_id = ?',
        whereArgs: [session.id],
      );

      final boulders = boulderResults.map(BoulderModel.fromMap).toList();

      return TrainingSessionModel(
        id: session.id,
        startTime: session.startTime,
        endTime: session.endTime,
        isActive: session.isActive,
        deviceId: session.deviceId,
        pendingSync: session.pendingSync,
        boulders: boulders,
      );
    } catch (e) {
      throw Exception('Failed to get active session: $e');
    }
  }

  @override
  Future<void> cacheSession(TrainingSessionModel session) async {
    final db = await database;

    try {
      await db.transaction((txn) async {
        await txn.insert(
          'sessions',
          session.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        await txn.delete(
          'session_boulders',
          where: 'session_id = ?',
          whereArgs: [session.id],
        );

        for (final boulder in session.boulders) {
          final boulderModel = boulder as BoulderModel;
          await txn.insert(
            'session_boulders',
            boulderModel.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      throw Exception('Failed to cache session: $e');
    }
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    final db = await database;

    try {
      await db.transaction((txn) async {
        await txn.delete(
          'session_boulders',
          where: 'session_id = ?',
          whereArgs: [sessionId],
        );

        await txn.delete(
          'sessions',
          where: 'id = ?',
          whereArgs: [sessionId],
        );
      });
    } catch (e) {
      throw Exception('Failed to delete session: $e');
    }
  }

  @override
  Future<List<TrainingSessionModel>> getPendingSyncSessions() async {
    final db = await database;

    try {
      final sessionResults = await db.query(
        'sessions',
        where: 'pending_sync = ?',
        whereArgs: [1],
      );

      if (sessionResults.isEmpty) {
        return [];
      }

      final sessions = <TrainingSessionModel>[];

      for (final sessionMap in sessionResults) {
        final session = TrainingSessionModel.fromMap(sessionMap);

        final boulderResults = await db.query(
          'session_boulders',
          where: 'session_id = ?',
          whereArgs: [session.id],
        );

        final boulders = boulderResults.map(BoulderModel.fromMap).toList();

        sessions.add(
          TrainingSessionModel(
            id: session.id,
            startTime: session.startTime,
            endTime: session.endTime,
            isActive: session.isActive,
            deviceId: session.deviceId,
            pendingSync: session.pendingSync,
            boulders: boulders,
          ),
        );
      }

      return sessions;
    } catch (e) {
      throw Exception('Failed to get pending sync sessions: $e');
    }
  }

  @override
  Future<TrainingSessionModel> getSessionById(String sessionId) async {
    final db = await database;

    try {
      final sessionResults = await db.query(
        'sessions',
        where: 'id = ?',
        whereArgs: [sessionId],
      );

      if (sessionResults.isEmpty) {
        throw Exception('Session not found');
      }

      final session = TrainingSessionModel.fromMap(sessionResults.first);

      final boulderResults = await db.query(
        'session_boulders',
        where: 'session_id = ?',
        whereArgs: [session.id],
      );

      final boulders = boulderResults.map(BoulderModel.fromMap).toList();

      return TrainingSessionModel(
        id: session.id,
        startTime: session.startTime,
        endTime: session.endTime,
        isActive: session.isActive,
        deviceId: session.deviceId,
        pendingSync: session.pendingSync,
        boulders: boulders,
      );
    } catch (e) {
      throw Exception('Failed to get session by id: $e');
    }
  }
}
