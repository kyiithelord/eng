import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/lessons/lessons_screen.dart';
import '../features/practice/practice_screen.dart';
import '../features/premium/premium_screen.dart';
import '../features/settings/settings_screen.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
      ),
      GoRoute(
        path: '/lessons',
        name: 'lessons',
        pageBuilder: (context, state) => const NoTransitionPage(child: LessonsScreen()),
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
    ],
  );
}
