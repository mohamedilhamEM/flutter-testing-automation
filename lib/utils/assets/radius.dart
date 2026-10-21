import 'package:flutter/material.dart';
import 'package:testingapp/utils/utils.dart';

/// Application border radius constants.
///
/// Values rely on runtime screen-scaling extensions (e.g. `.r`) and therefore
/// cannot be `const`. Use the getters to obtain up-to-date scaled values.
class AppRadius {
  // Raw numeric base values (unscaled)
  static const double _xs4 = 4;
  static const double _sm8 = 8;
  static const double _md12 = 12;
  static const double _lg16 = 16;
  static const double _xl24 = 24;
  static const double _xxl32 = 32;

  // Scaled radius values (runtime)
  static double get xs4 => _xs4.r;
  static double get sm8 => _sm8.r;
  static double get md12 => _md12.r;
  static double get lg16 => _lg16.r;
  static double get xl24 => _xl24.r;
  static double get xxl32 => _xxl32.r;

  // Circular radius
  static Radius get circularXs4 => Radius.circular(xs4);
  static Radius get circularSm8 => Radius.circular(sm8);
  static Radius get circularMd12 => Radius.circular(md12);
  static Radius get circularLg16 => Radius.circular(lg16);
  static Radius get circularXl24 => Radius.circular(xl24);
  static Radius get circularXxl32 => Radius.circular(xxl32);

  // BorderRadius
  static BorderRadius get allXs4 => BorderRadius.all(circularXs4);
  static BorderRadius get allSm8 => BorderRadius.all(circularSm8);
  static BorderRadius get allMd12 => BorderRadius.all(circularMd12);
  static BorderRadius get allLg16 => BorderRadius.all(circularLg16);
  static BorderRadius get allXl24 => BorderRadius.all(circularXl24);
  static BorderRadius get allXxl32 => BorderRadius.all(circularXxl32);

  // Zero radius
  static BorderRadius get zero => BorderRadius.zero;
}
