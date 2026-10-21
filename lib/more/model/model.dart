import 'package:flutter/material.dart';

class MenuItem {
  const MenuItem({
    required this.title,
    required this.icon, this.subtitle,
    this.onTap,
  });
  
  final String title;
  final String? subtitle;
  final IconData icon;
  final void Function()? onTap;
}
