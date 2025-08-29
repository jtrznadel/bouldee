import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/features/training_session/presentation/bloc/training_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTrainingSessionModal extends StatelessWidget {
  const CreateTrainingSessionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TrainingSessionBloc>(),
      child: BlocListener<TrainingSessionBloc, TrainingSessionState>(
        listener: (context, state) {
          if (state is TrainingSessionActive) {
            Navigator.pop(context);
            context.router.push(const CurrentTrainingSessionRoute());
          } else if (state is TrainingSessionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(25).copyWith(bottom: 40),
          decoration: const BoxDecoration(
            color: AppColors.onSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Gotowy na nowe wyzwanie?',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Śledź swoje problemy, monitoruj postępy i analizuj wyniki w tej sesji.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<TrainingSessionBloc, TrainingSessionState>(
                builder: (context, state) {
                  final isLoading = state is TrainingSessionLoading;

                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<TrainingSessionBloc>().add(
                                  const StartSessionEvent(),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Zaczynajmy!',
                            style: context.textTheme.labelLarge,
                          ),
                  );
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Nie teraz',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
