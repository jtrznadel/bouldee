import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.onChanged,
    this.labelColor = AppColors.textLight,
    this.textColor = AppColors.textLight,
    this.hint,
    super.key,
    this.required = true,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  final String label;
  final Color labelColor;
  final Color textColor;
  final String? hint;
  final bool required;
  final void Function(String) onChanged;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Row(
          children: [
            Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(
                color: labelColor,
              ),
            ),
            if (required)
              Text(
                '*',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.red,
                ),
              )
            else
              const SizedBox(),
          ],
        ),
        TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            fillColor: AppColors.onSurface,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.onSurface,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.onSurface,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.onSurface,
              ),
            ),
            hintText: hint,
          ),
          style: context.textTheme.bodyMedium?.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
