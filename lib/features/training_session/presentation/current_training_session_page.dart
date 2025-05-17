import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/features/training_session/domain/entities/training_session_entity.dart';
import 'package:bouldee/features/training_session/presentation/bloc/training_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class CurrentTrainingSessionPage extends StatefulWidget {
  const CurrentTrainingSessionPage({super.key});

  @override
  State<CurrentTrainingSessionPage> createState() =>
      _CurrentTrainingSessionPageState();
}

class _CurrentTrainingSessionPageState extends State<CurrentTrainingSessionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isShowingStats = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    _scrollController.addListener(() {
      if (_scrollController.offset > 80 && !_isShowingStats) {
        setState(() {
          _isShowingStats = true;
        });
      } else if (_scrollController.offset <= 80 && _isShowingStats) {
        setState(() {
          _isShowingStats = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDuration(DateTime startTime) {
    final now = DateTime.now().toUtc();
    final utcStartTime = startTime.isUtc ? startTime : startTime.toUtc();

    final duration = now.difference(utcStartTime);

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<TrainingSessionBloc>()..add(const LoadActiveSessionEvent()),
      child: BlocConsumer<TrainingSessionBloc, TrainingSessionState>(
        listener: (context, state) {
          if (state is TrainingSessionInactive) {
            context.router.maybePop();
          }

          if (state is TrainingSessionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TrainingSessionLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is TrainingSessionActive) {
            final session = state.session;
            return _buildActiveSessionUI(context, session);
          }

          return const Scaffold(
            body: Center(
              child: Text('Nie znaleziono aktywnej sesji'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveSessionUI(
    BuildContext context,
    TrainingSessionEntity session,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: AppColors.background,
              pinned: true,
              expandedHeight: 180,
              title: _isShowingStats
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Aktywna Sesja',
                          style: context.textTheme.titleLarge?.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.timer,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDuration(session.startTime),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Aktywna Sesja',
                      style: context.textTheme.titleLarge?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => _showEndSessionDialog(context, session.id),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: _buildSessionStatsCard(session),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: ColoredBox(
                  color: AppColors.background,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    tabs: const [
                      Tab(text: 'PROBLEMY'),
                      Tab(text: 'STATYSTYKI'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProblemsTab(session),
            _buildAnalysisTab(session),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(
          LucideIcons.scanQrCode,
          color: AppColors.tileColor,
        ),
      ),
    );
  }

  Widget _buildSessionStatsCard(TrainingSessionEntity session) {
    final formattedTime = _formatDuration(session.startTime);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.timer,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Problems attempted: ${session.boulders.length}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemsTab(TrainingSessionEntity session) {
    if (session.boulders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.mountain,
              size: 64,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nie daodano jeszcze żadnych problemów',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kliknij ikonę skanera, aby dodać problemy',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: session.boulders.length,
      itemBuilder: (context, index) {
        final boulder = session.boulders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: AppColors.tileColor,
          child: ListTile(
            title: Text(
              'Problem ${index + 1}',
              style: const TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Ocena: ${boulder.attempts ?? 'Nie ustalona'}',
              style: TextStyle(
                color: AppColors.textLight.withOpacity(0.7),
              ),
            ),
            trailing: Icon(
              boulder.status == BoulderStatus.flash
                  ? LucideIcons.zap
                  : LucideIcons.circleDashed,
              color: boulder.status == BoulderStatus.flash
                  ? Colors.greenAccent
                  : AppColors.textSecondary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalysisTab(dynamic session) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.chartBarIncreasing,
            size: 64,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Statystyki sesji',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rozpoczęto: ${session.startTime.toString().substring(0, 16)}',
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showEndSessionDialog(BuildContext context, String sessionId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        surfaceTintColor: AppColors.tileColor,
        title: Text(
          'Zakończyć sesje?',
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.textLight,
          ),
        ),
        content: Text(
          'Czy jesteś pewien, że chcesz zakończyć sesję?',
          style: context.textTheme.labelMedium?.copyWith(
            color: AppColors.textLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Zamknij',
              style: context.textTheme.labelMedium?.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<TrainingSessionBloc>().add(
                    EndSessionEvent(sessionId),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(
              'Zakończ',
              style: context.textTheme.labelMedium?.copyWith(
                color: AppColors.tileColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
