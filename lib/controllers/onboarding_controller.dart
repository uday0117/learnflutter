import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final storage = GetStorage();

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Welcome to Learn Flutter',
      description:
          'Master Flutter development with comprehensive tutorials, examples, and real-world projects',
      imagePath: 'assets/images/onboarding1.png',
      icon: Icons.flutter_dash,
      color: const Color(0xFF02569B),
    ),
    OnboardingPage(
      title: 'Learn by Building',
      description:
          'Access 50+ tutorials, UI examples, and code snippets. Practice with hands-on projects',
      imagePath: 'assets/images/onboarding2.png',
      icon: Icons.code,
      color: const Color(0xFFFFA726),
    ),
    OnboardingPage(
      title: 'Prepare for Success',
      description:
          'Get interview-ready with curated questions and answers. Track your favorite topics',
      imagePath: 'assets/images/onboarding3.png',
      icon: Icons.star,
      color: const Color(0xFF66BB6A),
    ),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    storage.write('onboarding_complete', true);
    Get.offAllNamed(AppRoutes.home);
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
    required this.color,
  });
}
