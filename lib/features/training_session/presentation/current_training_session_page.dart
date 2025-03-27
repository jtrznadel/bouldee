import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/features/training_session/presentation/bloc/training_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class CurrentTrainingSessionPage extends StatelessWidget {
  const CurrentTrainingSessionPage({super.key});

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
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: const Text('Current Session'),
                backgroundColor: AppColors.tileColor,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.activity,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Session active for:',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        final duration =
                            DateTime.now().difference(session.startTime);
                        final hours = duration.inHours;
                        final minutes = duration.inMinutes % 60;
                        final seconds = duration.inSeconds % 60;

                        return Text(
                          '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: context.textTheme.headlineLarge?.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Problems attempted: ${session.boulders.length}',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('End Session?'),
                            content: const Text(
                                'Are you sure you want to end this training session?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('CANCEL'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<TrainingSessionBloc>().add(
                                        EndSessionEvent(session.id),
                                      );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                                child: const Text('END SESSION'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('End Session'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Fallback widok (nie powinien się pojawić, bo jeśli nie ma aktywnej
          // sesji, to powinniśmy wrócić do poprzedniego ekranu)
          return const Scaffold(
            body: Center(
              child: Text('No active session'),
            ),
          );
        },
      ),
    );
  }
}
