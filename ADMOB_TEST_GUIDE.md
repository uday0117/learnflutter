# AdMob Integration & Monetization Guide

## 📊 Summary of Implemented Ad Formats & Placements

| Ad Format | Test Ad Unit ID (Android / iOS) | Placement in App | Policy Safeguards & Optimizations |
| :--- | :--- | :--- | :--- |
| **Anchored Banner** | `ca-app-pub-3940256099942544/6300978111`<br/>`ca-app-pub-3940256099942544/2934735716` | Bottom of `WidgetDetailScreen`, `WidgetsListScreen`, `QuizScreen`, `RoadmapScreen`, etc. | • Orientation adaptive sizing<br/>• Kept alive in scroll views (`AutomaticKeepAliveClientMixin`)<br/>• 54dp floating action button clearance (no accidental overlaps)<br/>• Visual divider separation in Quiz screen |
| **Native Ad (Medium Template)** | `ca-app-pub-3940256099942544/2247696110`<br/>`ca-app-pub-3940256099942544/3986624511` | Home Feed (`_HomeAdCard`) | • Built with `NativeTemplateStyle` matching dark/light themes<br/>• Blends seamlessly with card styling<br/>• Higher CTR & eCPM |
| **Interstitial Ad** | `ca-app-pub-3940256099942544/1033173712`<br/>`ca-app-pub-3940256099942544/4411468910` | Quiz completion, Interview deck completion, and detail exit transitions | • Minimum 6-second dwell time check<br/>• Frequency cap: max 4/session, max 8/day<br/>• 60s minimum interval<br/>• Safe navigation callbacks (never pops unexpectedly over parent) |
| **Rewarded Ad** | `ca-app-pub-3940256099942544/5224354917`<br/>`ca-app-pub-3940256099942544/1712485313` | • Rewards Hub (`Ad-Free pass`, `Streak Shield`, `Project Unlocks`)<br/>• Quiz 50/50 hint<br/>• Settings Ad-Free pass | • Clear value exchange<br/>• Lightweight loading indicator with retry reset<br/>• Immediate Ad-Free reactivity across all active screens |
| **App Open Ad** | `ca-app-pub-3940256099942544/9257395921`<br/>`ca-app-pub-3940256099942544/5575463023` | Warm app resume (>120s in background) & Splash screen exit | • Suppressed during active learning sessions (Quiz & Flashcards)<br/>• 90s global fullscreen ad cooldown<br/>• 4-hour max cached ad age |

---

## 🇪🇺 Google UMP Consent Flow (EU/EEA/UK GDPR & ePrivacy Compliance)

1. **Consent-First Initialization:**
   - AdMob SDK initialization is deferred until Google UMP consent parameters are resolved.
   - All ad formats check `AdService().canRequestAds()` before issuing ad requests.
2. **Testing EEA Consent in Debug Mode:**
   - Call `AdService().initialize(debugEeaConsent: true)` during development to simulate EEA consent dialogs from any region.
3. **User Privacy Management:**
   - In Settings > "Ad Privacy & Consent", users can re-open their consent choices at any time via `showPrivacyOptionsForm()`.

---

## 📈 Firebase Analytics & Impression-Level Revenue Data (ILRD)

On every ad impression, AdMob triggers `onPaidEvent`, which logs to Firebase Analytics:
* **Event Name:** `ad_impression`
* **Parameters Tracked:**
  * `ad_platform`: `'admob'`
  * `ad_source`: Adapter name (e.g., `'admob'`, `'Meta Audience Network'`, etc.)
  * `ad_format`: `'banner'`, `'native'`, `'interstitial'`, `'rewarded'`, `'app_open'`
  * `ad_unit_name`: Ad unit ID
  * `value`: Revenue in standard currency units (`valueMicros / 1,000,000.0`)
  * `currency`: Currency code (e.g., `'USD'`)
  * `precision`: Precision type (e.g., `'ESTIMATED'`, `'PRECISE'`)
* **Debug Logging:** In debug builds, real-time revenue events are printed to the console:
  `[AnalyticsService] 💰 Ad Impression | Format: ... | Value: ... USD`

---

## 🛡️ Production Readiness Checklist

Before publishing to the Google Play Store or Apple App Store:

- [x] Production Ad Unit IDs configured in `ad_service.dart`.
- [x] Automatic test ad switching enabled via `kDebugMode` (no manual booleans required).
- [x] Google Mobile Ads App ID configured in `AndroidManifest.xml` and `Info.plist`.
- [x] Android optimization flags (`OPTIMIZE_INITIALIZATION` and `OPTIMIZE_DATAPROCESSING`) enabled.
- [x] Updated SKAdNetwork IDs configured in `Info.plist`.
- [x] Consent Management Platform (UMP) configured in AdMob console (Privacy & Messaging).
- [x] All GetX controllers and app features verified.
