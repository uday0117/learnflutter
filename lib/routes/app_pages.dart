import 'package:get/get.dart';

import '../bindings/home_binding.dart';
import '../bindings/onboarding_binding.dart';
import '../bindings/splash_binding.dart';
import '../views/api_integration/api_integration_screen.dart';
import '../views/favorites/favorites_screen.dart';
import '../views/firebase/firebase_screen.dart';
import '../views/flutter_basics/flutter_basics_detail_screen.dart';
import '../views/flutter_basics/flutter_basics_screen.dart';
import '../views/home/home_screen.dart';
import '../views/interview_questions/interview_questions_screen.dart';
import '../views/interview_questions/question_detail_screen.dart';
import '../views/onboarding/onboarding_screen.dart';
import '../views/projects/projects_screen.dart';
import '../views/search/search_screen.dart';
import '../views/splash/splash_screen.dart';
import '../views/state_management/state_management_screen.dart';
import '../views/ui_examples/ui_example_detail_screen.dart';
import '../views/ui_examples/ui_examples_screen.dart';
import '../views/widgets/widget_detail_screen.dart';
import '../views/widgets/widgets_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.flutterBasics,
      page: () => const FlutterBasicsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.flutterBasicsDetail,
      page: () => const FlutterBasicsDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.flutterWidgets,
      page: () => const WidgetsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.widgetDetail,
      page: () => const WidgetDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.uiExamples,
      page: () => const UIExamplesScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.uiExampleDetail,
      page: () => const UIExampleDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.stateManagement,
      page: () => const StateManagementScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.apiIntegration,
      page: () => const APIIntegrationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.firebase,
      page: () => const FirebaseScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.projects,
      page: () => const ProjectsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.interviewQuestions,
      page: () => const InterviewQuestionsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.questionDetail,
      page: () => const QuestionDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
