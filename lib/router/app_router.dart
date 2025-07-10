import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/main.dart';
import 'package:octoloupe/pages/activity_page.dart';
import 'package:octoloupe/pages/admin_activity_page.dart';
import 'package:octoloupe/pages/admin_add_admin_page.dart';
import 'package:octoloupe/pages/admin_central_page.dart';
import 'package:octoloupe/pages/admin_contact_page.dart';
import 'package:octoloupe/pages/admin_interface_page.dart';
import 'package:octoloupe/pages/age_selection_page.dart';
import 'package:octoloupe/pages/auth_page.dart';
import 'package:octoloupe/pages/category_selection_page.dart';
import 'package:octoloupe/pages/contact_page.dart';
import 'package:octoloupe/pages/day_selection_page.dart';
import 'package:octoloupe/pages/general_conditions_of_use_page.dart';
import 'package:octoloupe/pages/home_page.dart';
import 'package:octoloupe/pages/legal_notices_page.dart';
import 'package:octoloupe/pages/privacy_policy_page.dart';
import 'package:octoloupe/pages/reset_password_page.dart';
import 'package:octoloupe/pages/schedule_selection_page.dart';
import 'package:octoloupe/pages/sector_selection_page.dart';
import 'package:octoloupe/pages/splash_page.dart';
import 'package:octoloupe/pages/update_credentials_page.dart';
import 'package:octoloupe/pages/user_central_page.dart';
import 'package:octoloupe/pages/user_notifications_page.dart';
import 'package:octoloupe/router/router_config.dart';

final ValueNotifier<bool> canPopNotifier = ValueNotifier(false);

Page<void> buildPage({
  required GoRouterState state,
  required Widget child,
  bool canPop = false,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    canPopNotifier.value = canPop;
  });

  return NoTransitionPage(
    key: state.pageKey,
    child: child,
  );
}

T getExtra<T>(GoRouterState state, String key) {
  final data = state.extra as Map<String, dynamic>;
  return data[key] as T;
}

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const SplashPage();
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        return MainPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => buildPage(
            state: state,
            canPop: false,
            child: HomePage(),
          ),
          routes: [
            GoRoute(
              path: 'categories',
              pageBuilder: (context, state) => buildPage(
                state: state,
                canPop: true,
                child: CategorySelectionPage(
                  isSport: getExtra<bool>(state, 'isSport'),
                  selectedCategories: getExtra<List<Map<String, String>>?>(state, 'selectedCategories'),
                ),
              ),
            ),
            GoRoute(
              path: 'ages',
              pageBuilder: (context, state) => buildPage(
                state: state,
                canPop: true,
                child: AgeSelectionPage(
                  isSport: getExtra<bool>(state, 'isSport'),
                  selectedAges: getExtra<List<Map<String, String>>?>(state, 'selectedAges'),
                ),
              ),
            ),
            GoRoute(
              path: 'days',
              pageBuilder: (context, state) => buildPage(
                state: state,
                canPop: true,
                child: DaySelectionPage(
                  isSport: getExtra<bool>(state, 'isSport'),
                  selectedDays: getExtra<List<Map<String, String>>?>(state, 'selectedDays'),
                ),
              ),
            ),
            GoRoute(
              path: 'schedules',
              pageBuilder: (context, state) => buildPage(
                state: state,
                canPop: true,
                child: ScheduleSelectionPage(
                  isSport: getExtra<bool>(state, 'isSport'),
                  selectedSchedules: getExtra<List<Map<String, String>>?>(state, 'selectedSchedules'),
                ),
              ),
            ),
            GoRoute(
              path: 'sectors',
              pageBuilder: (context, state) => buildPage(
                state: state,
                canPop: true,
                child: SectorSelectionPage(
                  isSport: getExtra<bool>(state, 'isSport'),
                  selectedSectors: getExtra<List<Map<String, String>>?>(state, 'selectedSectors'),
                ),
              ),
            ),
            GoRoute(
              path: 'results',
              pageBuilder: (context, state) => buildPage(
                state: state,
                canPop: true,
                child: ActivityPage(
                  filteredActivities: getExtra<List<Map<String, dynamic>>>(state, 'filteredActivities'),
                ),
              ),
            ),
          ]
        ),
        GoRoute(
          path: '/auth',
          pageBuilder: (context, state) => buildPage(
            state: state,
            canPop: false,
            child: AuthPage(),
          ),
          routes: [
            // if user is an administrator
            ..._adminRoutes,
            // if user is an user
            ..._userRoutes,
            // if password is forgotten
            GoRoute(
              path: 'forgottenPassword',
              pageBuilder: (context, state) => buildPage(
                state: state,
                canPop: true,
                child: ResetPasswordPage(),
              ),
            )
          ]
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) => buildPage(
            state: state,
            canPop: false,
            child: ContactPage(),
          ),
        ),
        GoRoute(
          path: '/legalNotices',
          pageBuilder: (context, state) => buildPage(
            state: state,
            canPop: false,
            child: LegalNoticesPage(),
          ),
        ),
        GoRoute(
          path: '/GCU',
          pageBuilder: (context, state) => buildPage(
            state: state,
            canPop: false,
            child: GCUPage(),
          ),
        ),
        GoRoute(
          path: '/privacyPolicy',
          pageBuilder: (context, state) => buildPage(
            state: state,
            canPop: false,
            child: PrivacyPolicyPage(),
          ),
        ),
      ],
    )
  ],
  observers: [
    NavigatorObserverWithCanPop(),
  ]
);

final _adminRoutes = [
  GoRoute(
    path: 'admin',
    pageBuilder: (context, state) => buildPage(
      state: state,
      canPop: false,
      child: AdminCentralPage(),
    ),
    routes: [
      GoRoute(
        path: 'interface',
        pageBuilder: (context, state) => buildPage(
          state: state,
          canPop: true,
          child: AdminInterfacePage(),
        ),
      ),
      GoRoute(
        path: 'activities',
        pageBuilder: (context, state) => buildPage(
          state: state,
          canPop: true,
          child: AdminActivityPage(),
        ),
      ),
      GoRoute(
        path: 'contact',
        pageBuilder: (context, state) => buildPage(
          state: state,
          canPop: true,
          child: AdminContactPage(),
        ),
      ),
      GoRoute(
        path: 'notifications',
        pageBuilder: (context, state) => buildPage(
          state: state,
          canPop: true,
          child: UserNotificationsPage(),
        ),
      ),
      GoRoute(
        path: 'updateCredentials',
        pageBuilder: (context, state) => buildPage(
          state: state,
          canPop: true,
          child: UpdateCredentialsPage(),
        ),
      ),
      GoRoute(
        path: 'addAnOtherAdministrator',
        pageBuilder: (context, state) => buildPage(
          state: state,
          canPop: true,
          child: AdminAddAdminPage(),
        ),
      ),
    ]
  ),
];

final _userRoutes = [
  GoRoute(
    path: 'user',
    pageBuilder: (context, state) => buildPage(
      state: state,
      canPop: false,
      child: UserCentralPage(),
    ),
    routes: [
      GoRoute(
        path: 'notifications',
        pageBuilder: (context, state) => buildPage(
          state: state,
          canPop: true,
          child: UserNotificationsPage(),
        ),
      ),
      GoRoute(
        path: 'updateCredentials',
        pageBuilder: (context, state) => buildPage(
          state: state,
          canPop: true,
          child: UpdateCredentialsPage(),
        ),
      ),
    ],
  ),
];