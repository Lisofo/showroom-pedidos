import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final bool obscure;
  final bool enabled;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final TextAlign? textAlign;
  final String? initialValue;
  final TextInputType? keyboard;
  final List<TextInputFormatter>? mascara;
  final void Function(String)? onFieldSubmitted;
  final int? maxLength;
  final bool enableInteractiveSelection;
  final Icon? icon;

  const CustomTextFormField(
      {super.key,
      this.label,
      this.hint,
      this.errorMessage,
      this.onChanged,
      this.validator,
      this.maxLines,
      this.minLines,
      this.obscure = false,
      this.enabled = true,
      this.controller,
      this.onSaved,
      this.textAlign = TextAlign.start,
      this.initialValue,
      this.keyboard,
      this.mascara,
      this.onFieldSubmitted,
      this.maxLength,
      this.enableInteractiveSelection = false,
      this.icon,
    });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(5));

    return TextFormField(
      keyboardType: keyboard,
      initialValue: initialValue,
      textAlign: textAlign!,
      enabled: enabled,
      onSaved: onSaved,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscure,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border.copyWith(),
        errorBorder: border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        focusedErrorBorder: border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        isDense: true,
        label: null, //label != null ? Text(label!) : null,
        hintText: hint,
        disabledBorder: border.copyWith(),
        errorText: errorMessage,
        icon: icon
      ),
      maxLines: maxLines,
      minLines: minLines,
      inputFormatters: mascara,
      maxLength: maxLength,
      onFieldSubmitted: onFieldSubmitted,
      enableInteractiveSelection: enableInteractiveSelection,
    );
  }
}
