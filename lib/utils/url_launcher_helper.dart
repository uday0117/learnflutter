import 'package:flutter/material.dart';
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
  static const String flutterDocsUrl = 'https://docs.flutter.dev/ui/widgets';

  /// Launch URL with error handling
  static Future<void> launchURL(
    String url, {
    LaunchMode mode = LaunchMode.inAppWebView,
  }) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
      } else {
        Get.snackbar(
          'Error',
          'Could not open URL',
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
    await launchURL(privacyPolicyUrl);
  }

  /// Open Terms and Conditions
  static Future<void> openTermsAndConditions() async {
    await launchURL(termsAndConditionsUrl);
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
      path: ' apps.uksolutions@gmail.com',
      queryParameters: {'subject': 'Learn Flutter App - Feedback'},
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar(
          'Email',
          ' apps.uksolutions@gmail.com',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Email',
        ' apps.uksolutions@gmail.com',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
