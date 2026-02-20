import 'package:flutter/material.dart';

import '../state/prayer_presence_controller.dart';
import 'prayer_presence_home_page.dart';

class PrayerPresenceApp extends StatelessWidget {
  const PrayerPresenceApp({
    super.key,
    required this.controller,
  });

  final PrayerPresenceController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayer Presence',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: PrayerPresenceHomePage(controller: controller),
    );
  }
}
