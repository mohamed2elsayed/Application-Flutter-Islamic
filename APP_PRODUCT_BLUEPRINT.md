# Prayer Presence App — Product Blueprint (iOS + Android, Flutter)

## 1) Core idea (MVP)
A location-based community app where a user can share **“I am praying now”** status.

When a user starts praying:
- Their status becomes **Active / Praying** for a selected prayer (Fajr, Dhuhr, Asr, Maghrib, Isha).
- Nearby users can see that someone is praying now (with privacy-safe location sharing).
- Optional notifications are sent to relevant nearby users.

When a user finishes:
- Their status returns to **Offline / Finished**.
- The praying indicator is removed from nearby users’ active view.

## 2) Clarified user stories
1. As a user, I can set my location permissions and prayer preferences.
2. As a user, I can tap **Start Prayer** and choose prayer type.
3. As nearby user, I can receive “someone is praying now” notification.
4. As nearby user, I can open a map/list and see active prayer sessions nearby.
5. As praying user, I can tap **Finish Prayer** to stop broadcasting status.
6. As user, I can control privacy (exact location, approximate location, hidden mode).

## 3) MVP feature scope (build first)
### Authentication
- Phone auth or email auth.
- Basic profile: display name, optional avatar.

### Presence session
- Start prayer session (type + optional duration timer).
- Finish prayer session manually.
- Auto-expire fallback (e.g., 30 minutes) in case user forgets to stop.

### Location + discovery
- Request foreground location permission.
- Share only approximate location by default (e.g., rounded geohash / map cell).
- Show nearby active sessions in radius (e.g., 1–5 km configurable).

### Notifications
- Push notifications for nearby sessions matching user preferences.
- Quiet hours / Do Not Disturb.

### Safety & abuse controls
- Report/block users.
- Rate limiting session starts.
- Basic content moderation for profile fields.

## 4) Non-functional requirements
- Reliable real-time updates (<3 seconds typical).
- Battery-efficient location usage (no continuous high-accuracy tracking for MVP).
- GDPR-style data minimization and consent.
- Scalable backend for city-level concurrency.

## 5) Recommended architecture (Flutter-first)
### Mobile app
- Flutter (single codebase for iOS + Android).
- State management: Riverpod or Bloc.
- Maps: Google Maps / Mapbox Flutter SDK.
- Notification handling: Firebase Cloud Messaging.

### Backend (practical MVP)
- Firebase Authentication.
- Cloud Firestore for user/session documents.
- Cloud Functions for:
  - geofence-like matching logic,
  - sending push notifications,
  - session auto-expiry cleanup.
- Firebase Analytics + Crashlytics.

> Alternative: Supabase + Edge Functions + OneSignal (also valid).

## 6) Data model (example)
### users
- id
- displayName
- photoUrl
- notificationSettings
- privacyMode
- homeRegion(optional)
- createdAt

### prayer_sessions
- id
- userId
- prayerType (fajr/dhuhr/asr/maghrib/isha)
- status (active/finished/expired)
- startedAt
- endedAt
- locationCell (coarse)
- preciseLocation(optional, encrypted + access-controlled)

### notification_events
- id
- sessionId
- receiverUserId
- sentAt
- deliveryStatus

## 7) Notification logic (simple MVP)
Trigger when session starts:
1. Find active users inside radius.
2. Exclude blocked relationships.
3. Respect receiver preferences (enabled prayers, quiet mode).
4. Send push: “Someone nearby is praying Asr now.”
5. Deep-link to nearby sessions screen.

## 8) Privacy design (must-have)
- Default to approximate location, not exact pin.
- Optional “Masjid/Area only” visibility mode.
- No background tracking unless explicitly needed and consented.
- Clear consent screen explaining what is shared and when.
- Auto-delete old sessions after retention window (e.g., 30 days).

## 9) Edge cases you should plan now
- User starts session with no internet.
- User forgets to end session.
- Duplicate notifications.
- False location/spam behavior.
- Timezone and prayer-time calculation differences.
- App killed in background while session active.

## 10) 6-week implementation roadmap
### Week 1
- Product requirements + wireframes.
- Firebase project setup + auth.

### Week 2
- Start/finish prayer session flow.
- Session list screen.

### Week 3
- Location permission + coarse location storage.
- Nearby query screen.

### Week 4
- Cloud Function notification pipeline.
- Notification preferences page.

### Week 5
- Privacy modes + block/report.
- Auto-expire and reliability fixes.

### Week 6
- QA, analytics events, crash fixes.
- Beta release (TestFlight + Play Internal Testing).

## 11) UI screens for first release
1. Onboarding + permissions
2. Home (Start Prayer / Finish Prayer)
3. Nearby Prayers (map + list)
4. Session details
5. Notification settings
6. Privacy settings
7. Profile + block/report management

## 12) KPI metrics for success
- Daily Active Users (DAU)
- Prayer session starts per day
- Session completion rate (start -> finish)
- Notification open rate
- 7-day retention

## 13) What to think about next (your missing points)
- Who is your initial community? (single city, university, company campuses)
- What is the trust model? (verified members only vs open public)
- What visibility level is acceptable culturally and legally?
- Do you need exact location at all, or only zone-level activity?
- Should sessions be anonymous by default?
- How will moderation work if abuse happens?
- What is your launch strategy to avoid empty-network problem?

## 14) Suggested immediate next actions
1. Validate with 10 target users (short interviews).
2. Freeze MVP scope from sections 1–3.
3. Build Flutter prototype screens before backend complexity.
4. Implement Firebase MVP stack.
5. Run 2-week pilot in one local community.
