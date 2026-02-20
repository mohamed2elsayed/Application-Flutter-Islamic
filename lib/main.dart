import 'package:flutter/material.dart';

import 'src/state/prayer_presence_controller.dart';
import 'src/ui/prayer_presence_app.dart';

void main() {
  runApp(
    PrayerPresenceApp(
      controller: PrayerPresenceController(),
    ),
  );
}
