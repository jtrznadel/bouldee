import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/constants/enums.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/app/widgets/app_button.dart';
import 'package:bouldee/app/widgets/app_custom_appbar.dart';
import 'package:bouldee/app/widgets/app_divider.dart';
import 'package:bouldee/app/widgets/app_text_field.dart';
import 'package:bouldee/features/auth/presentation/bloc/sign_in/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppCustomAppbar(
        showAppLogo: true,
      ),
      body: BlocProvider(
        create: (context) => getIt<SignInBloc>(),
        child: const SignInForm(),
      ),
    );
  }
}

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Witaj 👋',
                  style: context.textTheme.headlineLarge
                      ?.copyWith(color: AppColors.textLight),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Miło Cię widzieć ponownie! ',
                  style: context.textTheme.headlineMedium
                      ?.copyWith(color: AppColors.textLight),
                ),
                const SizedBox(
                  height: 30,
                ),
                AppTextField(
                  label: 'E-Mail',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    context
                        .read<SignInBloc>()
                        .add(SignInEmailChanged(email: value));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                  onChanged: (value) {
                    context
                        .read<SignInBloc>()
                        .add(SignInPasswordChanged(password: value));
                  },
                  label: 'Hasło',
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Zapomniałeś hasła?',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (state.status == Status.loading)
                  const Center(child: CircularProgressIndicator())
                else
                  AppButton(
                    text: 'Zaloguj się',
                    onPressed: () {
                      context.read<SignInBloc>().add(SignInSubmitted());
                    },
                  ),
                const SizedBox(
                  height: 20,
                ),
                AppDivider.horizontalWithText(text: 'LUB'),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: AppButton(
                        iconPath: AppMediaRes.googleLogo,
                        color: AppColors.onSurface,
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        iconPath: AppMediaRes.appleLogo,
                        color: AppColors.onSurface,
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        iconPath: AppMediaRes.facebookLogo,
                        color: AppColors.onSurface,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nie masz jeszcze konta?',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.router.replace(const SignUpRoute());
                      },
                      child: Text(
                        'Zarejestruj się',
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
