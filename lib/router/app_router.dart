import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/main.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'package:octoloupe/pages/activity_page.dart';
import 'package:octoloupe/pages/admin_central_page.dart';
import 'package:octoloupe/pages/age_selection_page.dart';
import 'package:octoloupe/pages/auth_page.dart';
import 'package:octoloupe/pages/category_selection_page.dart';
import 'package:octoloupe/pages/contact_page.dart';
import 'package:octoloupe/pages/day_selection_page.dart';
import 'package:octoloupe/pages/home_page.dart';
import 'package:octoloupe/pages/reset_password_page.dart';
import 'package:octoloupe/pages/schedule_selection_page.dart';
import 'package:octoloupe/pages/sector_selection_page.dart';
import 'package:octoloupe/pages/splash_page.dart';
import 'package:octoloupe/pages/user_central_page.dart';

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashPage(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return MainPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: HomePage(),
          ),
          routes: [
            GoRoute(
              path: 'categories',
              pageBuilder: (context, state) {
                debugPrint('Arrivé dans /home/categories');
                final data = state.extra as Map<String, dynamic>;
                final isSport = data['isSport'] as bool;
                final selectedCategories = data['selectedCategories'] as List<Map<String, String>>?;

                return NoTransitionPage(
                  key: state.pageKey,
                  child: CategorySelectionPage(
                    isSport: isSport,
                    selectedCategories: selectedCategories,
                  ),
                );
              }
            ),
            GoRoute(
              path: 'ages',
              pageBuilder: (context, state) {
                debugPrint('Arrivé dans /home/ages');
                final data = state.extra as Map<String, dynamic>;
                final isSport = data['isSport'] as bool;
                final selectedAges = data['selectedAges'] as List<Map<String, String>>?;

                return NoTransitionPage(
                  key: state.pageKey,
                  child: AgeSelectionPage(
                    isSport: isSport,
                    selectedAges: selectedAges,
                  ),
                );
              }
            ),
            GoRoute(
              path: 'days',
              pageBuilder: (context, state) {
                debugPrint('Arrivé dans /home/days');
                final data = state.extra as Map<String, dynamic>;
                final isSport = data['isSport'] as bool;
                final selectedDays = data['selectedDays'] as List<Map<String, String>>?;

                return NoTransitionPage(
                  key: state.pageKey,
                  child: DaySelectionPage(
                    isSport: isSport,
                    selectedDays: selectedDays,
                  ),
                );
              }
            ),
            GoRoute(
              path: 'schedules',
              pageBuilder: (context, state) {
                debugPrint('Arrivé dans /home/schedules');
                final data = state.extra as Map<String, dynamic>;
                final isSport = data['isSport'] as bool;
                final selectedSchedules = data['selectedSchedules'] as List<Map<String, String>>?;

                return NoTransitionPage(
                  key: state.pageKey,
                  child: ScheduleSelectionPage(
                    isSport: isSport,
                    selectedSchedules: selectedSchedules,
                  ),
                );
              },
            ),
            GoRoute(
              path: 'sectors',
              pageBuilder: (context, state) {
                debugPrint('Arrivé dans /home/sectors');
                final data = state.extra as Map<String, dynamic>;
                final isSport = data['isSport'] as bool;
                final selectedSectors = data['selectedSectors'] as List<Map<String, String>>?;

                return NoTransitionPage(
                  key: state.pageKey,
                  child: SectorSelectionPage(
                    isSport: isSport,
                    selectedSectors: selectedSectors,
                  ),
                );
              },
            ),
            GoRoute(
              path: 'results',
              pageBuilder: (context, state) {
                final data = state.extra as Map<String, dynamic>;
                final filteredActivities = data['filteredActivities'] as List<Map<String, dynamic>>;

                return NoTransitionPage(
                  key: state.pageKey,
                  child: ActivityPage(
                    filteredActivities: filteredActivities,
                  ),
                );
              }
            ),
          ]
        ),
        GoRoute(
          path: '/auth',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: AuthPage(),
          ),
          routes: [
            // if user is an administrator
            GoRoute(
              path: 'admin',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AdminCentralPage(),
              ),
              /* routes: [
                GoRoute(
                  path: '',
                  pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: 
                  ),
                ),
                GoRoute(
                  path: '',
                  pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: 
                  ),
                ),
                GoRoute(
                  path: '',
                  pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: 
                  ),
                ),
                GoRoute(
                  path: '',
                  pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: 
                  ),
                ),
                GoRoute(
                  path: '',
                  pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: 
                  ),
                ),
                GoRoute(
                  path: '',
                  pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: 
                  ),
                ),
              ]
             */
            ),
            // if user is an user
            GoRoute(
              path: 'user',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: UserCentralPage(),
              )
            ),
            // if password is forgotten
            GoRoute(
              path: 'forgottenPassword',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: ResetPasswordPage(),
              )
            )
          ]
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: ContactPage(),
          ),
        ),
      ],
    )
  ]
);