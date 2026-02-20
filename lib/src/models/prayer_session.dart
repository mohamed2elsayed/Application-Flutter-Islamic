import 'prayer_type.dart';

class PrayerSession {
  PrayerSession({
    required this.userName,
    required this.prayerType,
    required this.locationLabel,
    required this.startedAt,
    this.isCurrentUser = false,
  });

  final String userName;
  final PrayerType prayerType;
  final String locationLabel;
  final DateTime startedAt;
  final bool isCurrentUser;

  Duration get activeFor => DateTime.now().difference(startedAt);
}
