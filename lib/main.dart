import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shell_route/async_notifier.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

// ShellRoute を使用してネストされたナビゲーションを実装する方法を説明する。
// これは、追加のナビゲータをウィジェットツリーに配置しルートナビゲータの代わりに使用するパターンである。
// これにより、ディープリンクでページを BottomNavigationBar などの他の UI コンポーネントと一緒に表示することができる。
//// 'parentNavigatorKey' を使用することによって、別のナビゲータ（ルートナビゲータなど）を使用して画面をプッシュする方法を示す。

void main() => runApp(ProviderScope(child: ShellRouteExampleApp()));

class ShellRouteExampleApp extends StatelessWidget {
  ShellRouteExampleApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/a',
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: <RouteBase>[
          /// ボトムバーの 1 つ目の画面
          GoRoute(
            path: '/a',
            builder: (BuildContext context, GoRouterState state) {
              return const ScreenA();
            },
            routes: <RouteBase>[
              // 内側のナビゲータに重ねて表示する詳細画面。
              // 画面 A にかぶさる形で表示されるが、アプリケーションシェルはカバーされない。
              GoRoute(
                path: 'details',
                builder: (BuildContext context, GoRouterState state) {
                  return const DetailsScreen(label: 'A');
                },
              ),
            ],
          ),

          /// ボトムバーの 2 つ目のタブが選択されたとき
          GoRoute(
            path: '/b',
            builder: (BuildContext context, GoRouterState state) {
              return const ScreenB();
            },
            routes: <RouteBase>[
              /// a/details と同じだが、[parentNavigatorKey]を指定することで
              /// ルートナビゲータに表示される。
              /// よって画面 B とアプリケーションシェルの両方がカバーされる。
              GoRoute(
                path: 'details',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (BuildContext context, GoRouterState state) {
                  return const DetailsScreen(label: 'B');
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

/// BottomNavigationBar を持つ Scaffold を構築することによって、
/// アプリの「シェル」を構築し、Scaffold の本体に[child]を配置する。
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  /// Scaffold の body に表示する Widget のこと。
  /// つまりここでは Navigator を意味する。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'A Screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'B Screen',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final route = GoRouter.of(context);
    final location = route.location;
    if (location.startsWith('/a')) {
      return 0;
    }
    if (location.startsWith('/b')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/a');
        break;
      case 1:
        GoRouter.of(context).go('/b');
        break;
    }
  }
}

/// ボトムバーの 1 つ目の画面
class ScreenA extends ConsumerWidget {
  const ScreenA({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('www'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/a/details');
              },
              child: const Text('View A details'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ボトムバーの 2 つ目の画面
class ScreenB extends StatelessWidget {
  const ScreenB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Screen B'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/b/details');
              },
              child: const Text('View B details'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A, B いずれかの詳細画面
class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(asyncControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
      ),
      body: Center(
        child: Text(
          '''
          Details for $label

          $state
          ''',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
