import 'package:bouldee/app/app.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/bootstrap.dart';
import 'package:bouldee/features/auth/presentation/bloc/auth_bloc.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  bootstrap(
    () => MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt.get<auth.AuthBloc>()..add(auth.AuthInitialCheck()),
        ),
      ],
      child: const App(),
    ),
  );
}
