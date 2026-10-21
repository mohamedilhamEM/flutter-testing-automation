import 'package:flutter/material.dart';
import 'package:testingapp/utils/utils.dart';

/// Application spacing constants for consistent padding and margins.
///
/// Uses base numeric constants and provides runtime getters for scaled
/// horizontal/vertical values (via `.w` / `.h`). These are not `const`
/// because scaling depends on runtime screen metrics.
class AppSpacing {
  // Base (unscaled) numeric values
  static const double _xs4 = 4;
  static const double _sm8 = 8;
  static const double _md12 = 12;
  static const double _md16 = 16;
  static const double _lg24 = 24;
  static const double _xl32 = 32;
  static const double _xl40 = 40;
  static const double _xxl48 = 48;

  // Scaled spacing (vertical-oriented by default)
  static double get xs4 => _xs4.h;
  static double get sm8 => _sm8.h;
  static double get md12 => _md12.h;
  static double get md16 => _md16.h;
  static double get lg24 => _lg24.h;
  static double get xl32 => _xl32.h;
  static double get xl40 => _xl40.h;
  static double get xxl48 => _xxl48.h;

  // Horizontal spacing helpers
  static EdgeInsets get horizontalXs4 => EdgeInsets.symmetric(horizontal: _xs4.w);
  static EdgeInsets get horizontalSm8 => EdgeInsets.symmetric(horizontal: _sm8.w);
  static EdgeInsets get horizontalMd12 => EdgeInsets.symmetric(horizontal: _md12.w);
  static EdgeInsets get horizontalMd16 => EdgeInsets.symmetric(horizontal: _md16.w);
  static EdgeInsets get horizontalLg24 => EdgeInsets.symmetric(horizontal: _lg24.w);
  static EdgeInsets get horizontalXl32 => EdgeInsets.symmetric(horizontal: _xl32.w);

  // Vertical spacing helpers
  static EdgeInsets get verticalXs4 => EdgeInsets.symmetric(vertical: _xs4.h);
  static EdgeInsets get verticalSm8 => EdgeInsets.symmetric(vertical: _sm8.h);
  static EdgeInsets get verticalMd12 => EdgeInsets.symmetric(vertical: _md12.h);
  static EdgeInsets get verticalMd16 => EdgeInsets.symmetric(vertical: _md16.h);
  static EdgeInsets get verticalLg24 => EdgeInsets.symmetric(vertical: _lg24.h);
  static EdgeInsets get verticalXl32 => EdgeInsets.symmetric(vertical: _xl32.h);

  // All sides spacing
  static EdgeInsets get allXs4 => EdgeInsets.all(_xs4.w);
  static EdgeInsets get allSm8 => EdgeInsets.all(_sm8.w);
  static EdgeInsets get allMd12 => EdgeInsets.all(_md12.w);
  static EdgeInsets get allMd16 => EdgeInsets.all(_md16.w);
  static EdgeInsets get allLg24 => EdgeInsets.all(_lg24.w);
  static EdgeInsets get allXl32 => EdgeInsets.all(_xl32.w);

  // Zero spacing
  static EdgeInsets get zero => EdgeInsets.zero;
}
