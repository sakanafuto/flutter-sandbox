import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shell_route/ui/details_screen.dart';
import 'package:shell_route/ui/root_screen.dart';
import 'package:shell_route/scaffold_with_shell_nav_bar.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final routeProvider = Provider(
  (ref) => GoRouter(
    initialLocation: '/b',
    navigatorKey: rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithShellNavBar(context: context, child: child);
        },
        routes: [
          GoRoute(
            path: '/a',
            pageBuilder: (context, state) => NoTransitionPage<dynamic>(
              child: RootScreen(label: 'a'),
            ),
            routes: [
              GoRoute(
                path: 'details',
                builder: (context, state) => DetailsScreen(
                  icon: const Icon(Icons.ramen_dining),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/b',
            pageBuilder: (context, state) => NoTransitionPage<dynamic>(
              child: RootScreen(label: 'b'),
            ),
            routes: [
              GoRoute(
                path: 'details',
                builder: (context, state) => DetailsScreen(
                  icon: const Icon(Icons.ramen_dining_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);
