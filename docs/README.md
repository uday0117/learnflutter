# LearnFlutter - GitHub Pages Documentation

This folder contains the privacy policy and terms & conditions for the LearnFlutter mobile app.

## Files

- `index.html` - Landing page with links to policies
- `privacy_policy.html` - Privacy Policy
- `terms_and_conditions.html` - Terms and Conditions

## Setup GitHub Pages

Follow these steps to publish these pages on GitHub Pages:

### 1. Push to GitHub

If you haven't already, push your project to GitHub:

```bash
git add docs/
git commit -m "Add privacy policy and terms & conditions"
git push origin main
```

### 2. Enable GitHub Pages

1. Go to your repository on GitHub
2. Click on **Settings** (top right)
3. Scroll down to **Pages** section (left sidebar)
4. Under **Source**, select:
   - Branch: `main`
   - Folder: `/docs`
5. Click **Save**

### 3. Access Your Pages

After a few minutes, your pages will be available at:

```
https://YOUR-USERNAME.github.io/learnflutter/
```

Replace `YOUR-USERNAME` with your GitHub username.

### Direct URLs

- **Privacy Policy**: `https://YOUR-USERNAME.github.io/learnflutter/privacy_policy.html`
- **Terms & Conditions**: `https://YOUR-USERNAME.github.io/learnflutter/terms_and_conditions.html`

## Usage in App

You can use these URLs in your Flutter app for displaying policies:

```dart
import 'package:url_launcher/url_launcher.dart';

Future<void> openPrivacyPolicy() async {
  final url = Uri.parse('https://YOUR-USERNAME.github.io/learnflutter/privacy_policy.html');
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  }
}

Future<void> openTermsAndConditions() async {
  final url = Uri.parse('https://YOUR-USERNAME.github.io/learnflutter/terms_and_conditions.html');
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  }
}
```

## Updating Content

To update the policies:

1. Edit the HTML files in the `docs/` folder
2. Commit and push changes to GitHub
3. GitHub Pages will automatically update within a few minutes

## Contact

**Developer:** UK Solutions  
**Email:** apps.uksolutions@gmail.com  
**Location:** Bangalore, Karnataka, India

---

*Last Updated: May 27, 2026*
