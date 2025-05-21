import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_sizes.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/widgets/app_button.dart';
import 'package:bouldee/app/widgets/app_outlined_button.dart';
import 'package:flutter/material.dart';

class AppErrorPage extends StatelessWidget {
  const AppErrorPage({
    super.key,
    this.onRetry,
    this.onBack,
    this.errorMessage,
    this.errorTitle,
  });

  final VoidCallback? onRetry;
  final VoidCallback? onBack;
  final String? errorMessage;
  final String? errorTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.defaultHorizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 100,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              Text(
                errorTitle ?? 'Coś poszło nie tak',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage ??
                    'Nie można załadować tej strony. Sprawdź połączenie z internetem lub spróbuj ponownie później.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100),
              AppButton(
                onPressed: onRetry ?? () {},
                text: 'Spróbuj ponownie',
              ),
              const SizedBox(height: 10),
              AppOutlinedButton(
                onPressed: onBack ?? () {},
                text: 'Wróć',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
