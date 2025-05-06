import 'package:flutter/material.dart';
import 'package:octoloupe/router/app_router.dart';

class NavigatorObserverWithCanPop extends NavigatorObserver {
  void _updateCanPop(NavigatorState? nav) {
    if (nav != null) {
      final canPop = nav.canPop();
      canPopNotifier.value = canPop;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateCanPop(route.navigator);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _updateCanPop(route.navigator);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _updateCanPop(route.navigator);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _updateCanPop(newRoute?.navigator);
  }
}

/* 
class NavigatorObserverWithCanPop extends NavigatorObserver {
  void _updateCanPop(NavigatorState? nav) {
    if (nav != null) {
      final canPop = nav.canPop();
      canPopNotifier.value = canPop;
      debugPrint('🧭 NavigatorObserver: canPop = $canPop');
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateCanPop(route.navigator);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _updateCanPop(route.navigator);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _updateCanPop(route.navigator);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _updateCanPop(newRoute?.navigator);
  }
}
 */