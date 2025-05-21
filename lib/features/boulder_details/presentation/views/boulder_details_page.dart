import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/views/app_error_page.dart';
import 'package:bouldee/app/widgets/app_loading_indicator.dart';
import 'package:bouldee/features/boulder_details/presentation/bloc/boulder_details_bloc.dart';
import 'package:bouldee/features/boulder_details/presentation/views/boulder_details_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class BoulderDetailsPage extends StatelessWidget {
  const BoulderDetailsPage({required this.boulderId, super.key});

  final String boulderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BoulderDetailsBloc>()
        ..add(GetBoulderDetailsEvent(boulderId: boulderId)),
      child: BlocBuilder<BoulderDetailsBloc, BoulderDetailsState>(
        builder: (context, state) {
          if (state is BoulderDetailsError) {
            return AppErrorPage(
              onBack: () => context.router.maybePop(),
              onRetry: () => context
                  .read<BoulderDetailsBloc>()
                  .add(GetBoulderDetailsEvent(boulderId: boulderId)),
            );
          } else if (state is BoulderDetailsLoaded) {
            final boulderDetails = state.boulderDetails;
            return BoulderDetailsSuccessView(boulderDetails: boulderDetails);
          } else {
            return const Center(
              child: AppLoadingIndicator(),
            );
          }
        },
      ),
    );
  }
}
