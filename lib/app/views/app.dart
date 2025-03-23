import 'package:bouldee/app/routing/app_router.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/app/theme/app_theme.dart';
import 'package:bouldee/features/auth/presentation/bloc/auth_bloc.dart' as auth;
import 'package:bouldee/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();
    return BlocListener<auth.AuthBloc, auth.AuthState>(
      listener: (context, state) {
        router.replace(const HomeRoute());
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config(),
      ),
    );
  }
}
