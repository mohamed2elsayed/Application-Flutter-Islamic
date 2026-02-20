# Prayer Presence App — Complete Plan (Flutter iOS + Android)

This document is the **full plan** for building your app idea:
- A user can press **"I am praying now"**.
- Nearby users get a notification (for example Asr).
- Nearby users can see prayer activity on a map/list.
- When prayer finishes, user goes offline and activity disappears.

---

## 1) Product Vision
Create a trusted, privacy-first local Muslim community app where people can:
- Share real-time prayer presence.
- Discover nearby prayer activity.
- Coordinate with local community/mosque/company groups.

### Core value
- Encourage prayer through social motivation.
- Build local community connection.
- Respect privacy and safety by default.

---

## 2) User Types and Use Cases

### User type A: Individual community member
- Wants to share "I am praying now".
- Wants to know if others nearby are praying.

### User type B: Community admin (future)
- Wants insights on participation in a defined group (company/campus).
- Wants moderation tools to keep platform safe.

### Primary use cases
1. User starts prayer session with one tap.
2. Nearby eligible users receive notification.
3. Nearby users open app and see active prayer sessions.
4. User ends prayer session; session status becomes finished.
5. Session auto-expires if user forgets to end.

---

## 3) Feature Plan by Phase

## Phase 1 — MVP (first release)
### Must-have
- Sign up/login (phone or email).
- User profile (name, optional photo).
- Start prayer session (choose: Fajr, Dhuhr, Asr, Maghrib, Isha).
- End prayer session.
- Nearby sessions list + map view.
- Push notifications for nearby sessions.
- Basic privacy mode (approximate location only).
- Auto-expire sessions (e.g., 30 min).

### Nice-to-have in MVP
- Session timer UI.
- Quiet hours.
- Prayer filters.

## Phase 2 — Community launch
- Group types (company, campus, mosque).
- Invite-only community mode.
- Role-based access (admin/member).
- Reporting/blocking and moderation panel.
- Better notification personalization.

## Phase 3 — Scale and intelligence
- Smart ranking of nearby relevant sessions.
- Habit and consistency insights.
- Multi-language localization.
- Regional rollouts with policy/legal tuning.

---

## 4) App Flow (End-to-End)

1. **Onboarding**
   - Explain app purpose.
   - Ask permissions (location + notifications).
   - Set privacy defaults.

2. **Home screen**
   - Big primary CTA: **Start Prayer**.
   - If active: show **Finish Prayer** + elapsed time.

3. **Start Prayer flow**
   - Select prayer type.
   - Confirm location-sharing mode.
   - Create active session.

4. **Notification flow**
   - Backend finds nearby users.
   - Sends push: “Someone nearby is praying Asr now.”

5. **Nearby screen**
   - Map with coarse pins/areas.
   - List cards with prayer type and active duration.

6. **Finish Prayer flow**
   - User taps finish.
   - Session marked finished.
   - User online prayer indicator removed.

7. **Failure handling**
   - If no internet: cache local event and sync later.
   - If user exits app: auto-expire ensures cleanup.

---

## 5) Technical Architecture Plan

### Mobile (Flutter)
- Flutter app for iOS + Android.
- State management: Riverpod (recommended).
- Routing: go_router.
- Maps: Google Maps SDK or Mapbox.
- Notifications: Firebase Cloud Messaging.
- Local storage: Hive/shared_preferences for lightweight caching.

### Backend (Firebase-first MVP)
- Firebase Auth.
- Firestore for real-time data.
- Cloud Functions for:
  - proximity matching,
  - notification dispatch,
  - auto-expire scheduler/cleanup,
  - abuse/rate-limit checks.
- Crashlytics + Analytics.

### Why Firebase first
- Fast MVP delivery.
- Realtime built-in.
- Lower ops complexity early.

---

## 6) Data Model Plan

## users
- id
- displayName
- photoUrl
- trustLevel (optional)
- privacyMode (`coarse`, `hidden`, `community-only`)
- notificationPrefs (enabled prayers, radius, quiet hours)
- blockedUsers[]
- createdAt

## communities (phase 2)
- id
- name
- type (`company`, `campus`, `mosque`, `public`)
- privacy (`invite-only`, `open`)
- region
- adminIds[]

## prayer_sessions
- id
- userId
- communityId (optional)
- prayerType
- status (`active`, `finished`, `expired`)
- startedAt
- endedAt
- ttlAt
- locationCell (coarse geohash)
- latitudeApprox
- longitudeApprox

## notification_events
- id
- sessionId
- receiverUserId
- sentAt
- status (`sent`, `failed`, `opened`)

## reports
- id
- reporterId
- targetUserId
- reason
- createdAt
- status

