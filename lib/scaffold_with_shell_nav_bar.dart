import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const tabs = [
  ScaffoldWithShellNavBarTabItem(
    initialLocation: '/a',
    icon: Icon(Icons.home),
    label: 'Section A',
  ),
  ScaffoldWithShellNavBarTabItem(
    initialLocation: '/b',
    icon: Icon(Icons.settings),
    label: 'Section B',
  ),
];

class ScaffoldWithShellNavBar extends ConsumerWidget {
  const ScaffoldWithShellNavBar({
    super.key,
    required this.context,
    required this.child,
  });

  final Widget child;
  final BuildContext context;

  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  int _locationToTabIndex(String location) {
    final index =
        tabs.indexWhere((t) => location.startsWith(t.initialLocation));
    return index < 0 ? 0 : index;
  }

  void _onItemTapped(BuildContext context, int tabIndex) {
    if (tabIndex != _currentIndex) {
      context.go(tabs[tabIndex].initialLocation);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: tabs,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}

class ScaffoldWithShellNavBarTabItem extends BottomNavigationBarItem {
  const ScaffoldWithShellNavBarTabItem({
    required this.initialLocation,
    required super.icon,
    super.label,
  });
  final String initialLocation;
}
