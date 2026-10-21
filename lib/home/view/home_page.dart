import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testingapp/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    log('HomePage initialized', name: 'HomePage');
    super.initState();
  }

  @override
  void dispose() {
    log('HomePage disposed', name: 'HomePage');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.home),
      ),
      body: Center(
        child: Text(context.l10n.home),
      ),
    );
  }
}
