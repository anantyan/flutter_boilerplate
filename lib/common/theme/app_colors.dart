import 'package:flutter/material.dart';

/// Semantic, centralized color palette for Light and Dark themes.
abstract class AppColors {
  // Brand / Primary
  static const Color primary = Color(0xFF6366F1); // Indigo-500
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo-600
  static const Color primaryLight = Color(0xFF818CF8); // Indigo-400

  // Secondary / Accent
  static const Color secondary = Color(0xFF06B6D4); // Cyan-500
  static const Color secondaryLight = Color(0xFF22D3EE); // Cyan-400

  // Light Theme Neutrals
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate-50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate-200
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate-900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate-500

  // Dark Theme Neutrals
  static const Color darkBackground = Color(0xFF0B0F19); // Deep Slate
  static const Color darkSurface = Color(0xFF131A29);
  static const Color darkCard = Color(0xFF1E293B); // Slate-800
  static const Color darkBorder = Color(0xFF334155); // Slate-700
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate-50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate-400

  // Status & Feedback
  static const Color success = Color(0xFF10B981); // Emerald-500
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color info = Color(0xFF3B82F6); // Blue-500
}
