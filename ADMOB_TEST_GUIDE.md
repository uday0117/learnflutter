# AdMob Integration Test Guide

## ✅ What Was Implemented

### 1. **Google AdMob Package** ✅
- Added `google_mobile_ads: ^5.3.1` to pubspec.yaml
- Installed successfully via `flutter pub get`

### 2. **Configuration** ✅
- **Android**: AndroidManifest.xml configured with App ID
- **iOS**: Info.plist configured with App ID
- App ID: `ca-app-pub-1451522103593938~8406068234`

### 3. **Ad Units** ✅
- **Banner Ad**: `ca-app-pub-1451522103593938/8796950476`
- **Interstitial Ad**: `ca-app-pub-1451522103593938/8546005746`

### 4. **Test Ads Enabled** ✅
- Currently using **TEST ADS** for safe testing
- Test ads will show sample ads from Google
- No risk to your AdMob account during testing

### 5. **Ad Placements** ✅
- **Banner Ads**: Bottom of home screen and widget detail screen
- **Interstitial Ads**: Every 2 widget detail screen visits

---

## 🧪 How to Test AdMob Integration

### Step 1: Complete App Restart Required
```bash
# Stop the current app completely
# Then run:
flutter run
```

**IMPORTANT**: Hot reload will NOT work for AdMob initialization. You MUST do a full app restart.

### Step 2: Test Banner Ads
1. Open the app
2. Look at the **bottom of the home screen** (above navigation bar)
3. You should see a test banner ad with "Test Ad" text
4. Tap any widget to open detail screen
5. Scroll to bottom - another banner ad should appear

### Step 3: Test Interstitial Ads
1. From home screen, tap any widget to open detail screen
2. Go back to home
3. Tap another widget (2nd visit)
4. **Full-screen interstitial test ad should appear**
5. Close it and continue
6. Every 2 widget visits, you'll see an interstitial ad

### Step 4: Check Console Logs
Watch for these logs in terminal:
```
✅ "Banner Ad loaded."
✅ "Interstitial Ad loaded."
✅ "Detail screen counter: 1"
✅ "Detail screen counter: 2"
✅ "Attempting to show interstitial ad..."
✅ "Showing interstitial ad now!"
✅ "Interstitial Ad showed full screen content."
```

---

## 🐛 Troubleshooting

### If Banner Ads Don't Show:
1. **Check Internet Connection** - Ads require internet
2. **Wait 5-10 seconds** - Ads take time to load
3. **Check console** - Look for "Banner Ad loaded" message
4. **Restart app** - Hot reload doesn't work for ads

### If Interstitial Ads Don't Show:
1. **Visit more screens** - Opens 2 widgets to trigger ad
2. **Check counter** - Console shows "Detail screen counter: X"
3. **Wait for ad to load** - First load takes 3-5 seconds
4. **Check logs** - Should see "Interstitial Ad loaded"

### Common Issues:

**"Ad failed to load"**
- Normal for first launch
- Ads will retry automatically
- Check internet connection

**"Ad is not ready yet"**
- Ad is still loading
- Will load in background
- Next trigger will show it

**No ads visible**
- Do FULL app restart (not hot reload)
- Ads may be loading (check console)
- Test ads should always work with internet

---

## 📝 Important Notes

### Current Settings:
- ✅ **Test Ads ENABLED** (`_useTestAds = true`)
- ✅ **Interstitial Frequency**: Every 2 screen visits
- ✅ **Debug Logging**: Enabled

### Before Production Release:
1. Change `_useTestAds = true` to `false` in `ad_service.dart`
2. Change interstitial frequency from 2 to 3+ visits
3. Test with real ads thoroughly
4. Submit for AdMob app review if required

---

## 🎯 What Each Ad Type Looks Like

### Test Banner Ad:
```
┌─────────────────────────┐
│   Test Ad               │
│   [Sample Banner]       │
└─────────────────────────┘
```
- Small rectangular ad
- Shows "Test Ad" text
- Appears at bottom of screens

### Test Interstitial Ad:
```
┌─────────────────────────┐
│         [X]             │
│                         │
│    FULL SCREEN AD       │
│    Test Ad Sample       │
│                         │
│   [Learn More]          │
└─────────────────────────┘
```
- Full screen ad
- Has X close button
- Shows "Test Ad" watermark
- Appears between screen transitions

---

## ✅ Verification Checklist

Before confirming ads work:

- [ ] App fully restarted (not hot reload)
- [ ] Internet connection active
- [ ] Banner ad visible on home screen
- [ ] Banner ad visible on widget detail screen
- [ ] Interstitial ad shows after 2 widget visits
- [ ] Console logs show ad loading messages
- [ ] Ads closeable and don't crash app

---

## 🔄 Next Steps

### For Testing:
1. **Run**: `flutter run`
2. **Navigate** through app
3. **Watch** for test ads
4. **Check** console logs

### For Production:
1. Set `_useTestAds = false`
2. Increase interstitial frequency
3. Test thoroughly with real ads
4. Monitor AdMob dashboard

---

## 📞 Need Help?

If ads still don't show after following all steps:
1. Check you did FULL restart (not hot reload)
2. Share console logs
3. Verify internet connection
4. Try on different device
