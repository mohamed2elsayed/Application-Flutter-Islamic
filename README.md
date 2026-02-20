# Prayer Presence App (Flutter Starter)

This is the first coding step for the Prayer Presence concept.

## Implemented now
- Start prayer session (`I am praying now`).
- Finish prayer session (turns user offline).
- Online/offline icon in app bar.
- Nearby prayer activity list (mock data).
- Notification-style snackbar when session starts/ends.

## Next implementation steps
1. Replace mock state with Firebase Auth + Firestore.
2. Add real location permission and coarse geohash storage.
3. Implement FCM push notifications from Cloud Functions.
4. Add map view and privacy settings.

## Run locally
Install Flutter SDK, then:

```bash
flutter pub get
flutter run
```
