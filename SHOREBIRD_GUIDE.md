# Shorebird Code Push Integration Guide

Shorebird brings over-the-air (OTA) code push capabilities to **Learn Flutter**, enabling instant bug fixes, UI updates, and asset changes to be delivered directly to users without waiting for Google Play or App Store review.

Shorebird works **automatically in the background with zero Dart code changes**:
- On app launch, Shorebird checks for patches silently.
- When an update is downloaded, it automatically applies on the next app restart.

---

## 1. Prerequisites & CLI Installation

### Install the Shorebird CLI
Run the following command in your terminal:
```bash
curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash
```

### Add Shorebird to PATH
If not automatically added, add this to your `~/.zshrc`:
```bash
export PATH="$HOME/.shorebird/bin:$PATH"
```
Then reload your terminal:
```bash
source ~/.zshrc
```

Verify installation:
```bash
shorebird doctor
```

---

## 2. Authentication & Project Initialization

### Step 1: Login to Shorebird
```bash
shorebird login
```
This opens your browser to sign in with your Google account.

### Step 2: Initialize Shorebird for this project
Inside this project directory (`learnflutter/`):
```bash
shorebird init
```
This command will:
1. Register **Learn Flutter** with your Shorebird account.
2. Generate a `shorebird.yaml` file containing your unique `app_id`.
3. Verify permissions (the required `INTERNET` permission is already in [AndroidManifest.xml](file:///Users/mac/Documents/uksolutions/learnflutter/android/app/src/main/AndroidManifest.xml)).

Commit the generated `shorebird.yaml` to git:
```bash
git add shorebird.yaml
git commit -m "chore: add shorebird.yaml"
```

---

## 3. Release Workflow (Deploying Base Binary)

Whenever you submit a new base build to Google Play Console (or Apple App Store), build it using Shorebird instead of `flutter build`:

### Android (App Bundle for Play Store):
```bash
shorebird release android
```
> The generated `.aab` file will be located in `build/app/outputs/bundle/release/app-release.aab`. Upload this bundle to Google Play Console as usual.

### iOS (IPA for App Store):
```bash
shorebird release ios
```

---

## 4. Patch Workflow (Instant Over-The-Air Update)

When you make bug fixes, content updates, or UI tweaks and want to push them instantly to existing users:

### Android Patch:
```bash
shorebird patch android
```

### iOS Patch:
```bash
shorebird patch ios
```

Shorebird will:
1. Verify the patch against the active release.
2. Build the patch diff.
3. Upload and deploy it instantly to users running that release version.

---

## 5. Testing Patches Locally (Shorebird Preview)

Before publishing to production users, you can preview the release and patch on a connected physical device or emulator:

```bash
shorebird preview
```
This downloads and tests the patched version on your device directly.

---

## 6. Useful Shorebird Commands

| Command | Purpose |
|---|---|
| `shorebird doctor` | Checks environment health and dependencies |
| `shorebird releases list` | Lists all published release versions |
| `shorebird patches list` | Lists all patches pushed to releases |
| `shorebird apps list` | Lists your registered Shorebird apps |
