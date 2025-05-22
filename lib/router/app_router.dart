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

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        /* canPopNotifier.value = false; */
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
          pageBuilder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              canPopNotifier.value = false;
            });
            return NoTransitionPage(
              key: state.pageKey,
              child: HomePage(),
            );
          },
          routes: [
            GoRoute(
              path: 'categories',
              pageBuilder: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  canPopNotifier.value = true;
                });
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  canPopNotifier.value = true;
                });
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  canPopNotifier.value = true;
                });
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  canPopNotifier.value = true;
                });
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  canPopNotifier.value = true;
                });
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  canPopNotifier.value = true;
                });
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
          pageBuilder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
                  canPopNotifier.value = false;
                });
            return NoTransitionPage(
              key: state.pageKey,
              child: AuthPage(),
            );
          },
          routes: [
            // if user is an administrator
            GoRoute(
              path: 'admin',
              pageBuilder: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  canPopNotifier.value = false;
                });
                
                return NoTransitionPage(
                  key: state.pageKey,
                  child: AdminCentralPage(),
                );
              },
              routes: [
                GoRoute(
                  path: 'interface',
                  pageBuilder: (context, state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      canPopNotifier.value = true;
                    });
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: AdminInterfacePage(),
                    );
                  },
                ),
                GoRoute(
                  path: 'activities',
                  pageBuilder: (context, state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      canPopNotifier.value = true;
                    });
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: AdminActivityPage(),
                    );
                  },
                ),
                GoRoute(
                  path: 'contact',
                  pageBuilder: (context, state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      canPopNotifier.value = true;
                    });
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: AdminContactPage(),
                    );
                  },
                ),
                GoRoute(
                  path: 'notifications',
                  pageBuilder: (context, state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      canPopNotifier.value = true;
                    });
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: UserNotificationsPage(),
                    );
                  },
                ),
                GoRoute(
                  path: 'updateCredentials',
                  pageBuilder: (context, state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      canPopNotifier.value = true;
                    });
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: UpdateCredentialsPage(),
                    );
                  },
                ),
                GoRoute(
                  path: 'addAnOtherAdministrator',
                  pageBuilder: (context, state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      canPopNotifier.value = true;
                    });
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: AdminAddAdminPage(),
                    );
                  },
                ),
              ]
            ),
            // if user is an user
            GoRoute(
              path: 'user',
              pageBuilder: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  canPopNotifier.value = false;
                });
                return NoTransitionPage(
                  key: state.pageKey,
                  child: UserCentralPage(),
                );
              },
              routes: [
                GoRoute(
                  path: 'notifications',
                  pageBuilder: (context, state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      canPopNotifier.value = true;
                    });
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: UserNotificationsPage(),
                    );
                  },
                ),
                GoRoute(
                  path: 'updateCredentials',
                  pageBuilder: (context, state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      canPopNotifier.value = true;
                    });
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: UpdateCredentialsPage(),
                    );
                  },
                ),
              ],

            ),
            // if password is forgotten
            GoRoute(
              path: 'forgottenPassword',
              pageBuilder: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  canPopNotifier.value = true;
                });
                return NoTransitionPage(
                  key: state.pageKey,
                  child: ResetPasswordPage(),
                );
              },
            )
          ]
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              canPopNotifier.value = false;
            });
            return NoTransitionPage(
              key: state.pageKey,
              child: ContactPage(),
            );
          },
        ),
        GoRoute(
          path: '/legalNotices',
          pageBuilder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              canPopNotifier.value = false;
            });
            return NoTransitionPage(
            key: state.pageKey,
            child: LegalNoticesPage(),
            );
          },
        ),
        GoRoute(
          path: '/GCU',
          pageBuilder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              canPopNotifier.value = false;
            });
            return NoTransitionPage(
              key: state.pageKey,
              child: GCUPage(),
            );
          },
        ),
        GoRoute(
          path: '/privacyPolicy',
          pageBuilder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              canPopNotifier.value = false;
            });
            return NoTransitionPage(
              key: state.pageKey,
              child: PrivacyPolicyPage(),
            );
          },
        ),
      ],
    )
  ],
  observers: [
    NavigatorObserverWithCanPop(),
  ]
);