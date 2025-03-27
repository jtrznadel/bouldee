import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/features/training_session/presentation/bloc/training_session_bloc.dart';
import 'package:bouldee/features/training_session/presentation/create_training_session_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveSessionChecker {
  static void checkAndNavigate(BuildContext context) {
    final bloc = getIt<TrainingSessionBloc>()
      ..add(const LoadActiveSessionEvent());

    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: BlocListener<TrainingSessionBloc, TrainingSessionState>(
          listener: (context, state) {
            Navigator.pop(dialogContext);

            if (state is TrainingSessionActive) {
              context.router.push(const CurrentTrainingSessionRoute());
            } else if (state is TrainingSessionInactive ||
                state is TrainingSessionInitial) {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const CreateTrainingSessionModal(),
              );
            } else if (state is TrainingSessionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
