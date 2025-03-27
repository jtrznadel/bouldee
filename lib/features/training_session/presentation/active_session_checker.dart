import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/features/training_session/presentation/bloc/training_session_bloc.dart';
import 'package:bouldee/features/training_session/presentation/create_training_session_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveSessionChecker {
  static void checkAndNavigate(BuildContext context) {
    // Tworzymy tymczasowy bloc do sprawdzenia stanu sesji
    final bloc = getIt<TrainingSessionBloc>()
      ..add(const LoadActiveSessionEvent());

    // Używamy BlocProvider.value aby nie tworzyć nowego blocu, tylko użyć istniejącego
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: BlocListener<TrainingSessionBloc, TrainingSessionState>(
          listener: (context, state) {
            // Zamknij dialog ładowania
            Navigator.pop(dialogContext);

            if (state is TrainingSessionActive) {
              // Jeśli jest aktywna sesja, przekieruj do jej widoku
              context.router.push(const CurrentTrainingSessionRoute());
            } else if (state is TrainingSessionInactive ||
                state is TrainingSessionInitial) {
              // Jeśli nie ma aktywnej sesji, pokaż modal do utworzenia nowej
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const CreateTrainingSessionModal(),
              );
            } else if (state is TrainingSessionError) {
              // Jeśli wystąpił błąd, pokaż komunikat
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
