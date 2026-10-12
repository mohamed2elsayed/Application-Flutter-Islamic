import 'package:flutter/foundation.dart';

import '../models/prayer_session.dart';
import '../models/prayer_type.dart';

class PrayerPresenceController extends ChangeNotifier {
  PrayerSession? _myActiveSession;
  String? _lastNotification;

  final List<PrayerSession> _nearbySessions = <PrayerSession>[
    PrayerSession(
      userName: 'Ahmed',
      prayerType: PrayerType.dhuhr,
      locationLabel: 'Downtown Mosque Area',
      startedAt: DateTime.now().subtract(const Duration(minutes: 6)),
    ),
    PrayerSession(
      userName: 'Fatima',
      prayerType: PrayerType.maghrib,
      locationLabel: 'Business District',
      startedAt: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ];

  PrayerSession? get myActiveSession => _myActiveSession;
  String? get lastNotification => _lastNotification;

  List<PrayerSession> get visibleNearbySessions {
    if (_myActiveSession == null) {
      return List<PrayerSession>.unmodifiable(_nearbySessions);
    }

    return List<PrayerSession>.unmodifiable(
      <PrayerSession>[_myActiveSession!, ..._nearbySessions],
    );
  }

  void startPrayer({
    required PrayerType prayerType,
    required String locationLabel,
  }) {
    _myActiveSession = PrayerSession(
      userName: 'You',
      prayerType: prayerType,
      locationLabel: locationLabel,
      startedAt: DateTime.now(),
      isCurrentUser: true,
    );

    _lastNotification =
        'Demo only: your prayer session started. Nearby users were not notified.';
    notifyListeners();
  }

  void finishPrayer() {
    if (_myActiveSession == null) {
      return;
    }
    _myActiveSession = null;
    _lastNotification = 'Prayer finished. Your online icon is now off.';
    notifyListeners();
  }

  void clearNotification() {
    _lastNotification = null;
    notifyListeners();
  }
}