---

## 7) Privacy, Safety, and Trust Plan

### Privacy defaults
- Share approximate location only by default.
- Never show exact home/work addresses.
- Allow hidden mode.

### Safety controls
- Report user.
- Block user.
- Rate limit repeated session toggling.
- Device/account abuse heuristics.

### Legal/compliance checklist
- Clear consent for location and notifications.
- Data retention policy (e.g., session logs auto-delete in 30 days).
- Terms and Privacy Policy before public release.

---

## 8) Notification Strategy Plan

### Trigger condition
When a user starts an active prayer session.

### Receiver selection
- Inside radius (e.g., 2km default).
- Same community if in private mode.
- Not blocked by either party.
- Notification settings allow this prayer type.
- Respect quiet hours.

### Anti-spam policy
- Cap notifications per user per hour.
- Collapse duplicate events for same area/prayer.

---

## 9) UI/UX Plan (Screen List)

1. Splash + Auth
2. Onboarding + permission education
3. Home (Start/Finish)
4. Select prayer modal
5. Nearby map
6. Nearby list
7. Session details
8. Notification settings
9. Privacy settings
10. Profile
11. Report/block UI
12. Admin tools (phase 2)

---

## 10) Engineering Plan (12 Weeks)

### Weeks 1–2: Foundation
- Finalize requirements.
- Setup Flutter project architecture.
- Setup Firebase projects (dev/stage/prod).
- Implement Auth + base navigation.

### Weeks 3–4: Core session logic
- Build start/finish prayer flow.
- Implement `prayer_sessions` collection.
- Add active-session home state.
- Implement auto-expire logic.

### Weeks 5–6: Location + Nearby
- Permission flow for location.
- Coarse geolocation write/read.
- Nearby query logic and list UI.
- Map integration.

### Weeks 7–8: Notifications
- Cloud Function for matching + sending.
- FCM token lifecycle management.
- Notification deeplinks.
- Quiet hours + prayer filters.

### Weeks 9–10: Safety + privacy hardening
- Block/report flows.
- Rate limiting.
- Privacy settings and copy review.
- Telemetry and analytics events.

### Weeks 11–12: QA + launch prep
- End-to-end tests and bug fixing.
- Performance/battery checks.
- TestFlight + Play Internal testing.
- Release checklist and rollout.

---

## 11) QA and Testing Plan

### Automated
- Unit tests: session state, notification filter logic.
- Widget tests: start/finish flow.
- Integration tests: auth -> start prayer -> nearby visibility -> finish.

### Manual
- Permission denied scenarios.
- Offline mode + resync.
- App killed/reopened during active session.
- Different timezone and locale checks.

### Release gates
- Crash-free sessions > 99% in beta.
- No P0 privacy/security defects.
- Notification success rate target achieved.

---

## 12) Metrics and Success Plan

### Product KPIs
- DAU / WAU.
- Prayer sessions started/day.
- Session completion rate.
- Nearby screen opens.
- Notification open rate.
- D7 and D30 retention.

### Community KPIs (phase 2)
- Active communities count.
- Community retention and growth.
- Moderation incident rate.

---

## 13) Business and Launch Plan

### Pilot strategy
- Start with one city or one company/campus.
- Recruit 50–200 beta users.
- Weekly feedback loops.

### Launch strategy
- Launch only where community density is enough.
- Partner with local mosques/community organizers.
- Use invite-based growth before public listing.

### Monetization options (later)
- Community premium analytics.
- Verified organization subscriptions.
- Sponsored local community features (privacy-safe).

---

## 14) Critical Risks and Mitigations

1. **Low activity (empty network)**
   - Mitigation: launch in small dense communities first.

2. **Privacy concerns**
   - Mitigation: coarse location default + transparent controls.

3. **Notification fatigue**
   - Mitigation: quiet hours, frequency caps, preference filters.

4. **Abuse/spam**
   - Mitigation: report/block, throttling, moderation ops.

5. **Battery/performance issues**
   - Mitigation: no continuous high-accuracy tracking.

---

## 15) Full Action Checklist (What you do next)

1. Freeze MVP scope (Phase 1 only).
2. Choose stack: Flutter + Firebase.
3. Build Figma wireframes for 10 MVP screens.
4. Setup project and CI.
5. Implement Auth + Home + Start/Finish flow.
6. Add location and nearby list.
7. Add notification pipeline.
8. Add privacy/safety basics.
9. Run 2-week pilot.
10. Improve based on feedback.
11. Prepare public release.

---

## 16) Simple One-Sentence Product Definition
A privacy-first, location-based Flutter app where users can share real-time prayer presence, notify nearby community members, and automatically return offline when prayer ends.
