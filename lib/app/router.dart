import 'package:go_router/go_router.dart';

import '../core/storage/preferences_store.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/shell/app_shell.dart';

GoRouter createRouter(PreferencesStore preferences) {
  return GoRouter(
    initialLocation:
        preferences.hasCompletedOnboarding ? '/home' : '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      GoRoute(path: '/home', builder: (_, __) => const AppShell()),
    ],
  );
}
