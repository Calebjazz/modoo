import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Standalone outlined input. Each field is its own rounded block — never
/// grouped inside a shared card. Password fields get a visibility toggle.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    this.controller,
    this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.validator,
    this.onSubmitted,
  });

  final String hint;
  final TextEditingController? controller;
  final IconData? icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.isPassword;

  static OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscured,
      enableSuggestions: !widget.isPassword,
      autocorrect: !widget.isPassword,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
      cursorColor: AppColors.black,
      style: AppTextStyles.lead.copyWith(fontSize: 15),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppTextStyles.lead.copyWith(
          fontSize: 15,
          color: AppColors.grey,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
        prefixIcon: widget.icon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 18, right: 12),
                child: Icon(widget.icon, size: 20, color: AppColors.black),
              ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _obscured ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => _obscured = !_obscured),
                icon: Icon(
                  _obscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppColors.grey,
                ),
              )
            : null,
        errorStyle: AppTextStyles.label.copyWith(
          letterSpacing: 0.2,
          fontSize: 11,
        ),
        errorMaxLines: 2,
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.black, 1.4),
        errorBorder: _border(AppColors.black),
        focusedErrorBorder: _border(AppColors.black, 1.4),
      ),
    );
  }
}
