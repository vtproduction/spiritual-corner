import 'package:flutter/material.dart';

class AppSpacing {
  // Raw spacing values
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p16 = 16.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p48 = 48.0;

  // SizedBox extensions for UI padding
  static const SizedBox gap4 = SizedBox(width: p4, height: p4);
  static const SizedBox gap8 = SizedBox(width: p8, height: p8);
  static const SizedBox gap16 = SizedBox(width: p16, height: p16);
  static const SizedBox gap24 = SizedBox(width: p24, height: p24);
  static const SizedBox gap32 = SizedBox(width: p32, height: p32);
  static const SizedBox gap48 = SizedBox(width: p48, height: p48);
}
