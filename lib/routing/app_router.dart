import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/lessons/lessons_screen.dart';
import '../features/practice/practice_screen.dart';
import '../features/premium/premium_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/lessons/lesson_detail_screen.dart';
import '../features/quizzes/quiz_screen.dart';
import '../features/grammar/grammar_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/profile_screen.dart';

GoRouter buildRouter({required bool onboarded}) {
  return GoRouter(
    initialLocation: onboarded ? '/' : '/onboarding',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => const NoTransitionPage(child: OnboardingScreen()),
      ),
      GoRoute(
        path: '/lessons',
        name: 'lessons',
        pageBuilder: (context, state) => const NoTransitionPage(child: LessonsScreen()),
      ),
      GoRoute(
        path: '/lesson',
        name: 'lessonDetail',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final categoryId = extra?['categoryId'] as String? ?? '';
          final title = extra?['title'] as String? ?? 'Lesson';
          return NoTransitionPage(child: LessonDetailScreen(categoryId: categoryId, title: title));
        },
      ),
      GoRoute(
        path: '/quiz',
        name: 'quiz',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final categoryId = extra?['categoryId'] as String? ?? '';
          final title = extra?['title'] as String? ?? 'Quiz';
          return NoTransitionPage(child: QuizScreen(categoryId: categoryId, title: title));
        },
      ),
      GoRoute(
        path: '/grammar',
        name: 'grammar',
        pageBuilder: (context, state) => const NoTransitionPage(child: GrammarScreen()),
      ),
      GoRoute(
        path: '/practice',
        name: 'practice',
        pageBuilder: (context, state) => const NoTransitionPage(child: PracticeScreen()),
      ),
      GoRoute(
        path: '/premium',
        name: 'premium',
        pageBuilder: (context, state) => const NoTransitionPage(child: PremiumScreen()),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => const NoTransitionPage(child: SettingsScreen()),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
      ),
    ],
  );
}
