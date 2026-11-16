import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  // GitHub Pages URLs
  static const String privacyPolicyUrl =
      'https://uday0117.github.io/learnflutter/privacy_policy.html';
  static const String termsAndConditionsUrl =
      'https://uday0117.github.io/learnflutter/terms_and_conditions.html';
  static const String githubRepoUrl =
      'https://github.com/uday0117/learnflutter';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.uksolutions.learnflutter';
  static const String flutterDocsUrl = 'https://docs.flutter.dev/ui/widgets';
  static const String supportEmail = 'apps.uksolutions@gmail.com';

  /// Open Google Play Store page
  static Future<void> openPlayStore() async {
    await launchURL(playStoreUrl, mode: LaunchMode.externalApplication);
  }

  /// Launch URL with error handling
  static Future<void> launchURL(
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
      } else {
        Get.snackbar(
          'Error',
          'Could not open URL: $url',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open URL: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Open Privacy Policy
  static Future<void> openPrivacyPolicy() async {
    await launchURL(privacyPolicyUrl, mode: LaunchMode.externalApplication);
  }

  /// Open Terms and Conditions
  static Future<void> openTermsAndConditions() async {
    await launchURL(termsAndConditionsUrl, mode: LaunchMode.externalApplication);
  }

  /// Open GitHub Repository
  static Future<void> openGitHubRepo() async {
    await launchURL(githubRepoUrl, mode: LaunchMode.externalApplication);
  }

  /// Open Flutter Documentation
  static Future<void> openFlutterDocs() async {
    await launchURL(flutterDocsUrl, mode: LaunchMode.externalApplication);
  }

  /// Open email to contact support
  static Future<void> openEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: {'subject': 'Learn Flutter App - Feedback'},
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
    } catch (_) {}

    // Fallback: Copy to clipboard and notify
    await Clipboard.setData(const ClipboardData(text: supportEmail));
    Get.snackbar(
      'contact_us'.tr,
      '${'email_copied'.tr} ($supportEmail)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E88E5),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
}
