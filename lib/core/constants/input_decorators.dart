import 'package:flutter/material.dart';
import 'app_constants.dart';

class TaskInputDecorators {
  TaskInputDecorators._();

  static InputDecoration _baseDecoration({
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    bool alignLabelWithHint = false,
    bool isDense = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon,
      alignLabelWithHint: alignLabelWithHint,
      isDense: isDense,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static InputDecoration get taskTitle => _baseDecoration(
        labelText: 'Tytuł zadania *',
        hintText: 'Wpisz tytuł zadania',
        prefixIcon: Icons.title,
      );

  static InputDecoration get taskDescription => _baseDecoration(
        labelText: 'Opis (opcjonalnie)',
        hintText: 'Dodaj szczegóły zadania',
        prefixIcon: Icons.description,
        alignLabelWithHint: true,
      );

  static InputDecoration get taskPriority => _baseDecoration(
        prefixIcon: Icons.flag,
      );

  static InputDecoration get taskReminder => _baseDecoration(
        prefixIcon: Icons.notifications,
      );

  static InputDecoration get taskSort => _baseDecoration(
        labelText: 'Sortuj według',
        prefixIcon: Icons.sort,
        isDense: true,
      );
}
