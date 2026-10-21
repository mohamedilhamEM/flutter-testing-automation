import 'package:flutter/material.dart';

import 'package:testingapp/utils/utils.dart';

class ShellController extends StatelessWidget {
  const ShellController({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: navigationShell.goBranch,
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.house),
            label: context.l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.solidMessage),
            label: context.l10n.chat,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.solidCompass),
            label: context.l10n.explore,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
            label: context.l10n.more,
          ),
        ],
      ),
    );
  }
}
