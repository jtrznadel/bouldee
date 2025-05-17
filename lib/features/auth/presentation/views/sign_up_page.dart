import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/enums.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/app/widgets/app_button.dart';
import 'package:bouldee/app/widgets/app_custom_appbar.dart';
import 'package:bouldee/app/widgets/app_text_field.dart';
import 'package:bouldee/features/auth/presentation/bloc/sign_up/bloc/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomAppbar(
        showAppLogo: true,
        onBack: () => context.router.replace(const OnboardingRoute()),
      ),
      body: BlocProvider(
        create: (context) => getIt<SignUpBloc>(),
        child: const SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == Status.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zacznij swoją przygodę!',
                  style: context.textTheme.headlineLarge
                      ?.copyWith(color: AppColors.textLight),
                ),
                AppTextField(
                  label: 'Nazwa użytkownika',
                  onChanged: (value) {
                    context
                        .read<SignUpBloc>()
                        .add(SignUpUsernameChanged(username: value));
                  },
                ),
                AppTextField(
                  label: 'E-mail ',
                  onChanged: (value) {
                    context
                        .read<SignUpBloc>()
                        .add(SignUpEmailChanged(email: value));
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                AppTextField(
                  label: 'Numer telefonu',
                  onChanged: (value) {
                    context
                        .read<SignUpBloc>()
                        .add(SignUpPhoneNumberChanged(phoneNumber: value));
                  },
                  keyboardType: TextInputType.phone,
                ),
                AppTextField(
                  onChanged: (value) {
                    context
                        .read<SignUpBloc>()
                        .add(SignUpPasswordChanged(password: value));
                  },
                  label: 'Hasło',
                  obscureText: true,
                ),
                AppTextField(
                  onChanged: (value) {
                    context.read<SignUpBloc>().add(
                          SignUpConfirmPasswordChanged(confirmPassword: value),
                        );
                  },
                  label: 'Potwierdź hasło',
                  obscureText: true,
                ),
                const Spacer(),
                if (state.status == Status.loading)
                  const Center(child: CircularProgressIndicator())
                else
                  AppButton(
                    text: 'Zarejestruj się',
                    onPressed: () {
                      context.read<SignUpBloc>().add(SignUpSubmitted());
                    },
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Posiadasz już konto?',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.router.replace(const SignInRoute());
                      },
                      child: Text(
                        'Zaloguj się',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
